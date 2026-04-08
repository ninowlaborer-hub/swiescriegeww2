/// Base error handling framework for Swisscierge
///
/// Provides structured error types with user-friendly messages
/// and logging support for debugging.
library;

/// Base app error class
abstract class AppError implements Exception {
  const AppError(this.message, [this.details]);

  final String message;
  final dynamic details;

  @override
  String toString() =>
      'AppError: $message${details != null ? ' ($details)' : ''}';

  /// User-friendly error message
  String get userMessage => message;

  /// Technical details for logging
  String get technicalDetails => details?.toString() ?? '';

  /// Factory method for database errors
  static DatabaseError database({
    required String message,
    dynamic originalError,
  }) => DatabaseError(message, originalError);

  /// Factory method for validation errors
  static ValidationError validation({
    required String message,
    dynamic originalError,
  }) => ValidationError(message, originalError);

  /// Factory method for platform errors
  static PlatformError platform({
    required String message,
    dynamic originalError,
  }) => PlatformError(message, originalError);

  /// Factory method for permission errors
  static PermissionError permission({
    required String message,
    dynamic originalError,
  }) => PermissionError(message, originalError);

  /// Factory method for ML model errors
  static MLModelError mlModel({
    required String message,
    dynamic originalError,
  }) => MLModelError(message, originalError);

  /// Factory method for sync errors
  static SyncError sync({required String message, dynamic originalError}) =>
      SyncError(message, originalError);
}

/// Database operation errors
class DatabaseError extends AppError {
  const DatabaseError(super.message, [super.details]);

  @override
  String get userMessage => 'Failed to save data. Please try again.';
}

/// Network/API errors
class NetworkError extends AppError {
  const NetworkError(super.message, [super.details]);

  @override
  String get userMessage =>
      'Network error. Please check your connection and try again.';
}

/// Platform bridge errors (iOS/Android native code)
class PlatformError extends AppError {
  const PlatformError(super.message, [super.details]);

  @override
  String get userMessage =>
      'Platform error. Please restart the app and try again.';
}

/// Permission denied errors
class PermissionError extends AppError {
  const PermissionError(super.message, [super.details]);

  @override
  String get userMessage =>
      'Permission required. Please grant permission in Settings.';
}

/// ML model errors
class MLModelError extends AppError {
  const MLModelError(super.message, [super.details]);

  @override
  String get userMessage =>
      'AI model error. Please try generating your routine again.';
}

/// Validation errors
class ValidationError extends AppError {
  const ValidationError(super.message, [super.details]);

  @override
  String get userMessage => 'Invalid data. $message';
}

/// Sync errors
class SyncError extends AppError {
  const SyncError(super.message, [super.details]);

  @override
  String get userMessage => 'Sync failed. Please try again later.';
}

/// Data import/export errors
class DataError extends AppError {
  const DataError(super.message, [super.details]);

  @override
  String get userMessage => 'Data error. Please check your file and try again.';
}

/// Storage limit errors
class StorageLimitError extends AppError {
  const StorageLimitError(super.message, [super.details]);

  @override
  String get userMessage =>
      'Storage limit reached. Please clear old data in Settings.';
}

/// Unknown/unexpected errors
class UnknownError extends AppError {
  const UnknownError(super.message, [super.details]);

  @override
  String get userMessage =>
      'An unexpected error occurred. Please try again or contact support.';
}
