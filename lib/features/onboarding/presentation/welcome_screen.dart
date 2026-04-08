import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_providers.dart';
import '../../../core/ui/animations.dart';

/// Welcome screen explaining privacy-first architecture
///
/// First screen in onboarding flow. Introduces Swisscierge's core values:
/// - Privacy by design (local-only data)
/// - Offline-first architecture
/// - No proprietary backend servers
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({
    super.key,
    this.onComplete,
  });

  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const SizedBox(height: 40),

              // App icon or logo with scale animation
              SwissAnimations.scaleIn(
                duration: SwissAnimations.elegant,
                child: Center(
                  child: Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Welcome title with fade in
              SwissAnimations.fadeIn(
                duration: SwissAnimations.smooth,
                child: Center(
                  child: Text(
                    'Welcome to Swisscierge',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle with fade in
              SwissAnimations.fadeIn(
                duration: SwissAnimations.smooth,
                child: Center(
                  child: Text(
                    'Your privacy-first daily routine assistant',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Privacy features with staggered animation
              SwissAnimations.staggeredList(
                itemDelay: const Duration(milliseconds: 100),
                itemDuration: SwissAnimations.smooth,
                children: [
                  _buildFeatureItem(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Privacy by Design',
                    description:
                        'All your data stays on your device. Encrypted with AES-256.',
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    context,
                    icon: Icons.cloud_off_outlined,
                    title: 'Offline-First',
                    description:
                        'Works without internet. No proprietary backend servers.',
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    context,
                    icon: Icons.auto_awesome_outlined,
                    title: 'On-Device AI',
                    description:
                        'Personalized routines generated entirely on your device.',
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    context,
                    icon: Icons.open_in_new_outlined,
                    title: 'Open & Transparent',
                    description:
                        'Only connects to free public APIs you control (optional).',
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Get started button with slide in
              SwissAnimations.slideInFade(
                duration: SwissAnimations.smooth,
                begin: const Offset(0, 0.1),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await completeWelcomeAction(ref);
                      onComplete?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Privacy note with fade in
              SwissAnimations.fadeIn(
                duration: SwissAnimations.smooth,
                child: Center(
                  child: Text(
                    'By continuing, you agree that all data will be stored\nlocally on your device with encryption.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
                      ],
                    ),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
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
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
