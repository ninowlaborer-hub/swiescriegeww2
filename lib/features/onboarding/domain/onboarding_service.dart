import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding flow coordinator
///
/// Manages the first-time user experience, tracking completion status
/// and coordinating transitions between onboarding screens.
class OnboardingService {
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _welcomeSeenKey = 'welcome_seen';
  static const _permissionsConfiguredKey = 'permissions_configured';
  static const _preferencesConfiguredKey = 'preferences_configured';

  /// Check if user has completed onboarding
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Check if welcome screen has been seen
  Future<bool> isWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_welcomeSeenKey) ?? false;
  }

  /// Check if permissions have been configured
  Future<bool> arePermissionsConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionsConfiguredKey) ?? false;
  }

  /// Check if preferences have been configured
  Future<bool> arePreferencesConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_preferencesConfiguredKey) ?? false;
  }

  /// Mark welcome screen as seen
  Future<void> markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_welcomeSeenKey, true);
  }

  /// Mark permissions as configured
  Future<void> markPermissionsConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionsConfiguredKey, true);
  }

  /// Mark preferences as configured
  Future<void> markPreferencesConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_preferencesConfiguredKey, true);
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Reset onboarding (for testing/debugging)
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompleteKey);
    await prefs.remove(_welcomeSeenKey);
    await prefs.remove(_permissionsConfiguredKey);
    await prefs.remove(_preferencesConfiguredKey);
  }

  /// Get current onboarding step
  ///
  /// Returns the next incomplete step in the onboarding flow.
  Future<OnboardingStep> getCurrentStep() async {
    if (!await isWelcomeSeen()) {
      return OnboardingStep.welcome;
    }
    if (!await arePermissionsConfigured()) {
      return OnboardingStep.permissions;
    }
    if (!await arePreferencesConfigured()) {
      return OnboardingStep.preferences;
    }
    if (!await isOnboardingComplete()) {
      return OnboardingStep.complete;
    }
    return OnboardingStep.done;
  }
}

/// Onboarding flow steps
enum OnboardingStep {
  /// Welcome screen explaining privacy-first architecture
  welcome,

  /// Permission request screen (calendar, location, health, analytics)
  permissions,

  /// User preferences setup (work hours, quiet hours, activity preferences)
  preferences,

  /// Final completion step
  complete,

  /// Onboarding is done
  done,
}

extension OnboardingStepExtension on OnboardingStep {
  String get title {
    switch (this) {
      case OnboardingStep.welcome:
        return 'Welcome to Swisscierge';
      case OnboardingStep.permissions:
        return 'App Permissions';
      case OnboardingStep.preferences:
        return 'Your Preferences';
      case OnboardingStep.complete:
        return 'All Set!';
      case OnboardingStep.done:
        return 'Done';
    }
  }

  String get description {
    switch (this) {
      case OnboardingStep.welcome:
        return 'Your privacy-first daily routine assistant';
      case OnboardingStep.permissions:
        return 'Grant permissions to personalize your routines';
      case OnboardingStep.preferences:
        return 'Set up your daily schedule preferences';
      case OnboardingStep.complete:
        return 'You\'re ready to start using Swisscierge!';
      case OnboardingStep.done:
        return '';
    }
  }

  int get stepNumber {
    switch (this) {
      case OnboardingStep.welcome:
        return 1;
      case OnboardingStep.permissions:
        return 2;
      case OnboardingStep.preferences:
        return 3;
      case OnboardingStep.complete:
        return 4;
      case OnboardingStep.done:
        return 4;
    }
  }

  int get totalSteps => 4;
}
