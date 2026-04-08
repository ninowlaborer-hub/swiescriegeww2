import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_source.freezed.dart';
part 'calendar_source.g.dart';

/// Calendar source model
///
/// Represents a calendar from the device's native calendar app.
/// Examples: "Work", "Personal", "Family", "Holidays"
@freezed
abstract class CalendarSource with _$CalendarSource {
  const factory CalendarSource({
    required String id,
    required String name,
    required int color,
    required bool isSelected,
    required bool isPrimary,
    required bool isReadOnly,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? accountName,
    String? accountType,
    CalendarSourceType? sourceType,
    Map<String, dynamic>? metadata,
  }) = _CalendarSource;

  const CalendarSource._();

  factory CalendarSource.fromJson(Map<String, dynamic> json) =>
      _$CalendarSourceFromJson(json);

  /// Create a calendar source from platform-specific data
  factory CalendarSource.fromPlatform({
    required String id,
    required String name,
    int color = 0xFF2196F3, // Default blue
    bool isSelected = false,
    bool isPrimary = false,
    bool isReadOnly = false,
    String? accountName,
    String? accountType,
    String? sourceType,
    Map<String, dynamic>? metadata,
  }) =>
      CalendarSource(
        id: id,
        name: name,
        accountName: accountName,
        accountType: accountType,
        color: color,
        isSelected: isSelected,
        isPrimary: isPrimary,
        isReadOnly: isReadOnly,
        sourceType: _parseSourceType(sourceType),
        metadata: metadata,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static CalendarSourceType? _parseSourceType(String? type) {
    if (type == null) return null;
    switch (type.toLowerCase()) {
      case 'local':
        return CalendarSourceType.local;
      case 'google':
        return CalendarSourceType.google;
      case 'icloud':
        return CalendarSourceType.icloud;
      case 'exchange':
        return CalendarSourceType.exchange;
      case 'outlook':
        return CalendarSourceType.outlook;
      default:
        return CalendarSourceType.other;
    }
  }
}

/// Calendar source type
enum CalendarSourceType {
  local,
  google,
  icloud,
  exchange,
  outlook,
  other,
}

/// Extension methods for CalendarSource
extension CalendarSourceX on CalendarSource {
  /// Get display name with account info
  String get displayName {
    if (accountName != null && accountName!.isNotEmpty) {
      return '$name ($accountName)';
    }
    return name;
  }

  /// Get color as hex string
  String get colorHex =>
      '#${color.toRadixString(16).padLeft(8, '0').substring(2)}';

  /// Check if this is a Google calendar
  bool get isGoogle =>
      sourceType == CalendarSourceType.google ||
      (accountType?.toLowerCase().contains('google') ?? false);

  /// Check if this is an iCloud calendar
  bool get isICloud =>
      sourceType == CalendarSourceType.icloud ||
      (accountType?.toLowerCase().contains('icloud') ?? false);

  /// Check if this is a local device calendar
  bool get isLocal => sourceType == CalendarSourceType.local;

  /// Check if calendar can be written to
  bool get isWritable => !isReadOnly;

  /// Get source type display name
  String get sourceTypeDisplay {
    switch (sourceType) {
      case CalendarSourceType.local:
        return 'Local';
      case CalendarSourceType.google:
        return 'Google';
      case CalendarSourceType.icloud:
        return 'iCloud';
      case CalendarSourceType.exchange:
        return 'Exchange';
      case CalendarSourceType.outlook:
        return 'Outlook';
      case CalendarSourceType.other:
        return 'Other';
      case null:
        return 'Unknown';
    }
  }

  /// Get icon for source type
  String get sourceIcon {
    switch (sourceType) {
      case CalendarSourceType.local:
        return '📱';
      case CalendarSourceType.google:
        return '📧';
      case CalendarSourceType.icloud:
        return '☁️';
      case CalendarSourceType.exchange:
        return '💼';
      case CalendarSourceType.outlook:
        return '📬';
      case CalendarSourceType.other:
      case null:
        return '📅';
    }
  }
}
