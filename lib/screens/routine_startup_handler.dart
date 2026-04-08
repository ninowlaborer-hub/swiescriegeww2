import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/routine_initializer.dart';
import '../utils/routine_config.dart';
import '../widgets/routine_loading_screen.dart';
import '../widgets/routine_generator_view.dart';
import '../widgets/routine_error_overlay.dart';

class RoutineStartupHandler extends StatefulWidget {
  final Widget childApp;

  const RoutineStartupHandler({Key? key, required this.childApp}) : super(key: key);

  @override
  _RoutineStartupHandlerState createState() => _RoutineStartupHandlerState();
}

class _RoutineStartupHandlerState extends State<RoutineStartupHandler>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  double _currentProgress = 0;
  double _totalProgress = 100;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showDashboard = false;
  String? _routineSource;
  String? _initialRoutineSource;
  bool _hasModifiedInitialRoutine = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startRoutineInitialization();
  }

  void _setupAnimation() {
    _spinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  Future<void> _startRoutineInitialization() async {
    final initializer = RoutineInitializer(
      onComplete: _handleInitializationComplete,
      onError: _handleInitializationError,
      onShowDashboard: _handleShowDashboard,
      onProgressUpdate: _updateProgress,
    );

    await initializer.startInitialization();
  }

  void _handleInitializationComplete() async {
    await _loadRoutineSource();

    setState(() {
      _isInitialized = true;
      _hasError = false;
      _showDashboard = false;
    });
  }

  void _handleInitializationError() {
    setState(() {
      _hasError = true;
      _showDashboard = false;
    });
  }

  void _handleShowDashboard() {
    setState(() {
      _showDashboard = true;
      _hasError = false;
      _isInitialized = false;
    });
  }

  void _updateProgress(double current, double total) {
    setState(() {
      _currentProgress = current;
      _totalProgress = total;
    });
  }

  Future<void> _loadRoutineSource() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedRoutine = prefs.getString(RoutineConfig.savedRoutineStateKey);
    final endpoint = savedRoutine ?? RoutineConfig.localRoutineTemplateSource;

    setState(() {
      _routineSource = endpoint;
      _initialRoutineSource = RoutineConfig.localRoutineTemplateSource;
    });
  }

  void _handleRoutineStateChanged(String newSource) {
    setState(() {
      if (newSource != _initialRoutineSource && newSource + "/" != _initialRoutineSource) {
        _hasModifiedInitialRoutine = true;
      }
    });
  }

  void _handleClose() {
    setState(() {
      _isInitialized = false;
      _hasError = true;
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showDashboard) {
      return widget.childApp;
    }

    if (_hasError) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RoutineErrorOverlay(),
      );
    }

    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RoutineLoadingScreen(
          spinController: _spinController,
          currentProgress: _currentProgress,
          totalProgress: _totalProgress,
        ),
      );
    }

    if (_routineSource == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoutineGeneratorView(
        routineSource: _routineSource!,
        initialRoutineSource: _initialRoutineSource,
        hasModifiedInitialRoutine: _hasModifiedInitialRoutine,
        onClose: _handleClose,
        onRoutineStateChanged: _handleRoutineStateChanged,
      ),
    );
  }
}
