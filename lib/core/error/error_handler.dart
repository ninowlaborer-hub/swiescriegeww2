import 'package:flutter/foundation.dart';
import 'app_error.dart';
import '../logging/logger.dart';

/// Global error handler for Swisscierge
///
/// Centralizes error handling, logging, and user-friendly error reporting.
class ErrorHandler {
  const ErrorHandler._();

  /// Handle an error and return user-friendly message
  static String handle(Object error, [StackTrace? stackTrace]) {
    // Log the error
    AppLogger.error('Error occurred', error: error, stackTrace: stackTrace);

    // Return user-friendly message
    if (error is AppError) {
      return error.userMessage;
    }

    // Handle common Flutter/Dart errors
    if (error is FormatException) {
      return 'Invalid data format. Please check your input.';
    }

    if (error is ArgumentError) {
      return 'Invalid input. Please check and try again.';
    }

    if (error is StateError) {
      return 'App state error. Please restart the app.';
    }

    // Unknown error
    return 'An unexpected error occurred. Please try again.';
  }

  /// Handle error silently (log only, no user message)
  static void handleSilently(Object error, [StackTrace? stackTrace]) {
    AppLogger.error('Silent error', error: error, stackTrace: stackTrace);
  }

  /// Report error for debugging (only in debug mode)
  static void reportForDebug(Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      AppLogger.debug('Debug error: $error', error: error);
      if (stackTrace != null) {
        AppLogger.debug('Stack trace:\n$stackTrace');
      }
    }
  }
}
