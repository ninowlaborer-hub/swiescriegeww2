import 'package:flutter/material.dart';
import '../../domain/time_block.dart';

/// Dialog for snoozing time blocks
///
/// Allows users to delay a time block by a preset duration.
/// Common use cases: snooze alarm-like reminders, delay activities.
class SnoozeDialog extends StatefulWidget {
  const SnoozeDialog({
    super.key,
    required this.timeBlock,
  });

  final TimeBlock timeBlock;

  @override
  State<SnoozeDialog> createState() => _SnoozeDialogState();
}

class _SnoozeDialogState extends State<SnoozeDialog> {
  Duration? _selectedDuration;

  final List<Duration> _snoozeDurations = [
    const Duration(minutes: 5),
    const Duration(minutes: 10),
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Snooze Time Block'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delay "${widget.timeBlock.title}" by:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ..._snoozeDurations.map((duration) {
            return RadioListTile<Duration>(
              value: duration,
              groupValue: _selectedDuration,
              title: Text(_formatDuration(duration)),
              subtitle: _selectedDuration == duration
                  ? Text(
                      'New start time: ${_formatNewTime(duration)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : null,
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _selectedDuration != null
              ? () => Navigator.of(context).pop(_selectedDuration)
              : null,
          child: const Text('SNOOZE'),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    }
    return '${duration.inMinutes} minutes';
  }

  String _formatNewTime(Duration duration) {
    final newStart = widget.timeBlock.startTime.add(duration);
    final hour = newStart.hour > 12 ? newStart.hour - 12 : newStart.hour;
    final minute = newStart.minute.toString().padLeft(2, '0');
    final period = newStart.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;
    return '$displayHour:$minute $period';
  }
}

/// Quick snooze options widget
///
/// Shows inline snooze buttons for quick actions without dialog.
class QuickSnoozeActions extends StatelessWidget {
  const QuickSnoozeActions({
    super.key,
    required this.onSnooze,
  });

  final Function(Duration) onSnooze;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSnoozeChip(
          context,
          '5m',
          const Duration(minutes: 5),
        ),
        _buildSnoozeChip(
          context,
          '10m',
          const Duration(minutes: 10),
        ),
        _buildSnoozeChip(
          context,
          '15m',
          const Duration(minutes: 15),
        ),
        _buildSnoozeChip(
          context,
          '30m',
          const Duration(minutes: 30),
        ),
        _buildSnoozeChip(
          context,
          '1h',
          const Duration(hours: 1),
        ),
      ],
    );
  }

  Widget _buildSnoozeChip(
    BuildContext context,
    String label,
    Duration duration,
  ) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onSnooze(duration),
      avatar: const Icon(Icons.snooze, size: 18),
    );
  }
}
