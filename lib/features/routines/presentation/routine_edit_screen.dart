import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/routine.dart';
import '../domain/time_block.dart';
import 'routine_providers.dart';
import 'widgets/time_block_edit_dialog.dart';

/// Routine edit screen - allows editing routine and time blocks
///
/// Supports editing routine title, adding/removing time blocks,
/// and modifying individual time block properties.
class RoutineEditScreen extends ConsumerStatefulWidget {
  const RoutineEditScreen({
    super.key,
    required this.routineId,
  });

  final String routineId;

  @override
  ConsumerState<RoutineEditScreen> createState() => _RoutineEditScreenState();
}

class _RoutineEditScreenState extends ConsumerState<RoutineEditScreen> {
  late TextEditingController _titleController;
  late Routine _editedRoutine;
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the proper routineByIdProvider instead of FutureBuilder
    final routineAsync = ref.watch(routineByIdProvider(widget.routineId));

    return routineAsync.when(
      data: (routine) {
        if (routine == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Routine not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        // Initialize on first build
        if (_titleController.text.isEmpty) {
          _titleController.text = routine.title;
          _editedRoutine = routine;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Routine'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _handleBack(context),
            ),
            actions: [
              if (_hasChanges)
                TextButton(
                  onPressed: _isSaving ? null : () => _saveChanges(context, routine.date),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('SAVE'),
                ),
            ],
          ),
          body: _buildEditContent(context),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load routine: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Routine title
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Routine Title',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter routine title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _markAsChanged(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Time blocks section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time Blocks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addTimeBlock(context),
              tooltip: 'Add time block',
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Time blocks list
        ..._editedRoutine.timeBlocks.asMap().entries.map((entry) {
          final index = entry.key;
          final block = entry.value;
          return _buildTimeBlockCard(context, block, index);
        }),

        // Info message
        const SizedBox(height: 16),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap a time block to edit its details',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBlockCard(BuildContext context, TimeBlock block, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _getActivityIcon(block.activityType),
        title: Text(block.title),
        subtitle: Text(block.timeRange),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _editTimeBlock(context, block, index),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () => _deleteTimeBlock(context, index),
              tooltip: 'Delete',
            ),
          ],
        ),
        onTap: () => _editTimeBlock(context, block, index),
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

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _editTimeBlock(
    BuildContext context,
    TimeBlock block,
    int index,
  ) async {
    final updatedBlock = await showDialog<TimeBlock>(
      context: context,
      builder: (context) => TimeBlockEditDialog(timeBlock: block),
    );

    if (updatedBlock != null) {
      setState(() {
        final blocks = List<TimeBlock>.from(_editedRoutine.timeBlocks);
        blocks[index] = updatedBlock;
        _editedRoutine = _editedRoutine.copyWith(timeBlocks: blocks);
        _markAsChanged();
      });
    }
  }

  Future<void> _addTimeBlock(BuildContext context) async {
    // Determine start time for new block (after last block)
    final lastBlock = _editedRoutine.timeBlocks.isNotEmpty
        ? _editedRoutine.timeBlocks.last
        : null;

    final newStartTime = lastBlock != null
        ? lastBlock.endTime
        : DateTime(
            _editedRoutine.date.year,
            _editedRoutine.date.month,
            _editedRoutine.date.day,
            9,
            0,
          );

    final newBlock = TimeBlock(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      routineId: _editedRoutine.id,
      title: 'New Activity',
      startTime: newStartTime,
      endTime: newStartTime.add(const Duration(hours: 1)),
      activityType: ActivityType.other,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final updatedBlock = await showDialog<TimeBlock>(
      context: context,
      builder: (context) => TimeBlockEditDialog(
        timeBlock: newBlock,
        isNewBlock: true,
      ),
    );

    if (updatedBlock != null) {
      setState(() {
        final blocks = List<TimeBlock>.from(_editedRoutine.timeBlocks)
          ..add(updatedBlock);
        _editedRoutine = _editedRoutine.copyWith(timeBlocks: blocks);
        _markAsChanged();
      });
    }
  }

  Future<void> _deleteTimeBlock(BuildContext context, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Time Block?'),
        content: Text(
          'Are you sure you want to delete "${_editedRoutine.timeBlocks[index].title}"?',
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

    if (confirmed == true) {
      setState(() {
        final blocks = List<TimeBlock>.from(_editedRoutine.timeBlocks)
          ..removeAt(index);
        _editedRoutine = _editedRoutine.copyWith(timeBlocks: blocks);
        _markAsChanged();
      });
    }
  }

  Future<void> _saveChanges(BuildContext context, DateTime routineDate) async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Update title
      final updatedRoutine = _editedRoutine.copyWith(
        title: _titleController.text.trim(),
        updatedAt: DateTime.now(),
      );

      // Save via repository
      final repository = ref.read(routineRepositoryProvider);
      await repository.saveRoutine(updatedRoutine);

      // Refresh providers - both today's and date-specific
      ref.invalidate(todaysRoutineProvider);
      ref.invalidate(routineForDateProvider(routineDate));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Routine saved successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _handleBack(BuildContext context) async {
    if (!_hasChanges) {
      context.pop();
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
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
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (shouldDiscard == true && context.mounted) {
      context.pop();
    }
  }
}
