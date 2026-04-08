import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'claude_ai_service.dart';
import '../logging/logger.dart';

part 'claude_ai_provider.g.dart';

/// Provider for Claude AI API key (user-provided, stored locally)
@riverpod
class ClaudeApiKey extends _$ClaudeApiKey {
  static const String _keyName =
      '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';

  @override
  Future<String?> build() async {
    AppLogger.info('🔑 Loading Claude AI API key from SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_keyName);

    if (key != null) {
      AppLogger.info('✅ API key found: ${key.substring(0, 20)}...');
    } else {
      AppLogger.info(
        '⚠️ No API key found in SharedPreferences, checking hardcoded value',
      );
      AppLogger.info('🔑 Using hardcoded key: ${_keyName.substring(0, 20)}...');
      return _keyName; // Return the hardcoded key as fallback
    }

    return key;
  }

  /// Save the Claude API key locally (encrypted storage recommended)
  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, apiKey);
    ref.invalidateSelf();
  }

  /// Remove the API key
  Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    ref.invalidateSelf();
  }
}

/// Provider for Claude AI service instance
@riverpod
ClaudeAIService? claudeAiService(Ref ref) {
  AppLogger.info('🔧 Building Claude AI service provider');
  final apiKeyAsync = ref.watch(claudeApiKeyProvider);

  return apiKeyAsync.maybeWhen(
    data: (apiKey) {
      AppLogger.info('📊 API key state: data');
      if (apiKey == null || apiKey.isEmpty) {
        AppLogger.warning('⚠️ API key is null or empty - Claude AI disabled');
        return null; // No API key configured
      }
      AppLogger.info(
        '✅ Creating ClaudeAIService with key: ${apiKey.substring(0, 20)}...',
      );
      final service = ClaudeAIService(apiKey: apiKey);
      AppLogger.info('✨ ClaudeAIService created successfully');
      return service;
    },
    loading: () {
      AppLogger.info('⏳ API key loading...');
      return null;
    },
    error: (error, stack) {
      AppLogger.error('❌ Error loading API key', error: error);
      return null;
    },
    orElse: () {
      AppLogger.warning('⚠️ API key provider in unknown state');
      return null;
    },
  );
}

/// Provider to check if Claude AI is enabled
@riverpod
bool isClaudeAiEnabled(Ref ref) {
  final service = ref.watch(claudeAiServiceProvider);
  return service != null;
}

/// Provider for Claude-enhanced routine generation
@riverpod
class ClaudeRoutineGenerator extends _$ClaudeRoutineGenerator {
  @override
  FutureOr<ClaudeRoutineResponse?> build() async {
    return null; // Initial state
  }

  /// Generate routine using Claude AI (if available)
  Future<ClaudeRoutineResponse?> generateRoutine({
    required List<Map<String, dynamic>> calendarEvents,
    required Map<String, dynamic> weatherData,
    required Map<String, dynamic> userPreferences,
    List<Map<String, dynamic>>? historicalPatterns,
  }) async {
    final service = ref.read(claudeAiServiceProvider);

    if (service == null) {
      // No Claude AI configured, return null (fallback to on-device ML)
      return null;
    }

    state = const AsyncValue.loading();

    try {
      final response = await service.generateRoutine(
        calendarEvents: calendarEvents,
        weatherData: weatherData,
        userPreferences: userPreferences,
        historicalPatterns: historicalPatterns,
      );

      state = AsyncValue.data(response);
      return response;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      // On error, fallback to on-device ML by returning null
      return null;
    }
  }
}

/// Settings for Claude AI integration
class ClaudeAISettings {
  ClaudeAISettings({
    this.enabled = false,
    this.model = 'claude-3-5-haiku-20241022',
    this.maxTokens = 2048,
    this.enhanceRoutines = true,
    this.naturalLanguageParsing = true,
    this.personalizedSuggestions = true,
  });

  final bool enabled;
  final String model;
  final int maxTokens;
  final bool enhanceRoutines;
  final bool naturalLanguageParsing;
  final bool personalizedSuggestions;

  ClaudeAISettings copyWith({
    bool? enabled,
    String? model,
    int? maxTokens,
    bool? enhanceRoutines,
    bool? naturalLanguageParsing,
    bool? personalizedSuggestions,
  }) {
    return ClaudeAISettings(
      enabled: enabled ?? this.enabled,
      model: model ?? this.model,
      maxTokens: maxTokens ?? this.maxTokens,
      enhanceRoutines: enhanceRoutines ?? this.enhanceRoutines,
      naturalLanguageParsing:
          naturalLanguageParsing ?? this.naturalLanguageParsing,
      personalizedSuggestions:
          personalizedSuggestions ?? this.personalizedSuggestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'model': model,
      'maxTokens': maxTokens,
      'enhanceRoutines': enhanceRoutines,
      'naturalLanguageParsing': naturalLanguageParsing,
      'personalizedSuggestions': personalizedSuggestions,
    };
  }

  factory ClaudeAISettings.fromJson(Map<String, dynamic> json) {
    return ClaudeAISettings(
      enabled: json['enabled'] as bool? ?? false,
      model: json['model'] as String? ?? 'claude-3-5-haiku-20241022',
      maxTokens: json['maxTokens'] as int? ?? 2048,
      enhanceRoutines: json['enhanceRoutines'] as bool? ?? true,
      naturalLanguageParsing: json['naturalLanguageParsing'] as bool? ?? true,
      personalizedSuggestions: json['personalizedSuggestions'] as bool? ?? true,
    );
  }
}

/// Provider for Claude AI settings
@riverpod
class ClaudeAiSettingsNotifier extends _$ClaudeAiSettingsNotifier {
  static const String _settingsKey = 'claude_ai_settings';

  @override
  Future<ClaudeAISettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_settingsKey);

    if (json == null) {
      return ClaudeAISettings();
    }

    return ClaudeAISettings.fromJson(
      Map<String, dynamic>.from(Uri.parse('?$json').queryParameters),
    );
  }

  /// Update settings
  Future<void> updateSettings(ClaudeAISettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, settings.toJson().toString());
    ref.invalidateSelf();
  }
}
