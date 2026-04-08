import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_bundle.freezed.dart';
part 'export_bundle.g.dart';

/// Data export bundle
///
/// Contains all user data for backup/restore per FR-024, FR-026.
/// Encrypted before export per FR-029.
@freezed
abstract class DataExportBundle with _$DataExportBundle {
  const factory DataExportBundle({
    required String version, // Schema version for compatibility
    required DateTime exportedAt,
    required String deviceId, // Anonymous device identifier
    required ExportData data,
    String? encryptionKeyHash, // Hash of encryption key for verification
  }) = _DataExportBundle;

  factory DataExportBundle.fromJson(Map<String, dynamic> json) =>
      _$DataExportBundleFromJson(json);
}

/// Export data container
@freezed
abstract class ExportData with _$ExportData {
  const factory ExportData({
    required List<Map<String, dynamic>> routines,
    required List<Map<String, dynamic>> timeBlocks,
    required List<Map<String, dynamic>> calendarCache,
    required List<Map<String, dynamic>> weatherCache,
    required Map<String, dynamic> preferences,
  }) = _ExportData;

  factory ExportData.fromJson(Map<String, dynamic> json) =>
      _$ExportDataFromJson(json);
}

/// Export result
class ExportResult {
  const ExportResult._({this.bundle, this.filePath, this.error});

  final DataExportBundle? bundle;
  final String? filePath;
  final String? error;

  bool get isSuccess => bundle != null && error == null;
  bool get isError => error != null;

  factory ExportResult.success(DataExportBundle bundle, {String? filePath}) {
    return ExportResult._(bundle: bundle, filePath: filePath);
  }

  factory ExportResult.error(String error) {
    return ExportResult._(error: error);
  }
}

/// Import result
class ImportResult {
  const ImportResult._({this.imported = false, this.conflicts, this.error});

  final bool imported;
  final List<String>? conflicts; // List of conflicting items
  final String? error;

  bool get isSuccess => imported && error == null;
  bool get hasConflicts => conflicts != null && conflicts!.isNotEmpty;
  bool get isError => error != null;

  factory ImportResult.success({List<String>? conflicts}) {
    return ImportResult._(imported: true, conflicts: conflicts);
  }

  factory ImportResult.error(String error) {
    return ImportResult._(error: error);
  }
}
