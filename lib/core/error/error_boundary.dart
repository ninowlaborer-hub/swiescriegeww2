// core/error/error_boundary.dart
import 'package:flutter/material.dart';
import 'crash_reporter.dart';
import 'error_display_widget.dart';

/// Error boundary widget that catches errors in its subtree
/// Similar to React error boundaries - prevents app-wide crashes
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   child: MyFeatureWidget(),
///   onError: (error, stack) => crashReporter.reportError(error, stack),
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
    this.fallback,
    this.showErrorDetails = false,
  });

  final Widget child;
  final void Function(Object error, StackTrace? stackTrace)? onError;
  final Widget Function(Object error, StackTrace? stackTrace)? fallback;
  final bool showErrorDetails;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      // Error occurred - show fallback UI
      if (widget.fallback != null) {
        return widget.fallback!(_error!, _stackTrace);
      }
      return ErrorDisplayWidget(
        error: _error!,
        stackTrace: _stackTrace,
        onRetry: _resetError,
        showDetails: widget.showErrorDetails,
      );
    }

    // No error - show child wrapped in error catcher
    return ErrorCatcher(
      onError: _handleError,
      child: widget.child,
    );
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });

    // Report to crash reporter
    widget.onError?.call(error, stackTrace);
  }

  void _resetError() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }
}

/// Widget that catches errors from its build method
class ErrorCatcher extends StatelessWidget {
  const ErrorCatcher({
    super.key,
    required this.child,
    required this.onError,
  });

  final Widget child;
  final void Function(Object error, StackTrace? stackTrace) onError;

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // Notify parent error boundary
      onError(details.exception, details.stack);

      // Return a simple error widget
      return ErrorDisplayWidget(
        error: details.exception,
        stackTrace: details.stack,
        onRetry: null, // Parent boundary handles retry
      );
    };

    return child;
  }
}

/// Root error boundary for the entire app
/// Wraps MaterialApp to catch any uncaught errors
class RootErrorBoundary extends StatelessWidget {
  const RootErrorBoundary({
    super.key,
    required this.child,
    required this.crashReporter,
  });

  final Widget child;
  final CrashReporter crashReporter;

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      onError: (error, stack) {
        crashReporter.reportError(
          error,
          stack,
          context: 'RootErrorBoundary',
          isFatal: true,
        );
      },
      fallback: (error, stack) => MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: ErrorDisplayWidget(
              error: error,
              stackTrace: stack,
              onRetry: null, // Root level - can't retry
              showDetails: true,
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
