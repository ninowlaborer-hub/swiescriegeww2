import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swisscierge/features/routines/domain/routine_explanation.dart';
import '../../../shared/widgets/offline_indicator.dart';
import '../../../core/ai/claude_ai_provider.dart';
import 'routine_providers.dart';
import '../domain/routine.dart';
import '../domain/time_block.dart';
import 'widgets/snooze_dialog.dart';
import 'widgets/regenerate_dialog.dart';
import 'widgets/ai_generation_loading.dart';
import 'widgets/routine_success_animation.dart';
import 'widgets/ai_consent_dialog.dart';

/// Routine view screen - displays today's routine
///
/// Shows generated routine with time blocks, offline indicator,
/// and options to regenerate, edit, or accept the routine.
class RoutineViewScreen extends ConsumerWidget {
  const RoutineViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineAsync = ref.watch(todaysRoutineProvider);
    final isGenerating = ref.watch(routineGenerationLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.calendar_today),
        ),
        title: const Text('Today\'s Routine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_view_week),
            onPressed: () => context.push('/routine/week'),
            tooltip: 'Week Planner',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isGenerating
                ? null
                : () => _regenerateRoutine(context, ref),
            tooltip: 'Regenerate',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/routine/history'),
            tooltip: 'History',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const OfflineIndicator(),
              Expanded(
                child: routineAsync.when(
                  data: (routine) =>
                      _buildRoutineContent(context, ref, routine),
                  loading: () => isGenerating
                      ? const Center(child: AIGenerationLoading())
                      : const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      _buildErrorState(context, ref, error),
                ),
              ),
            ],
          ),

          // Show overlay loading animation during regeneration
          if (isGenerating && routineAsync.hasValue)
            const AIGenerationOverlay(isRegenerating: true),
        ],
      ),
      floatingActionButton: routineAsync.maybeWhen(
        data: (routine) => !routine.isAccepted && !isGenerating
            ? FloatingActionButton.extended(
                onPressed: () => _acceptRoutine(context, ref, routine.id),
                icon: const Icon(Icons.check),
                label: const Text('Accept Routine'),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  Widget _buildRoutineContent(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Routine header
        _buildRoutineHeader(context, routine),
        const SizedBox(height: 16),

        // Explanation
        if (routine.explanation != null)
          _buildExplanationCard(context, routine),

        const SizedBox(height: 16),

        // Time blocks
        _buildTimeBlocksList(context, ref, routine),
      ],
    );
  }

  Widget _buildRoutineHeader(BuildContext context, Routine routine) {
    final isClaudeGenerated =
        routine.explanation?.dataSourcesUsed?['claude_ai'] == true;
    final hasHighConfidence = (routine.confidenceScore ?? 0) >= 0.9;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    routine.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (routine.isAccepted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Accepted',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // AI Generation Badge
            _buildAIGenerationBadge(
              context,
              isClaudeGenerated,
              hasHighConfidence,
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatDate(routine.date),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${routine.timeBlocks.length} blocks',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (routine.confidenceScore != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.bar_chart, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${(routine.confidenceScore! * 100).toInt()}% confidence',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),

            // Data sources indicator
            if (routine.explanation != null)
              _buildDataSourcesIndicator(context, routine.explanation!),
          ],
        ),
      ),
    );
  }

  Widget _buildAIGenerationBadge(
    BuildContext context,
    bool isClaudeGenerated,
    bool hasHighConfidence,
  ) {
    if (isClaudeGenerated) {
      return Tooltip(
        message:
            'This routine was enhanced by Claude AI for higher quality and personalization. '
            'Claude analyzes your calendar, weather, and preferences to create optimal schedules.',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.purple.shade100],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade300, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 6),
              Text(
                'Enhanced by Claude AI',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.verified, size: 14, color: Colors.blue.shade700),
            ],
          ),
        ),
      );
    } else {
      return Tooltip(
        message:
            'This routine was generated using on-device machine learning. '
            'For enhanced personalization, configure Claude AI in settings.',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade400, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_android, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                'On-Device ML',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDataSourcesIndicator(
    BuildContext context,
    RoutineExplanation explanation,
  ) {
    final dataSources = <Map<String, dynamic>>[];

    if (explanation.usedCalendarData) {
      dataSources.add({
        'icon': Icons.calendar_today,
        'label': 'Calendar',
        'colorLight': Colors.blue.shade50,
        'colorBorder': Colors.blue.shade200,
        'colorText': Colors.blue.shade700,
      });
    }

    if (explanation.usedWeatherData) {
      dataSources.add({
        'icon': Icons.wb_sunny,
        'label': 'Weather',
        'colorLight': Colors.orange.shade50,
        'colorBorder': Colors.orange.shade200,
        'colorText': Colors.orange.shade700,
      });
    }

    if (dataSources.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Sources:',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: dataSources.map((source) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: source['colorLight'] as Color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: source['colorBorder'] as Color,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      source['icon'] as IconData,
                      size: 12,
                      color: source['colorText'] as Color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      source['label'] as String,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: source['colorText'] as Color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(BuildContext context, Routine routine) {
    final isClaudeGenerated =
        routine.explanation?.dataSourcesUsed?['claude_ai'] == true;

    return Card(
      child: ExpansionTile(
        leading: Icon(
          isClaudeGenerated ? Icons.auto_awesome : Icons.lightbulb_outline,
          color: isClaudeGenerated ? Colors.blue.shade700 : null,
        ),
        title: Text(
          isClaudeGenerated ? 'AI-Enhanced Explanation' : 'Why this routine?',
        ),
        subtitle: Text(
          isClaudeGenerated
              ? 'Generated by Claude AI with contextual analysis'
              : 'Generated by on-device ML',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main explanation text
                Text(
                  routine.explanation!.formattedText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                // Show factors if available
                if (routine.explanation!.factors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Key Factors:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...routine.explanation!.factors.map((factor) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              factor,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                // Show data source count
                if (routine.explanation!.dataSourceCount > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.data_usage,
                          size: 18,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This routine used ${routine.explanation!.dataSourceCount} data source${routine.explanation!.dataSourceCount > 1 ? 's' : ''} for personalization',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Show generation time if available
                if (routine.explanation!.generatedAt != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Generated at ${_formatTime(TimeOfDay.fromDateTime(routine.explanation!.generatedAt!))}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
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

  Widget _buildTimeBlocksList(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Time Blocks', style: Theme.of(context).textTheme.titleMedium),
            Text(
              '${routine.timeBlocks.length} total',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Show all time blocks - no filtering
        if (routine.timeBlocks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No time blocks in this routine',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...routine.timeBlocks.asMap().entries.map((entry) {
            final index = entry.key;
            final block = entry.value;
            final isActive = block.isActive;
            final isPast = block.isPast;
            final isLast = index == routine.timeBlocks.length - 1;

            return Card(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
              color: isActive
                  ? Theme.of(context).colorScheme.primaryContainer
                  : isPast
                  ? Colors.grey.shade100
                  : null,
              child: ListTile(
                leading: _getActivityIcon(block.activityType),
                title: Text(
                  block.title,
                  style: TextStyle(
                    color: isPast ? Colors.grey.shade600 : null,
                    decoration: isPast ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.timeRange,
                      style: TextStyle(
                        color: isPast ? Colors.grey.shade500 : null,
                      ),
                    ),
                    if (block.description != null &&
                        block.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          block.description!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isPast
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActive && !isPast)
                      IconButton(
                        icon: const Icon(Icons.snooze, size: 20),
                        onPressed: () =>
                            _snoozeTimeBlock(context, routine, block, ref),
                        tooltip: 'Snooze',
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          block.formattedDuration,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: isPast ? Colors.grey.shade400 : null,
                              ),
                        ),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'NOW',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        if (isPast && !isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'DONE',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                onTap: () =>
                    _showTimeBlockOptions(context, ref, routine, block),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load routine',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(todaysRoutineProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
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
      case 'commute':
        return const Icon(Icons.directions_car);
      case 'focus':
        return const Icon(Icons.center_focus_strong);
      default:
        return const Icon(Icons.event);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
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
    return '$weekday, $month ${date.day}';
  }

  Future<void> _regenerateRoutine(BuildContext context, WidgetRef ref) async {
    final routineAsync = ref.read(todaysRoutineProvider);
    final routine = routineAsync.value;

    if (routine == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No routine to regenerate')));
      return;
    }

    // Show AI consent dialog first
    final consent = await showAIConsentDialog(context);
    if (!consent) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI routine generation cancelled'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => RegenerateRoutineDialog(routine: routine),
    );

    if (result != null && context.mounted) {
      try {
        // Prepare user preferences with feedback
        final userPrefs = <String, dynamic>{};

        if (result['feedback'] != null) {
          userPrefs['regeneration_feedback'] = result['feedback'];
        }

        if (result['selectedBlocks'] != null) {
          final blocks = (result['selectedBlocks'] as List<TimeBlock>).map((b) {
            return {
              'id': b.id,
              'title': b.title,
              'startTime':
                  '${b.startTime.hour.toString().padLeft(2, '0')}:${b.startTime.minute.toString().padLeft(2, '0')}',
              'endTime':
                  '${b.endTime.hour.toString().padLeft(2, '0')}:${b.endTime.minute.toString().padLeft(2, '0')}',
              'activityType': b.activityType,
            };
          }).toList();
          userPrefs['blocks_to_change'] = blocks;
        }

        final newRoutine = await generateRoutineAction(
          ref,
          forceRegenerate: true,
          userPreferences: userPrefs.isNotEmpty ? userPrefs : null,
        );

        if (context.mounted) {
          // Check if Claude AI was used
          final isClaudeGenerated =
              newRoutine.explanation?.dataSourcesUsed?['claude_ai'] == true;
          final claudeAiEnabled = ref.read(isClaudeAiEnabledProvider);

          // Show success animation
          await showRoutineSuccessAnimation(
            context,
            message: isClaudeGenerated
                ? 'Routine regenerated with Claude AI!'
                : claudeAiEnabled
                ? 'Routine regenerated!'
                : 'Routine regenerated with ML!',
            isClaudeGenerated: isClaudeGenerated,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to regenerate: $e')));
        }
      }
    }
  }

  Future<void> _acceptRoutine(
    BuildContext context,
    WidgetRef ref,
    String routineId,
  ) async {
    try {
      await acceptRoutineAction(ref, routineId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Routine accepted!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to accept routine: $e')));
      }
    }
  }

  void _editTimeBlock(BuildContext context, Routine routine, TimeBlock block) {
    context.push('/routine/edit/${routine.id}');
  }

  void _showTimeBlockOptions(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
    TimeBlock block,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editTimeBlock(context, routine, block);
              },
            ),
            if (!block.isPast)
              ListTile(
                leading: const Icon(Icons.snooze),
                title: const Text('Snooze'),
                onTap: () {
                  Navigator.pop(context);
                  _snoozeTimeBlock(context, routine, block, ref);
                },
              ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Details'),
              onTap: () {
                Navigator.pop(context);
                _showTimeBlockDetails(context, block);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _snoozeTimeBlock(
    BuildContext context,
    Routine routine,
    TimeBlock block,
    WidgetRef ref,
  ) async {
    final snoozeDuration = await showDialog<Duration>(
      context: context,
      builder: (context) => SnoozeDialog(timeBlock: block),
    );

    if (snoozeDuration != null && context.mounted) {
      try {
        final service = ref.read(routineServiceProvider);
        await service.snoozeTimeBlock(
          routineId: routine.id,
          block: block,
          snoozeDuration: snoozeDuration,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Snoozed "${block.title}" for ${_formatDuration(snoozeDuration)}',
              ),
            ),
          );
          ref.invalidate(todaysRoutineProvider);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to snooze: $e')));
        }
      }
    }
  }

  void _showTimeBlockDetails(BuildContext context, TimeBlock block) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.red.shade50.withOpacity(0.3)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade600, Colors.red.shade400],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade300.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getActivityIconData(block.activityType),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time Block Details',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Activity Information',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Title
                  _buildStyledDetailField(
                    context,
                    icon: Icons.title,
                    label: 'Title',
                    value: block.title,
                  ),
                  const SizedBox(height: 16),

                  // Activity Type
                  _buildStyledDetailField(
                    context,
                    icon: Icons.category,
                    label: 'Activity Type',
                    value: ActivityType.getDisplayName(block.activityType),
                  ),
                  const SizedBox(height: 16),

                  // Time Range
                  _buildStyledDetailField(
                    context,
                    icon: Icons.access_time,
                    label: 'Time',
                    value: block.timeRange,
                  ),
                  const SizedBox(height: 16),

                  // Duration with special styling
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade50,
                          Colors.red.shade100.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Duration: ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          block.formattedDuration,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Description if available
                  if (block.description != null &&
                      block.description!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildStyledDetailField(
                      context,
                      icon: Icons.notes,
                      label: 'Description',
                      value: block.description!,
                      isMultiline: true,
                    ),
                  ],

                  // Snoozed status if applicable
                  if (block.isSnoozed && block.snoozedUntil != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.snooze,
                            size: 20,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Snoozed',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Until ${_formatTime(TimeOfDay.fromDateTime(block.snoozedUntil!))}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.orange.shade900),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Close button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'CLOSE',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDetailField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: isMultiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIconData(String activityType) {
    switch (activityType) {
      case 'work':
        return Icons.work;
      case 'meeting':
        return Icons.people;
      case 'exercise':
        return Icons.fitness_center;
      case 'meal':
        return Icons.restaurant;
      case 'sleep':
        return Icons.bed;
      case 'commute':
        return Icons.directions_car;
      case 'focus':
        return Icons.center_focus_strong;
      case 'personal':
        return Icons.person;
      case 'break':
        return Icons.coffee;
      case 'social':
        return Icons.groups;
      case 'learning':
        return Icons.school;
      case 'entertainment':
        return Icons.movie;
      case 'chores':
        return Icons.cleaning_services;
      case 'health':
        return Icons.medical_services;
      default:
        return Icons.event;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    }
    return '${duration.inMinutes} minutes';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
