import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calendar_providers.dart';

/// Calendar permission request widget
///
/// Displays when calendar permissions are not granted.
/// Explains why permissions are needed and provides request button.
class CalendarPermissionWidget extends ConsumerWidget {
  const CalendarPermissionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              'Calendar Access',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'Swisscierge needs access to your calendars to create personalized daily routines.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Benefits list
            _buildBenefitItem(
              context,
              Icons.auto_awesome,
              'Smart Scheduling',
              'Routines fit around your meetings and events',
            ),

            const SizedBox(height: 12),

            _buildBenefitItem(
              context,
              Icons.sync,
              'Two-Way Sync',
              'Write accepted routines back to your calendar',
            ),

            const SizedBox(height: 12),

            _buildBenefitItem(
              context,
              Icons.lock,
              'Privacy First',
              'All data stays on your device',
            ),

            const SizedBox(height: 32),

            // Request button
            ElevatedButton.icon(
              onPressed: () => _requestPermissions(context, ref),
              icon: const Icon(Icons.check_circle),
              label: const Text('Grant Calendar Access'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Skip button
            TextButton(
              onPressed: () => _skipPermissions(context),
              child: const Text('Skip for now'),
            ),

            const SizedBox(height: 24),

            // Privacy note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your calendar data is never sent to external servers',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade700,
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

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _requestPermissions(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final granted = await requestCalendarPermissionsAction(ref);

      if (!context.mounted) return;

      if (granted) {
        // Permissions granted, sync calendars
        await syncCalendarSourcesAction(ref);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar access granted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Permissions denied, show settings prompt
        _showSettingsDialog(context, ref);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request permissions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _skipPermissions(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Calendar Access?'),
        content: const Text(
          'You can still use Swisscierge without calendar access, but routines won\'t be aware of your scheduled events.\n\nYou can grant access later in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calendar Access Required'),
        content: const Text(
          'Calendar permissions were denied. To use calendar features, please grant access in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openCalendarSettingsAction(ref);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

/// Compact calendar permission banner
///
/// Shows a dismissible banner when permissions are not granted.
class CalendarPermissionBanner extends ConsumerWidget {
  const CalendarPermissionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsAsync = ref.watch(calendarPermissionsProvider);

    return permissionsAsync.when(
      data: (hasPermissions) {
        if (hasPermissions) {
          return const SizedBox.shrink();
        }

        return MaterialBanner(
          backgroundColor: Colors.orange.shade100,
          leading: Icon(
            Icons.calendar_today,
            color: Colors.orange.shade700,
          ),
          content: Text(
            'Enable calendar access for smarter routines',
            style: TextStyle(color: Colors.orange.shade900),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await requestCalendarPermissionsAction(ref);
              },
              child: Text(
                'ENABLE',
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
