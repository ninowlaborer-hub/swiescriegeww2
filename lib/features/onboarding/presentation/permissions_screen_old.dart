import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_providers.dart';

/// Permission request flow UI
///
/// Second screen in onboarding. Requests permissions for:
/// - Calendar: Required for routine generation
/// - Location: Optional for weather-aware routines
/// - Health: Optional for sleep-aware routines
/// - Analytics: Optional for anonymous usage analytics
class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({
    super.key,
    this.onComplete,
  });

  final VoidCallback? onComplete;

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(onboardingPermissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Permissions'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: 0.5, // Step 2 of 4
                backgroundColor: Colors.grey[200],
              ),

              const SizedBox(height: 24),

              // Header
              Text(
                'Grant Permissions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                'Swisscierge needs access to these features to personalize your routines. '
                'You can skip optional permissions and enable them later in settings.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),

              const SizedBox(height: 32),

              // Permissions list
              Expanded(
                child: ListView(
                  children: [
                    _PermissionCard(
                      icon: Icons.calendar_today,
                      title: 'Calendar',
                      description:
                          'Access your device calendars to generate routines around your events',
                      required: true,
                      granted: permissions['calendar'] ?? false,
                      onToggle: () => _requestPermission('calendar'),
                    ),

                    const SizedBox(height: 16),

                    _PermissionCard(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      description:
                          'Get weather forecasts for your area to suggest weather-appropriate activities',
                      required: false,
                      granted: permissions['location'] ?? false,
                      onToggle: () => _requestPermission('location'),
                    ),

                    const SizedBox(height: 16),

                    _PermissionCard(
                      icon: Icons.favorite_outline,
                      title: 'Health Data',
                      description:
                          'Access sleep data to suggest routines based on how well you slept',
                      required: false,
                      granted: permissions['health'] ?? false,
                      onToggle: () => _requestPermission('health'),
                    ),

                    const SizedBox(height: 16),

                    _PermissionCard(
                      icon: Icons.analytics_outlined,
                      title: 'Analytics',
                      description:
                          'Send anonymous usage data to help improve the app (no personal data)',
                      required: false,
                      granted: permissions['analytics'] ?? false,
                      onToggle: () => _toggleAnalytics(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: permissions['calendar'] == true
                      ? () async {
                          await completePermissionsAction(ref);
                          widget.onComplete?.call();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ),

              if (permissions['calendar'] != true) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Calendar permission is required to continue',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermission(String permission) async {
    // TODO: Implement actual permission request using platform channels
    // For now, just toggle the state
    final permissions = ref.read(onboardingPermissionsProvider.notifier);
    final current = ref.read(onboardingPermissionsProvider);

    permissions.state = {
      ...current,
      permission: !(current[permission] ?? false),
    };

    // Show dialog explaining permission
    if (mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('$permission Permission'),
          content: Text(
            'In a production app, this would request $permission permission from the system.\n\n'
            'For now, this is a placeholder that simulates granting permission.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _toggleAnalytics() {
    final permissions = ref.read(onboardingPermissionsProvider.notifier);
    final current = ref.read(onboardingPermissionsProvider);

    permissions.state = {
      ...current,
      'analytics': !(current['analytics'] ?? false),
    };
  }
}

/// Individual permission card widget
class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.required,
    required this.granted,
    required this.onToggle,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool required;
  final bool granted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: granted ? 2 : 0,
      color: granted
          ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
          : Colors.grey[50],
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: granted
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: granted
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (required) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.orange[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          granted ? Icons.check_circle : Icons.circle_outlined,
                          size: 20,
                          color: granted ? Colors.green : Colors.grey[400],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          granted ? 'Granted' : 'Not granted',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: granted ? Colors.green : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
