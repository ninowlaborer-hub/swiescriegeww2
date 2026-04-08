import 'package:flutter/material.dart';
import '../../domain/time_block.dart';

/// Dialog for editing time block details
///
/// Allows editing title, start/end times, activity type, and description.
/// Validates that end time is after start time.
class TimeBlockEditDialog extends StatefulWidget {
  const TimeBlockEditDialog({
    super.key,
    required this.timeBlock,
    this.isNewBlock = false,
  });

  final TimeBlock timeBlock;
  final bool isNewBlock;

  @override
  State<TimeBlockEditDialog> createState() => _TimeBlockEditDialogState();
}

class _TimeBlockEditDialogState extends State<TimeBlockEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _activityType;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.timeBlock.title);
    _descriptionController = TextEditingController(
      text: widget.timeBlock.description ?? '',
    );
    _startTime = TimeOfDay.fromDateTime(widget.timeBlock.startTime);
    _endTime = TimeOfDay.fromDateTime(widget.timeBlock.endTime);
    _activityType = widget.timeBlock.activityType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.red.shade50.withValues(alpha: 0.3)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
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
                              color: Colors.red.shade300.withValues(alpha: 0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.isNewBlock
                              ? Icons.add_circle_outline
                              : Icons.edit,
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
                              widget.isNewBlock
                                  ? 'Add Time Block'
                                  : 'Edit Time Block',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isNewBlock
                                  ? 'Create a new activity block'
                                  : 'Modify activity details',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Title field
                  _buildStyledTextField(
                    controller: _titleController,
                    label: 'Title',
                    icon: Icons.title,
                    hint: 'e.g., Morning workout',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.length > 100) {
                        return 'Title too long (max 100 characters)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Activity type dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _activityType,
                      decoration: InputDecoration(
                        labelText: 'Activity Type',
                        labelStyle: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade600,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.category,
                          color: Colors.red.shade600,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _buildActivityTypeItems(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _activityType = value;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Time pickers row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePicker(
                          context: context,
                          label: 'Start Time',
                          time: _startTime,
                          icon: Icons.access_time,
                          onTap: () => _selectStartTime(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimePicker(
                          context: context,
                          label: 'End Time',
                          time: _endTime,
                          icon: Icons.access_time_filled,
                          onTap: () => _selectEndTime(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Duration indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade50,
                          Colors.red.shade100.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Duration: ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          _calculateDuration(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description field
                  _buildStyledTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.notes,
                    hint: 'Add any additional notes...',
                    maxLines: 4,
                    maxLength: 500,
                    isOptional: true,
                  ),

                  const SizedBox(height: 28),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
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
                          'CANCEL',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _saveTimeBlock,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isNewBlock ? Icons.add : Icons.check,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isNewBlock ? 'ADD' : 'SAVE',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    bool isOptional = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: isOptional ? '$label (optional)' : label,
          labelStyle: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w500,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade600, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          prefixIcon: Icon(icon, color: Colors.red.shade600),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(icon, color: Colors.red.shade600),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          child: Text(
            _formatTime(time),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red.shade900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildActivityTypeItems() {
    final types = [
      (ActivityType.work, 'Work', Icons.work),
      (ActivityType.meeting, 'Meeting', Icons.people),
      (ActivityType.focus, 'Focus Time', Icons.center_focus_strong),
      (ActivityType.exercise, 'Exercise', Icons.fitness_center),
      (ActivityType.meal, 'Meal', Icons.restaurant),
      (ActivityType.commute, 'Commute', Icons.directions_car),
      (ActivityType.social, 'Social', Icons.people_outline),
      (ActivityType.learning, 'Learning', Icons.school),
      (ActivityType.chores, 'Chores', Icons.cleaning_services),
      (ActivityType.personal, 'Personal Time', Icons.person),
      (ActivityType.break_, 'Break', Icons.free_breakfast),
      (ActivityType.entertainment, 'Entertainment', Icons.movie),
      (ActivityType.other, 'Other', Icons.event),
    ];

    return types.map((type) {
      return DropdownMenuItem(
        value: type.$1,
        child: Row(
          children: [
            Icon(type.$3, size: 20),
            const SizedBox(width: 8),
            Text(type.$2),
          ],
        ),
      );
    }).toList();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _calculateDuration() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    var endMinutes = _endTime.hour * 60 + _endTime.minute;

    // Handle case where end time is next day
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60;
    }

    final durationMinutes = endMinutes - startMinutes;
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (time != null) {
      setState(() {
        _startTime = time;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final time = await showTimePicker(context: context, initialTime: _endTime);

    if (time != null) {
      setState(() {
        _endTime = time;
      });
    }
  }

  void _saveTimeBlock() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate time range
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    var endMinutes = _endTime.hour * 60 + _endTime.minute;

    // Allow end time to be next day
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60;
    }

    if (endMinutes - startMinutes < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Time block must be at least 15 minutes long'),
        ),
      );
      return;
    }

    // Create updated time block
    final baseDate = widget.timeBlock.startTime;
    final startDateTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    var endDateTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    // If end time is before start time, add a day
    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    final updatedBlock = widget.timeBlock.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
      activityType: _activityType,
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop(updatedBlock);
  }
}
