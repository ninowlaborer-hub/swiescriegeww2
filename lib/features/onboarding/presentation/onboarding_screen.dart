import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/onboarding_service.dart';
import 'onboarding_providers.dart';
import 'welcome_screen.dart';
import 'permissions_screen.dart';
import 'preferences_setup_screen.dart';
import '../../routines/presentation/routine_providers.dart';
import '../../routines/presentation/widgets/ai_generation_loading.dart';
import '../../routines/presentation/widgets/ai_consent_dialog.dart';

/// Main onboarding screen coordinator
///
/// Manages the onboarding flow through multiple screens:
/// 1. Welcome screen (privacy-first architecture explanation)
/// 2. Permissions screen (calendar, location, health, analytics)
/// 3. Preferences setup screen (work hours, quiet hours, activities)
/// 4. Completion screen (with first routine generation)
///
/// Tracks progress and allows navigation between steps.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStepAsync = ref.watch(currentOnboardingStepProvider);

    return currentStepAsync.when(
      data: (step) {
        // If onboarding is complete, navigate to home
        if (step == OnboardingStep.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.go('/');
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            children: [
              // Step 1: Welcome
              WelcomeScreen(
                onComplete: () => _nextPage(),
              ),

              // Step 2: Permissions
              PermissionsScreen(
                onComplete: () => _nextPage(),
              ),

              // Step 3: Preferences
              PreferencesSetupScreen(
                onComplete: () => _nextPage(),
              ),

              // Step 4: Completion with routine generation
              _CompletionScreen(
                onComplete: () => _completeOnboarding(),
              ),
            ],
          ),
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
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading onboarding: \$error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(currentOnboardingStepProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    await completeOnboardingAction(ref);
    if (mounted) {
      context.go('/');
    }
  }
}

/// Completion screen (Step 4) with first routine generation
class _CompletionScreen extends ConsumerStatefulWidget {
  const _CompletionScreen({
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  ConsumerState<_CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends ConsumerState<_CompletionScreen> {
  bool _isGeneratingRoutine = false;
  bool _routineGenerated = false;

  @override
  void initState() {
    super.initState();
    // Show consent dialog before generating routine
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAIConsentDialog();
    });
  }

  Future<void> _showAIConsentDialog() async {
    final consent = await showAIConsentDialog(context);

    if (consent) {
      _generateFirstRoutine();
    } else {
      // User declined, skip routine generation
      if (mounted) {
        setState(() {
          _routineGenerated = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can generate routines later from the home screen'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _generateFirstRoutine() async {
    if (_isGeneratingRoutine || _routineGenerated) return;

    setState(() {
      _isGeneratingRoutine = true;
    });

    try {
      // Generate routine for today
      final today = DateTime.now();
      await ref.read(routineServiceProvider).generateRoutine(date: today);

      // Invalidate the provider to refresh UI
      ref.invalidate(routineForDateProvider(today));

      if (mounted) {
        setState(() {
          _isGeneratingRoutine = false;
          _routineGenerated = true;
        });
      }
    } catch (e) {
      debugPrint('Error generating first routine: \$e');
      if (mounted) {
        setState(() {
          _isGeneratingRoutine = false;
          // Even if generation fails, allow user to continue
          _routineGenerated = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note: Initial routine generation had an issue. You can generate it manually from the home screen.'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while generating routine
    if (_isGeneratingRoutine) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: 0.75, // Step 3.5 of 4 (generating routine)
                  backgroundColor: Colors.grey[200],
                ),

                const Spacer(),

                // AI Generation Loading Widget
                const AIGenerationLoading(isRegenerating: false),

                const Spacer(),

                Text(
                  'Setting up your first routine...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }

    // Show completion screen after routine is generated
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: 1.0, // Complete
                backgroundColor: Colors.grey[200],
              ),

              const Spacer(),

              // Success icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'All Set!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

              Text(
                'Your first routine is ready!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // What's next
              _buildNextStep(
                context,
                icon: Icons.calendar_today,
                title: 'View Your Routine',
                description:
                    'Check out your personalized daily routine on the home screen',
              ),

              const SizedBox(height: 16),

              _buildNextStep(
                context,
                icon: Icons.edit,
                title: 'Customize Time Blocks',
                description:
                    'Edit, snooze, or rearrange activities to fit your day',
              ),

              const SizedBox(height: 16),

              _buildNextStep(
                context,
                icon: Icons.auto_awesome,
                title: 'Regenerate Anytime',
                description:
                    'Tap the magic button to create a fresh routine whenever you need',
              ),

              const Spacer(),

              // Get started button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onComplete,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Start Using Swisscierge'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
