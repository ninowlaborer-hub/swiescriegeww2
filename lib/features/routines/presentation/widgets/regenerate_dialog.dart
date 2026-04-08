import 'package:flutter/material.dart';
import '../../domain/routine.dart';
import '../../domain/time_block.dart';

/// Dialog for regenerating routine with user feedback
///
/// Allows users to:
/// - Select specific time blocks to change
/// - Provide feedback on what to change
/// - Request specific additions
class RegenerateRoutineDialog extends StatefulWidget {
  const RegenerateRoutineDialog({
    super.key,
    required this.routine,
  });

  final Routine routine;

  @override
  State<RegenerateRoutineDialog> createState() => _RegenerateRoutineDialogState();
}

class _RegenerateRoutineDialogState extends State<RegenerateRoutineDialog> {
  final _feedbackController = TextEditingController();
  final Set<String> _selectedBlockIds = {};
  bool _selectAll = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedBlockIds.addAll(widget.routine.timeBlocks.map((b) => b.id));
      } else {
        _selectedBlockIds.clear();
      }
    });
  }

  void _toggleBlock(String blockId) {
    setState(() {
      if (_selectedBlockIds.contains(blockId)) {
        _selectedBlockIds.remove(blockId);
        _selectAll = false;
      } else {
        _selectedBlockIds.add(blockId);
        if (_selectedBlockIds.length == widget.routine.timeBlocks.length) {
          _selectAll = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_fix_high,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Regenerate Routine',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select blocks to change and tell us what you want',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Feedback input
                  Text(
                    'What would you like to change?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Example: "Add more time for exercise" or "Move lunch earlier" or "Include time for reading"',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Block selection header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select blocks to change',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _toggleSelectAll,
                        icon: Icon(
                          _selectAll ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 20,
                        ),
                        label: Text(_selectAll ? 'Deselect All' : 'Select All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Time blocks list
                  ...widget.routine.timeBlocks.map((block) {
                    final isSelected = _selectedBlockIds.contains(block.id);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                          : null,
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) => _toggleBlock(block.id),
                        title: Text(block.title),
                        subtitle: Text(
                          '${block.timeRange} • ${block.activityType}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        secondary: _getActivityIcon(block.activityType),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Claude AI will regenerate your routine based on your feedback and selected blocks',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.blue.shade900,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FilledButton.icon(
                      onPressed: () {
                        final feedback = _feedbackController.text.trim();
                        final selectedBlocks = widget.routine.timeBlocks
                            .where((b) => _selectedBlockIds.contains(b.id))
                            .toList();

                        Navigator.of(context).pop({
                          'feedback': feedback.isEmpty ? null : feedback,
                          'selectedBlocks': selectedBlocks.isEmpty ? null : selectedBlocks,
                          'regenerateAll': _selectAll,
                        });
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text(
                        'Regenerate with AI',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
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
}

/// Result of regeneration dialog
class RegenerateRequest {
  RegenerateRequest({
    this.feedback,
    this.selectedBlocks,
    this.regenerateAll = false,
  });

  final String? feedback;
  final List<TimeBlock>? selectedBlocks;
  final bool regenerateAll;

  bool get hasUserInput => feedback != null || (selectedBlocks?.isNotEmpty ?? false);
}
