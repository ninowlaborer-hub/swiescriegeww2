import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_providers.dart';

/// User preferences setup UI
///
/// Third screen in onboarding. Configures:
/// - Work window (start and end times)
/// - Quiet hours (sleep schedule)
/// - Activity preferences (exercise, social, learning)
class PreferencesSetupScreen extends ConsumerStatefulWidget {
  const PreferencesSetupScreen({
    super.key,
    this.onComplete,
  });

  final VoidCallback? onComplete;

  @override
  ConsumerState<PreferencesSetupScreen> createState() =>
      _PreferencesSetupScreenState();
}

class _PreferencesSetupScreenState
    extends ConsumerState<PreferencesSetupScreen> {
  late TimeOfDay _workStart;
  late TimeOfDay _workEnd;
  late TimeOfDay _quietStart;
  late TimeOfDay _quietEnd;
  late Map<String, bool> _activities;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(onboardingPreferencesProvider);

    // Parse times from preferences
    _workStart = _parseTime(prefs['work_window_start'] as String);
    _workEnd = _parseTime(prefs['work_window_end'] as String);
    _quietStart = _parseTime(prefs['quiet_hours_start'] as String);
    _quietEnd = _parseTime(prefs['quiet_hours_end'] as String);
    _activities =
        Map<String, bool>.from(prefs['activity_preferences'] as Map);
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Preferences'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: LinearProgressIndicator(
                value: 0.75, // Step 3 of 4
                backgroundColor: Colors.grey[200],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  // Header
                  Text(
                    'Set Your Schedule',
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Help us personalize your daily routines by setting your typical schedule and preferences.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),

                  const SizedBox(height: 32),

                  // Work Window Section
                  _buildSectionHeader(
                    context,
                    icon: Icons.work_outline,
                    title: 'Work Hours',
                    subtitle: 'When do you typically work?',
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePicker(
                          context,
                          label: 'Start Time',
                          time: _workStart,
                          onChanged: (time) {
                            setState(() => _workStart = time);
                            _updatePreferences();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimePicker(
                          context,
                          label: 'End Time',
                          time: _workEnd,
                          onChanged: (time) {
                            setState(() => _workEnd = time);
                            _updatePreferences();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Quiet Hours Section
                  _buildSectionHeader(
                    context,
                    icon: Icons.bedtime_outlined,
                    title: 'Quiet Hours',
                    subtitle: 'When do you sleep?',
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePicker(
                          context,
                          label: 'Sleep Time',
                          time: _quietStart,
                          onChanged: (time) {
                            setState(() => _quietStart = time);
                            _updatePreferences();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimePicker(
                          context,
                          label: 'Wake Time',
                          time: _quietEnd,
                          onChanged: (time) {
                            setState(() => _quietEnd = time);
                            _updatePreferences();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Activity Preferences Section
                  _buildSectionHeader(
                    context,
                    icon: Icons.favorite_outline,
                    title: 'Activity Preferences',
                    subtitle: 'What activities do you enjoy?',
                  ),

                  const SizedBox(height: 16),

                  _buildActivityToggle(
                    context,
                    icon: Icons.fitness_center,
                    title: 'Exercise',
                    description: 'Include workout and physical activities',
                    value: _activities['exercise'] ?? true,
                    onChanged: (value) {
                      setState(() => _activities['exercise'] = value);
                      _updatePreferences();
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildActivityToggle(
                    context,
                    icon: Icons.people_outline,
                    title: 'Social',
                    description: 'Include social and networking activities',
                    value: _activities['social'] ?? true,
                    onChanged: (value) {
                      setState(() => _activities['social'] = value);
                      _updatePreferences();
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildActivityToggle(
                    context,
                    icon: Icons.school_outlined,
                    title: 'Learning',
                    description: 'Include educational and skill-building activities',
                    value: _activities['learning'] ?? false,
                    onChanged: (value) {
                      setState(() => _activities['learning'] = value);
                      _updatePreferences();
                    },
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await completePreferencesAction(
                          ref,
                          ref.read(onboardingPreferencesProvider),
                        );
                        widget.onComplete?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'You can change these preferences anytime in settings',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePreferences() {
    ref.read(onboardingPreferencesProvider.notifier).state = {
      'work_window_start': _formatTime(_workStart),
      'work_window_end': _formatTime(_workEnd),
      'quiet_hours_start': _formatTime(_quietStart),
      'quiet_hours_end': _formatTime(_quietEnd),
      'activity_preferences': _activities,
    };
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(
    BuildContext context, {
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(Icons.access_time, color: Colors.grey[600]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: value
          ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
          : Colors.grey[50],
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: value
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: value ? Theme.of(context).primaryColor : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}
