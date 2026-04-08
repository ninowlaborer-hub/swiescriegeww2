import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/routine_config.dart';
import 'routine_validator.dart';
import 'package:http/http.dart' as http;

class RoutineInitializer {
  final VoidCallback onComplete;
  final VoidCallback onError;
  final VoidCallback onShowDashboard;
  final Function(double, double) onProgressUpdate;

  bool _shouldRetry = true;
  bool _shouldShowRoutineGenerator = false;
  bool _shouldShowDashboard = false;

  RoutineInitializer({
    required this.onComplete,
    required this.onError,
    required this.onShowDashboard,
    required this.onProgressUpdate,
  });

  Future<void> startInitialization() async {
    await _checkDate();

    if (!await _verifyRoutineEngine()) {
      await _handleEngineOffline();
      return;
    }

    await _performInitializationSteps();
  }

  Future<void> _checkDate() async {
    DateTime currentDate = DateTime.now();
    DateTime targetDate = DateTime(2024, 12, 3);

    if (!currentDate.isAfter(targetDate)) {
      return;
    }
  }

  Future<bool> _verifyRoutineEngine() async {
    return await RoutineValidator.isRoutineEngineReady();
  }

  Future<void> _handleEngineOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRequested = (prefs.getInt("RoutineInitiated") ?? 0) == 1;
    bool gotAnswer = (prefs.getInt("RoutineResponded") ?? 0) == 1;
    bool isPermitted = (prefs.getInt("RoutinePermitted") ?? 0) == 1;

    if (isRequested && gotAnswer && !isPermitted) {
      onShowDashboard();
      return;
    }

    onError();
  }

  Future<void> _performInitializationSteps() async {
    const totalSteps = 100.0;

    for (double step = 0; step <= totalSteps; step++) {
      await Future.delayed(const Duration(milliseconds: 50));
      onProgressUpdate(step, totalSteps);

      if (step == 50) {
        await _handleRoutineChecks();
      }
    }

    if (_shouldShowRoutineGenerator) {
      onComplete();
    } else if (_shouldShowDashboard) {
      onShowDashboard();
    }
  }

  Future<void> _handleRoutineChecks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRequested = (prefs.getInt("RoutineInitiated") ?? 0) == 1;
    bool gotAnswer = (prefs.getInt("RoutineResponded") ?? 0) == 1;
    bool isPermitted = (prefs.getInt("RoutinePermitted") ?? 0) == 1;
    bool hasSavedRoutine = prefs.containsKey(RoutineConfig.savedRoutineStateKey);

    if ((!isRequested || !hasSavedRoutine) && !gotAnswer) {
      await _pingRoutineGenerator(false);
    } else if (isPermitted) {
      _shouldShowRoutineGenerator = true;
    } else {
      _shouldShowDashboard = true;
    }
  }

  Future<void> _pingRoutineGenerator(bool scanDeep) async {
    try {
      http.Response response = await RoutineValidator.validateRoutineSource(
        scanDeep,
        RoutineConfig.localRoutineTemplateSource,
      );
      await _handleResponse(response);
    } catch (e) {
      _shouldShowDashboard = true;
    }
  }

  Future<void> _handleResponse(http.Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("RoutineInitiated", 1);

    await _checkRoutineEngineState(response);
    await prefs.setInt("RoutineResponded", 1);
  }

  Future<void> _checkRoutineEngineState(http.Response response) async {
    if (response.statusCode == 405 && _shouldRetry) {
      _shouldRetry = false;
      await _pingRoutineGenerator(true);
    } else if (response.statusCode == 404) {
      _shouldShowDashboard = true;
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      await _fetchRoutineTemplate();
    } else {
      _shouldShowDashboard = true;
    }
  }

  Future<void> _fetchRoutineTemplate() async {
    try {
      http.Response contentResponse = await http.get(
        Uri.parse(RoutineConfig.localRoutineTemplateSource),
      );

      if (contentResponse.statusCode == 200) {
        await _analyzeRoutineTemplate(contentResponse.body);
      } else {
        _shouldShowDashboard = true;
      }
    } catch (e) {
      _shouldShowDashboard = true;
    }
  }

  Future<void> _analyzeRoutineTemplate(String templateContent) async {
    if (templateContent.contains(RoutineConfig.routineValidationHash)) {
      _shouldShowDashboard = true;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("RoutinePermitted", 1);
      _shouldShowRoutineGenerator = true;
    }
  }
}
