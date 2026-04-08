import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/offline_indicator.dart';
import 'routine_providers.dart';
import '../domain/routine.dart';
import '../domain/routine_explanation.dart';
import '../domain/time_block.dart';
import 'widgets/ai_generation_loading.dart';
import 'widgets/regenerate_dialog.dart';
import 'widgets/routine_success_animation.dart';
import 'widgets/ai_consent_dialog.dart';
import '../../../core/ai/claude_ai_provider.dart';

/// Routine date view screen - displays routine for a specific date
///
/// Shows routine with time blocks, offline indicator,
/// and options to regenerate, edit, or accept the routine.
class RoutineDateViewScreen extends ConsumerWidget {
  const RoutineDateViewScreen({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Normalize date to ensure proper cache key matching
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final routineAsync = ref.watch(routineForDateProvider(normalizedDate));
    final isGenerating = ref.watch(routineGenerationLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatDate(date)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_view_week),
            onPressed: () => context.push('/routine/week'),
            tooltip: 'Week Planner',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isGenerating ? null : () => _regenerateRoutine(context, ref),
            tooltip: 'Regenerate',
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
                  data: (routine) => routine != null
                      ? _buildRoutineContent(context, ref, routine)
                      : _buildEmptyState(context, ref),
                  loading: () => const Center(
                    child: AIGenerationLoading(),
                  ),
                  error: (error, stack) => _buildErrorState(context, ref, error),
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
        data: (routine) => routine != null && !routine.isAccepted && !isGenerating
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

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No routine planned',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Generate a routine for this date',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _generateRoutine(context, ref),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Routine'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineHeader(BuildContext context, Routine routine) {
    final isClaudeGenerated = routine.explanation?.dataSourcesUsed?['claude_ai'] == true;
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Accepted',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
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
            _buildAIGenerationBadge(context, isClaudeGenerated, hasHighConfidence),

            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(routine.date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${routine.timeBlocks.length} blocks',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                if (routine.confidenceScore != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bar_chart, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${(routine.confidenceScore! * 100).toInt()}% confidence',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
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

  Widget _buildAIGenerationBadge(BuildContext context, bool isClaudeGenerated, bool hasHighConfidence) {
    if (isClaudeGenerated) {
      return Tooltip(
        message: 'This routine was enhanced by Claude AI for higher quality and personalization.',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.purple.shade100],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.shade300,
              width: 1,
            ),
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
        message: 'This routine was generated using on-device machine learning.',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1,
            ),
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

  Widget _buildDataSourcesIndicator(BuildContext context, RoutineExplanation explanation) {
    final dataSources = <Map<String, dynamic>>[];

    // Check data sources from dataSourcesUsed map
    if (explanation.dataSourcesUsed?.containsKey('calendar') ?? false) {
      dataSources.add({
        'icon': Icons.calendar_today,
        'label': 'Calendar',
        'colorLight': Colors.blue.shade50,
        'colorBorder': Colors.blue.shade200,
        'colorText': Colors.blue.shade700,
      });
    }

    if (explanation.dataSourcesUsed?.containsKey('sleep') ?? false) {
      dataSources.add({
        'icon': Icons.bedtime,
        'label': 'Sleep',
        'colorLight': Colors.indigo.shade50,
        'colorBorder': Colors.indigo.shade200,
        'colorText': Colors.indigo.shade700,
      });
    }

    if (explanation.dataSourcesUsed?.containsKey('weather') ?? false) {
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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
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
    final isClaudeGenerated = routine.explanation?.dataSourcesUsed?['claude_ai'] == true;

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
            child: Text(
              routine.explanation!.formattedText,
              style: Theme.of(context).textTheme.bodyMedium,
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
            Text(
              'Time Blocks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${routine.timeBlocks.length} total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),

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
            final isLast = index == routine.timeBlocks.length - 1;

            return Card(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
              child: ListTile(
                leading: _getActivityIcon(block.activityType),
                title: Text(block.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(block.timeRange),
                    if (block.description != null && block.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          block.description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                trailing: Text(
                  block.formattedDuration,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                onTap: () => _editRoutine(context, routine.id),
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
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
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
              onPressed: () => ref.invalidate(routineForDateProvider(date)),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    final tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  Future<void> _generateRoutine(BuildContext context, WidgetRef ref) async {
    try {
      final routine = await generateRoutineAction(ref, date: date);

      if (context.mounted) {
        // Check if Claude AI was used
        final isClaudeGenerated = routine.explanation?.dataSourcesUsed?['claude_ai'] == true;
        final claudeAiEnabled = ref.read(isClaudeAiEnabledProvider);

        // Show success animation
        await showRoutineSuccessAnimation(
          context,
          message: isClaudeGenerated
              ? 'Routine generated with Claude AI!'
              : claudeAiEnabled
                  ? 'Routine generated!'
                  : 'Routine generated with ML!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _regenerateRoutine(BuildContext context, WidgetRef ref) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final routineAsync = ref.read(routineForDateProvider(normalizedDate));
    final routine = routineAsync.value;

    if (routine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No routine to regenerate')),
      );
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
        final userPrefs = <String, dynamic>{};

        if (result['feedback'] != null) {
          userPrefs['regeneration_feedback'] = result['feedback'];
        }

        if (result['selectedBlocks'] != null) {
          final blocks = (result['selectedBlocks'] as List<TimeBlock>).map((b) {
            return {
              'id': b.id,
              'title': b.title,
              'startTime': '${b.startTime.hour.toString().padLeft(2, '0')}:${b.startTime.minute.toString().padLeft(2, '0')}',
              'endTime': '${b.endTime.hour.toString().padLeft(2, '0')}:${b.endTime.minute.toString().padLeft(2, '0')}',
              'activityType': b.activityType,
            };
          }).toList();
          userPrefs['blocks_to_change'] = blocks;
        }

        final newRoutine = await generateRoutineAction(
          ref,
          date: date,
          forceRegenerate: true,
          userPreferences: userPrefs.isNotEmpty ? userPrefs : null,
        );

        if (context.mounted) {
          final isClaudeGenerated = newRoutine.explanation?.dataSourcesUsed?['claude_ai'] == true;
          final claudeAiEnabled = ref.read(isClaudeAiEnabledProvider);

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to regenerate: $e')),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Routine accepted!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept routine: $e')),
        );
      }
    }
  }

  void _editRoutine(BuildContext context, String routineId) {
    context.push('/routine/edit/$routineId');
  }
}
