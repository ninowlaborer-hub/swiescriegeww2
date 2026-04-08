// features/settings/presentation/crash_log_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../core/error/crash_reporter.dart';
import '../../../core/error/crash_reporter.dart' show CrashReporter, CrashReport, CrashType;

/// Developer screen to view crash logs
/// Useful for debugging and support
class CrashLogScreen extends ConsumerWidget {
  const CrashLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final crashReporter = ref.watch(crashReporterProvider);
    final crashLog = crashReporter.getLocalCrashLog();
    final stats = crashReporter.getCrashStatistics();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Log'),
        actions: [
          if (crashLog.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear Log',
              onPressed: () => _confirmClearLog(context, crashReporter),
            ),
        ],
      ),
      body: crashLog.isEmpty
          ? _buildEmptyState(theme)
          : Column(
              children: [
                // Statistics card
                if (stats.isNotEmpty) _buildStatisticsCard(theme, stats),

                // Crash list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: crashLog.length,
                    itemBuilder: (context, index) {
                      final crash = crashLog[crashLog.length - 1 - index]; // Reverse order
                      return _buildCrashCard(theme, crash);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          Text(
            'No Crashes Recorded',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'The app is running smoothly',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(ThemeData theme, Map<String, int> stats) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Error Statistics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...stats.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Chip(
                        label: Text('${entry.value}'),
                        backgroundColor: theme.colorScheme.errorContainer,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCrashCard(ThemeData theme, CrashReport crash) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          _getCrashIcon(crash.type),
          color: crash.isFatal ? Colors.red : Colors.orange,
        ),
        title: Text(
          _extractErrorType(crash.error),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          crash.formattedTimestamp,
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error type badge
                Row(
                  children: [
                    Chip(
                      label: Text(crash.type.name.toUpperCase()),
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    if (crash.isFatal)
                      const Chip(
                        label: Text('FATAL'),
                        backgroundColor: Colors.red,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Context (if available)
                if (crash.context != null) ...[
                  Text(
                    'Context:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    crash.context!,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                ],

                // Error message
                const Text(
                  'Error:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  crash.error,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),

                // Stack trace (if available)
                if (crash.stackTrace != null) ...[
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
                    child: SelectableText(
                      crash.stackTrace!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCrashIcon(CrashType crashType) {
    switch (crashType) {
      case CrashType.flutter:
        return Icons.widgets;
      case CrashType.platform:
        return Icons.smartphone;
      case CrashType.caught:
        return Icons.bug_report;
      default:
        return Icons.error;
    }
  }

  String _extractErrorType(String errorMessage) {
    final match = RegExp(r'^([A-Za-z][A-Za-z0-9_]+)').firstMatch(errorMessage);
    return match?.group(1) ?? errorMessage.split('\n').first;
  }

  Future<void> _confirmClearLog(BuildContext context, CrashReporter crashReporter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Crash Log'),
        content: const Text('Are you sure you want to clear all crash logs? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      crashReporter.clearLocalCrashLog();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crash log cleared')),
        );
      }
    }
  }
}
