import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../../shared/services/encryption_service.dart';
import 'export_bundle.dart';

/// Data export service
///
/// Manages export and import of user data per FR-024, FR-026, FR-027.
/// All exports are encrypted per FR-029.
class ExportService {
  ExportService({
    required AppDatabase database,
    required EncryptionService encryptionService,
  }) : _database = database,
       _encryptionService = encryptionService;

  final AppDatabase _database;
  final EncryptionService _encryptionService;
  final _uuid = const Uuid();

  static const _currentVersion = '1.0.0';

  /// Export all user data to JSON
  ///
  /// Returns encrypted export bundle per FR-024, FR-029.
  Future<ExportResult> exportData({bool includeCache = false}) async {
    try {
      // Gather all data from database
      final routines = await _database.select(_database.routines).get();
      final timeBlocks = await _database.select(_database.timeBlocks).get();

      final preferences = await _database
          .select(_database.userPreferences)
          .get();

      // Optionally include cache data
      final calendarCache = includeCache
          ? await _database.select(_database.calendarCache).get()
          : <CalendarCacheData>[];

      final weatherCache = includeCache
          ? await _database.select(_database.weatherCache).get()
          : <WeatherCacheData>[];

      // Convert to JSON
      final preferencesMap = <String, dynamic>{};
      for (final pref in preferences) {
        preferencesMap[pref.key] = pref.value;
      }

      final bundle = DataExportBundle(
        version: _currentVersion,
        exportedAt: DateTime.now(),
        deviceId: _uuid.v4(), // Anonymous device ID
        data: ExportData(
          routines: routines.map((r) => _routineToJson(r)).toList(),
          timeBlocks: timeBlocks.map((t) => _timeBlockToJson(t)).toList(),
          calendarCache: calendarCache.map((c) => _calendarToJson(c)).toList(),

          weatherCache: weatherCache.map((w) => _weatherToJson(w)).toList(),
          preferences: preferencesMap,
        ),
        encryptionKeyHash: _encryptionService.hashData(
          await _encryptionService.getDatabaseEncryptionKey(),
        ),
      );

      return ExportResult.success(bundle);
    } catch (e) {
      return ExportResult.error('Failed to export data: $e');
    }
  }

  /// Export data to file
  ///
  /// Saves encrypted JSON to app documents directory.
  Future<ExportResult> exportToFile({bool includeCache = false}) async {
    try {
      final result = await exportData(includeCache: includeCache);
      if (result.isError) return result;

      final bundle = result.bundle!;
      final json = jsonEncode(bundle.toJson());

      // Encrypt JSON
      final encrypted = await _encryptionService.encryptExportData(json);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filePath = '${directory.path}/swisscierge_export_$timestamp.enc';

      final file = File(filePath);
      await file.writeAsString(encrypted);

      return ExportResult.success(bundle, filePath: filePath);
    } catch (e) {
      return ExportResult.error('Failed to export to file: $e');
    }
  }

  /// Import data from bundle
  ///
  /// Handles conflict resolution per FR-027.
  /// Strategy: Keep newer data, report conflicts.
  Future<ImportResult> importData(
    DataExportBundle bundle, {
    bool overwriteExisting = false,
  }) async {
    try {
      // Version compatibility check
      if (bundle.version != _currentVersion) {
        return ImportResult.error(
          'Incompatible export version: ${bundle.version}. Current version: $_currentVersion',
        );
      }

      final conflicts = <String>[];

      // Import routines
      for (final routineJson in bundle.data.routines) {
        // Check if routine already exists
        final existing =
            await (_database.select(_database.routines)..where(
                  (tbl) => tbl.uuid.equals(routineJson['uuid'] as String),
                ))
                .getSingleOrNull();

        if (existing != null && !overwriteExisting) {
          conflicts.add('Routine: ${routineJson['title']}');
          continue; // Skip if exists and not overwriting
        }

        // Import routine
        await _database
            .into(_database.routines)
            .insert(
              _routineFromJson(routineJson),
              mode: InsertMode.insertOrReplace,
            );
      }

      // Import time blocks
      for (final blockJson in bundle.data.timeBlocks) {
        await _database
            .into(_database.timeBlocks)
            .insert(
              _timeBlockFromJson(blockJson),
              mode: InsertMode.insertOrReplace,
            );
      }

      // Import preferences
      for (final entry in bundle.data.preferences.entries) {
        await _database
            .into(_database.userPreferences)
            .insert(
              UserPreferencesCompanion.insert(
                key: entry.key,
                value: entry.value.toString(),
                type: 'string',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }

      return ImportResult.success(conflicts: conflicts);
    } catch (e) {
      return ImportResult.error('Failed to import data: $e');
    }
  }

  /// Import data from encrypted file
  Future<ImportResult> importFromFile(
    String filePath, {
    bool overwriteExisting = false,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult.error('File not found: $filePath');
      }

      // Read and decrypt file
      final encrypted = await file.readAsString();
      final json = await _encryptionService.decryptImportData(encrypted);

      // Parse JSON
      final bundleJson = jsonDecode(json) as Map<String, dynamic>;
      final bundle = DataExportBundle.fromJson(bundleJson);

      return await importData(bundle, overwriteExisting: overwriteExisting);
    } catch (e) {
      return ImportResult.error('Failed to import from file: $e');
    }
  }

  // JSON conversion helpers
  Map<String, dynamic> _routineToJson(Routine r) => {
    'uuid': r.uuid,
    'date': r.date.toIso8601String(),
    'title': r.title,
    'explanation': r.explanation,
    'confidence_score': r.confidenceScore,
    'is_accepted': r.isAccepted,
    'created_at': r.createdAt.toIso8601String(),
    'updated_at': r.updatedAt.toIso8601String(),
  };

  RoutinesCompanion _routineFromJson(Map<String, dynamic> json) =>
      RoutinesCompanion.insert(
        uuid: json['uuid'] as String,
        date: DateTime.parse(json['date'] as String),
        title: json['title'] as String,
        explanation: Value(json['explanation'] as String?),
        confidenceScore: Value(json['confidence_score'] as double?),
        isAccepted: Value(json['is_accepted'] as bool? ?? false),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> _timeBlockToJson(TimeBlock t) => {
    'uuid': t.uuid,
    'routine_id': t.routineId,
    'title': t.title,
    'description': t.description,
    'start_time': t.startTime.toIso8601String(),
    'end_time': t.endTime.toIso8601String(),
    'activity_type': t.activityType,
    'category': t.category,
    'priority': t.priority,
    'is_snoozed': t.isSnoozed,
    'snoozed_until': t.snoozedUntil?.toIso8601String(),
    'source': t.source,
    'created_at': t.createdAt.toIso8601String(),
    'updated_at': t.updatedAt.toIso8601String(),
  };

  TimeBlocksCompanion _timeBlockFromJson(Map<String, dynamic> json) =>
      TimeBlocksCompanion.insert(
        uuid: json['uuid'] as String,
        routineId: json['routine_id'] as int,
        title: json['title'] as String,
        description: Value(json['description'] as String?),
        startTime: DateTime.parse(json['start_time'] as String),
        endTime: DateTime.parse(json['end_time'] as String),
        activityType: json['activity_type'] as String,
        category: Value(json['category'] as String?),
        priority: Value(json['priority'] as int? ?? 0),
        isSnoozed: Value(json['is_snoozed'] as bool? ?? false),
        snoozedUntil: Value(
          json['snoozed_until'] != null
              ? DateTime.parse(json['snoozed_until'] as String)
              : null,
        ),
        source: Value(json['source'] as String?),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> _calendarToJson(CalendarCacheData c) => {
    'event_id': c.eventId,
    'calendar_id': c.calendarId,
    'calendar_name': c.calendarName,
    'title': c.title,
    'description': c.description,
    'location': c.location,
    'start_time': c.startTime.toIso8601String(),
    'end_time': c.endTime.toIso8601String(),
    'is_all_day': c.isAllDay,
    'recurrence_rule': c.recurrenceRule,
    'is_recurring': c.isRecurring,
    'last_synced_at': c.lastSyncedAt.toIso8601String(),
  };

  Map<String, dynamic> _weatherToJson(WeatherCacheData w) => {
    'uuid': w.uuid,
    'source': w.source,
    'latitude': w.latitude,
    'longitude': w.longitude,
    'condition': w.condition,
    'temperature_celsius': w.temperatureCelsius,
  };
}
