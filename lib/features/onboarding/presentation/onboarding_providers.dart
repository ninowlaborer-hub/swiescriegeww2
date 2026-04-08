import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/onboarding_service.dart';

/// Onboarding service provider
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

/// Onboarding completion status provider
final onboardingCompleteProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return await service.isOnboardingComplete();
});

/// Current onboarding step provider
final currentOnboardingStepProvider =
    FutureProvider.autoDispose<OnboardingStep>((ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return await service.getCurrentStep();
});

/// Current step number (for progress indicator)
final onboardingProgressProvider = FutureProvider.autoDispose<double>((ref) async {
  final step = await ref.watch(currentOnboardingStepProvider.future);
  return step.stepNumber / step.totalSteps;
});

/// User preferences during onboarding
class OnboardingPreferencesNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {
      'work_window_start': '09:00',
      'work_window_end': '17:00',
      'quiet_hours_start': '22:00',
      'quiet_hours_end': '07:00',
      'activity_preferences': {
        'exercise': true,
        'social': true,
        'learning': false,
      },
    };
  }

  void updatePreferences(Map<String, dynamic> preferences) {
    state = {...state, ...preferences};
  }
}

final onboardingPreferencesProvider =
    NotifierProvider<OnboardingPreferencesNotifier, Map<String, dynamic>>(
  OnboardingPreferencesNotifier.new,
);

/// Permission states during onboarding
class OnboardingPermissionsNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    return {
      'calendar': false,
      'location': false,
      'health': false,
      'analytics': false,
    };
  }

  void updatePermission(String key, bool value) {
    state = {...state, key: value};
  }
}

final onboardingPermissionsProvider =
    NotifierProvider<OnboardingPermissionsNotifier, Map<String, bool>>(
  OnboardingPermissionsNotifier.new,
);

/// Actions

/// Mark welcome as seen and move to next step
Future<void> completeWelcomeAction(WidgetRef ref) async {
  final service = ref.read(onboardingServiceProvider);
  await service.markWelcomeSeen();
  ref.invalidate(currentOnboardingStepProvider);
}

/// Mark permissions as configured and move to next step
Future<void> completePermissionsAction(WidgetRef ref) async {
  final service = ref.read(onboardingServiceProvider);
  await service.markPermissionsConfigured();
  ref.invalidate(currentOnboardingStepProvider);
}

/// Save preferences and mark as configured
Future<void> completePreferencesAction(
  WidgetRef ref,
  Map<String, dynamic> preferences,
) async {
  final service = ref.read(onboardingServiceProvider);

  // Save to user preferences
  // TODO: Implement saving to database user_preferences table

  await service.markPreferencesConfigured();
  ref.invalidate(currentOnboardingStepProvider);
}

/// Complete onboarding flow
Future<void> completeOnboardingAction(WidgetRef ref) async {
  final service = ref.read(onboardingServiceProvider);
  await service.completeOnboarding();
  ref.invalidate(onboardingCompleteProvider);
  ref.invalidate(currentOnboardingStepProvider);
}

/// Reset onboarding (for testing)
Future<void> resetOnboardingAction(WidgetRef ref) async {
  final service = ref.read(onboardingServiceProvider);
  await service.resetOnboarding();
  ref.invalidate(onboardingCompleteProvider);
  ref.invalidate(currentOnboardingStepProvider);
}
