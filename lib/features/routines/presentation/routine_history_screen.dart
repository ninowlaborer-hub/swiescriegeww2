import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/routine.dart';
import 'routine_providers.dart';

/// Routine history screen - displays past routines
///
/// Shows paginated list of historical routines with filtering and search.
/// Allows viewing, deleting, and cleaning up old routines.
class RoutineHistoryScreen extends ConsumerStatefulWidget {
  const RoutineHistoryScreen({super.key});

  @override
  ConsumerState<RoutineHistoryScreen> createState() =>
      _RoutineHistoryScreenState();
}

class _RoutineHistoryScreenState extends ConsumerState<RoutineHistoryScreen> {
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when scrolled 80% down
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.history),
        ),
        title: const Text('Routine History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showCleanupDialog(context),
            tooltip: 'Cleanup old routines',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showStatistics(context),
            tooltip: 'Statistics',
          ),
        ],
      ),
      body: _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    // Build list with pagination
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _currentPage + 1,
      itemBuilder: (context, page) {
        final historyAsync = ref.watch(routineHistoryProvider(page));

        return historyAsync.when(
          data: (routines) {
            if (routines.isEmpty && page == 0) {
              return _buildEmptyState(context);
            }

            if (routines.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: routines.map((routine) {
                return _buildRoutineCard(context, routine);
              }).toList(),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading history: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(routineHistoryProvider(page));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No History Yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your past routines will appear here',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(BuildContext context, Routine routine) {
    final isToday = routine.isToday;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewRoutineDetails(context, routine),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(routine.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'TODAY',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (routine.isAccepted)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Stats row
              Row(
                children: [
                  _buildStat(
                    context,
                    Icons.schedule,
                    '${routine.timeBlocks.length} blocks',
                  ),
                  const SizedBox(width: 16),
                  if (routine.confidenceScore != null)
                    _buildStat(
                      context,
                      Icons.bar_chart,
                      '${(routine.confidenceScore! * 100).toInt()}%',
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _deleteRoutine(context, routine),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    }

    final weekday = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ][date.weekday - 1];
    final month = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][date.month - 1];
    return '$weekday, $month ${date.day}, ${date.year}';
  }

  void _viewRoutineDetails(BuildContext context, Routine routine) {
    // Show bottom sheet with routine details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title
                Text(
                  routine.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(routine.date),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),

                // Time blocks
                Text(
                  'Time Blocks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: routine.timeBlocks.length,
                    itemBuilder: (context, index) {
                      final block = routine.timeBlocks[index];
                      return ListTile(
                        leading: _getActivityIcon(block.activityType),
                        title: Text(block.title),
                        subtitle: Text(_formatTimeRange(block)),
                        trailing: Text(
                          _formatDuration(block),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimeRange(dynamic block) {
    // Assuming block has startTime and endTime
    final start = block.startTime as DateTime;
    final end = block.endTime as DateTime;
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final displayHour = hour == 0 ? 12 : hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minute $period';
  }

  String _formatDuration(dynamic block) {
    final start = block.startTime as DateTime;
    final end = block.endTime as DateTime;
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  Icon _getActivityIcon(String activityType) {
    switch (activityType) {
      case 'work':
        return const Icon(Icons.work);
      case 'meeting':
        return const Icon(Icons.people);
      case 'exercise':
        return const Icon(Icons.fitness_center);
      case 'meal':
        return const Icon(Icons.restaurant);
      case 'sleep':
        return const Icon(Icons.bed);
      case 'commute':
        return const Icon(Icons.directions_car);
      case 'focus':
        return const Icon(Icons.center_focus_strong);
      default:
        return const Icon(Icons.event);
    }
  }

  Future<void> _deleteRoutine(BuildContext context, Routine routine) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine?'),
        content: Text(
          'Are you sure you want to delete the routine for ${_formatDate(routine.date)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await deleteRoutineAction(ref, routine.id);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Routine deleted')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    }
  }

  Future<void> _showCleanupDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cleanup Old Routines?'),
        content: const Text(
          'This will delete routines older than 90 days to free up space. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cleanup'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final count = await cleanupOldRoutinesAction(ref);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted $count old routines')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Cleanup failed: $e')));
        }
      }
    }
  }

  Future<void> _showStatistics(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, child) {
          final statsAsync = ref.watch(routineStatisticsProvider);

          return statsAsync.when(
            data: (stats) {
              final totalRoutines = stats['total_routines'] as int? ?? 0;
              final acceptedRoutines = stats['accepted_routines'] as int? ?? 0;
              final acceptanceRate = totalRoutines > 0
                  ? ((acceptedRoutines / totalRoutines) * 100).toInt()
                  : 0;
              final avgBlocks = stats['average_blocks'] as num? ?? 0;

              return AlertDialog(
                title: const Text('Routine Statistics'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(context, 'Total Routines', '$totalRoutines'),
                    _buildStatRow(
                      context,
                      'Accepted',
                      '$acceptedRoutines ($acceptanceRate%)',
                    ),
                    _buildStatRow(
                      context,
                      'Average Blocks',
                      avgBlocks.toStringAsFixed(1),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
            loading: () {
              return const AlertDialog(
                content: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            },
            error: (error, stack) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to load statistics: $error'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
