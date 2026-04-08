import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'onboarding_providers.dart';
import '../../../core/ui/animations.dart';
import '../../../core/ui/swiss_loading.dart';

/// Permission request flow UI with real system permissions
///
/// Second screen in onboarding. Requests permissions for:
/// - Calendar: Required for routine generation
/// - Calendar: Required for routine generation
class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  bool _isLoading = false;

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
              SwissLinearProgress(
                value: 0.5, // Step 2 of 4
              ),

              const SizedBox(height: 24),

              // Header with animation
              SwissAnimations.fadeIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grant Permissions',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Swisscierge needs access to these features to personalize your routines. '
                      'You can skip optional permissions and enable them later in settings.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Permissions list with staggered animation - wrapped in SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SwissAnimations.staggeredList(
                    itemDelay: const Duration(milliseconds: 80),
                    children: [
                      _PermissionCard(
                        icon: Icons.calendar_today,
                        title: 'Calendar',
                        description:
                            'Access your device calendars to generate routines around your events',
                        required: true,
                        granted: permissions['calendar'] ?? false,
                        onToggle: () => _requestCalendarPermission(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Continue button with animation
              SwissAnimations.slideInFade(
                begin: const Offset(0, 0.05),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : permissions['calendar'] == true
                            ? () async {
                                await completePermissionsAction(ref);
                                widget.onComplete?.call();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Continue'),
                      ),
                    ),
                    if (permissions['calendar'] != true) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Calendar permission is required to continue',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.orange[700]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Request Calendar permission (iOS and Android)
  Future<void> _requestCalendarPermission() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('🗓️ Requesting calendar permission...');

      // Request Calendar Full Access (iOS 17+ and Android)
      // This permission allows both read and write access to calendars
      final status = await Permission.calendarFullAccess.request();
      debugPrint('📅 Calendar Full Access status: $status');

      if (!mounted) return;

      final permissions = ref.read(onboardingPermissionsProvider.notifier);
      final current = ref.read(onboardingPermissionsProvider);

      final granted = status.isGranted;
      debugPrint('✅ Calendar permission granted: $granted');

      permissions.state = {...current, 'calendar': granted};

      if (status.isDenied) {
        debugPrint('❌ Calendar permission denied');
        await _showPermissionDeniedDialog(
          'Calendar',
          'Calendar access is required for Swisscierge to work properly.\n\n'
              'Swisscierge needs to read your calendar events to create '
              'personalized daily routines that work around your schedule.',
          canOpenSettings: false,
        );
      } else if (status.isPermanentlyDenied) {
        debugPrint('🚫 Calendar permission permanently denied');
        await _showPermissionDeniedDialog(
          'Calendar',
          'Calendar access is required for Swisscierge.\n\n'
              'Please enable it in Settings:\n'
              'Settings → Privacy & Security → Calendars → Swisscierge',
          canOpenSettings: true,
        );
      } else if (granted) {
        debugPrint('🎉 Calendar permission granted successfully!');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error requesting calendar permission: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to request calendar permission.\n'
              'Please check Info.plist configuration.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Details',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Permission Error'),
                    content: SingleChildScrollView(
                      child: Text('Error: $e\n\nStack trace:\n$stackTrace'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Show permission denied dialog
  Future<void> _showPermissionDeniedDialog(
    String permissionName,
    String message, {
    required bool canOpenSettings,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              canOpenSettings ? Icons.settings : Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('$permissionName Permission')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (canOpenSettings) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, size: 16, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to enable:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Tap "Open Settings" below\n'
                      '2. Find "Calendars" in Privacy\n'
                      '3. Toggle Swisscierge ON',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(canOpenSettings ? 'Later' : 'OK'),
          ),
          if (canOpenSettings)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                // Open iOS Settings directly to Privacy & Security section
                // This will open Settings app, user needs to navigate to Calendars
                await openAppSettings();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Individual permission card widget with animations
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
    return SwissAnimatedContainer(
      duration: SwissAnimations.standard,
      child: Card(
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
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                                style: Theme.of(context).textTheme.bodySmall
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
                            granted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 20,
                            color: granted ? Colors.green : Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            granted ? 'Granted' : 'Tap to grant',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: granted ? Colors.green : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
