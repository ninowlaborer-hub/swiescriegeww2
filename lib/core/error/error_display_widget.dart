// core/error/error_display_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// User-friendly error display widget
/// Shows helpful error messages without exposing technical details in production
class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.showDetails = false,
  });

  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorInfo = _getErrorInfo(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Icon(
              errorInfo.icon,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),

            // User-friendly title
            Text(
              errorInfo.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // User-friendly message
            Text(
              errorInfo.message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action buttons
            if (onRetry != null) ...[
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
              const SizedBox(height: 12),
            ],

            // Technical details (debug mode or when requested)
            if (showDetails || kDebugMode) ...[
              const SizedBox(height: 24),
              ExpansionTile(
                title: const Text('Technical Details'),
                leading: const Icon(Icons.bug_report),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error Type: ${error.runtimeType}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                        if (stackTrace != null) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Stack Trace:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              stackTrace.toString(),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                              ),
                              maxLines: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get user-friendly error information based on error type
  ErrorInfo _getErrorInfo(Object error) {
    // Network errors
    if (error.toString().contains('SocketException') ||
        error.toString().contains('HttpException') ||
        error.toString().contains('NetworkException')) {
      return ErrorInfo(
        icon: Icons.wifi_off,
        title: 'Connection Issue',
        message: 'Unable to connect to the internet. Please check your connection and try again.',
      );
    }

    // Timeout errors
    if (error.toString().contains('TimeoutException')) {
      return ErrorInfo(
        icon: Icons.hourglass_empty,
        title: 'Request Timeout',
        message: 'The operation took too long. Please try again.',
      );
    }

    // Permission errors
    if (error.toString().contains('PermissionDeniedException') ||
        error.toString().contains('Permission')) {
      return ErrorInfo(
        icon: Icons.block,
        title: 'Permission Required',
        message: 'This feature requires permission to access certain data. Please enable permissions in Settings.',
      );
    }

    // Storage errors
    if (error.toString().contains('FileSystemException') ||
        error.toString().contains('storage')) {
      return ErrorInfo(
        icon: Icons.storage,
        title: 'Storage Issue',
        message: 'Unable to access device storage. Please check available space and permissions.',
      );
    }

    // Format/parse errors
    if (error.toString().contains('FormatException') ||
        error.toString().contains('ParseException')) {
      return ErrorInfo(
        icon: Icons.error_outline,
        title: 'Data Format Error',
        message: 'The data format is invalid. Please try again or contact support.',
      );
    }

    // State errors
    if (error.toString().contains('StateError')) {
      return ErrorInfo(
        icon: Icons.warning,
        title: 'Invalid Operation',
        message: 'This operation cannot be performed in the current state. Please try again.',
      );
    }

    // Generic error
    return ErrorInfo(
      icon: Icons.error,
      title: 'Something Went Wrong',
      message: 'An unexpected error occurred. If this continues, please contact support.',
    );
  }
}

/// Error information for display
class ErrorInfo {
  final IconData icon;
  final String title;
  final String message;

  ErrorInfo({
    required this.icon,
    required this.title,
    required this.message,
  });
}
