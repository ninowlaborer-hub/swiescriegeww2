import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/offline_indicator.dart';
import '../../../core/ai/claude_ai_provider.dart';
import 'routine_providers.dart';
import '../domain/routine.dart';
import '../domain/time_block.dart';
import 'widgets/ai_generation_loading.dart';
import 'widgets/routine_success_animation.dart';

/// Week view screen - displays and manages weekly routines
///
/// Shows 7 days of routines with ability to generate all at once
class RoutineWeekViewScreen extends ConsumerStatefulWidget {
  const RoutineWeekViewScreen({super.key});

  @override
  ConsumerState<RoutineWeekViewScreen> createState() =>
      _RoutineWeekViewScreenState();
}

class _RoutineWeekViewScreenState extends ConsumerState<RoutineWeekViewScreen> {
  DateTime _weekStart = _getWeekStart(DateTime.now());
  bool _isGenerating = false;
  final Map<DateTime, bool> _generatingDays = {};

  static DateTime _getWeekStart(DateTime date) {
    // Get Monday of current week
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> get _weekDays {
    return List.generate(7, (index) => _weekStart.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.calendar_view_week),
        ),
        title: const Text('Week Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isGenerating ? null : _generateWeekRoutines,
            tooltip: 'Generate Week',
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineIndicator(),

          // Week selector
          _buildWeekSelector(),

          // Week days list
          Expanded(
            child: _isGenerating
                ? const Center(child: AIGenerationLoading())
                : _buildWeekList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    final weekEndDate = _weekStart.add(const Duration(days: 6));
    final dateFormat = DateFormat('MMM d');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red.shade50, Colors.white]),
        border: Border(bottom: BorderSide(color: Colors.red.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _isGenerating ? null : _previousWeek,
            tooltip: 'Previous Week',
          ),
          Column(
            children: [
              Text(
                '${dateFormat.format(_weekStart)} - ${dateFormat.format(weekEndDate)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Week ${_getWeekNumber(_weekStart)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.red.shade700),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _isGenerating ? null : _nextWeek,
            tooltip: 'Next Week',
          ),
        ],
      ),
    );
  }

  Widget _buildWeekList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _weekDays.length,
      itemBuilder: (context, index) {
        final date = _weekDays[index];
        return _buildDayCard(date);
      },
    );
  }

  Widget _buildDayCard(DateTime date) {
    final routineAsync = ref.watch(routineForDateProvider(date));
    final isToday = _isToday(date);
    final isPast = date.isBefore(DateTime.now()) && !isToday;
    final isGeneratingDay = _generatingDays[_normalizeDate(date)] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isToday ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isToday
            ? BorderSide(color: Colors.red.shade600, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isToday
              ? LinearGradient(colors: [Colors.red.shade50, Colors.white])
              : null,
        ),
        child: Column(
          children: [
            // Day header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isToday
                      ? [Colors.red.shade600, Colors.red.shade400]
                      : isPast
                      ? [Colors.grey.shade400, Colors.grey.shade300]
                      : [Colors.red.shade400, Colors.red.shade300],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE').format(date),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('MMMM d, yyyy').format(date),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Routine content
            Padding(
              padding: const EdgeInsets.all(16),
              child: isGeneratingDay
                  ? _buildGeneratingState()
                  : routineAsync.when(
                      data: (routine) => routine != null
                          ? _buildRoutineContent(routine, date)
                          : _buildEmptyState(date),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => _buildErrorState(date),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineContent(Routine routine, DateTime date) {
    final isClaudeGenerated =
        routine.explanation?.dataSourcesUsed?['claude_ai'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                routine.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (routine.isAccepted)
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
          ],
        ),
        const SizedBox(height: 8),

        // AI Generation Badge
        if (isClaudeGenerated)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 12, color: Colors.blue.shade700),
                const SizedBox(width: 4),
                Text(
                  'Claude AI Enhanced',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // Time blocks summary
        Row(
          children: [
            Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              '${routine.timeBlocks.length} blocks',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Icon(Icons.timer_outlined, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              _calculateTotalDuration(routine.timeBlocks),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            if (routine.confidenceScore != null) ...[
              const SizedBox(width: 12),
              Icon(Icons.bar_chart, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(routine.confidenceScore! * 100).toInt()}%',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ],
        ),

        const SizedBox(height: 12),

        // Action buttons
        Wrap(
          spacing: 8,
          children: [
            _buildActionButton(
              icon: Icons.visibility,
              label: 'View',
              onPressed: () => _viewRoutine(date),
            ),
            _buildActionButton(
              icon: Icons.edit,
              label: 'Edit',
              onPressed: () => _editRoutine(routine.id),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(DateTime date) {
    final isPast = date.isBefore(DateTime.now()) && !_isToday(date);

    return Column(
      children: [
        Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text(
          isPast ? 'No routine was generated' : 'No routine planned',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        if (!isPast) ...[
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.add_circle_outline,
            label: 'Generate Routine',
            onPressed: () => _generateDayRoutine(date),
          ),
        ],
      ],
    );
  }

  Widget _buildGeneratingState() {
    return Column(
      children: [
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        const SizedBox(height: 16),
        Text(
          'Generating routine...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI is analyzing your schedule',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildErrorState(DateTime date) {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        const SizedBox(height: 12),
        Text(
          'Failed to load routine',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.refresh,
          label: 'Retry',
          onPressed: () => ref.invalidate(routineForDateProvider(date)),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red.shade700,
        side: BorderSide(color: Colors.red.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _calculateTotalDuration(List<TimeBlock> blocks) {
    final totalMinutes = blocks.fold<int>(
      0,
      (sum, block) => sum + block.durationMinutes,
    );
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  int _getWeekNumber(DateTime date) {
    final dayOfYear = int.parse(DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _previousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
  }

  Future<void> _generateWeekRoutines() async {
    setState(() => _isGenerating = true);

    try {
      final results = <DateTime, bool>{};

      for (final date in _weekDays) {
        try {
          await generateRoutineAction(ref, date: date);
          results[date] = true;

          // Refresh the specific date provider
          ref.invalidate(routineForDateProvider(date));
        } catch (e) {
          results[date] = false;
          // Continue with other days even if one fails
        }
      }

      if (mounted) {
        final successCount = results.values.where((v) => v).length;
        final failCount = results.length - successCount;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              failCount == 0
                  ? 'All $successCount routines generated successfully!'
                  : '$successCount routines generated, $failCount failed',
            ),
            backgroundColor: failCount == 0 ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to generate week: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _generateDayRoutine(DateTime date) async {
    final normalizedDate = _normalizeDate(date);

    setState(() {
      _generatingDays[normalizedDate] = true;
    });

    try {
      final routine = await generateRoutineAction(ref, date: date);

      // Refresh the specific date provider
      ref.invalidate(routineForDateProvider(date));

      if (mounted) {
        // Check if Claude AI was used
        final isClaudeGenerated =
            routine.explanation?.dataSourcesUsed?['claude_ai'] == true;
        final claudeAiEnabled = ref.read(isClaudeAiEnabledProvider);

        // Show success animation
        await showRoutineSuccessAnimation(
          context,
          message: isClaudeGenerated
              ? 'Routine generated with Claude AI!'
              : claudeAiEnabled
              ? 'Routine generated!'
              : 'Routine generated with ML!',
          isClaudeGenerated: isClaudeGenerated,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _generatingDays.remove(normalizedDate);
        });
      }
    }
  }

  void _viewRoutine(DateTime date) {
    if (_isToday(date)) {
      context.go('/routine');
    } else {
      // Navigate to specific date view with milliseconds
      final timestamp = date.millisecondsSinceEpoch;
      context.push('/routine/date/$timestamp');
    }
  }

  void _editRoutine(String routineId) {
    context.push('/routine/edit/$routineId');
  }
}
