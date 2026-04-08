// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claude_ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for Claude AI API key (user-provided, stored locally)

@ProviderFor(ClaudeApiKey)
const claudeApiKeyProvider = ClaudeApiKeyProvider._();

/// Provider for Claude AI API key (user-provided, stored locally)
final class ClaudeApiKeyProvider
    extends $AsyncNotifierProvider<ClaudeApiKey, String?> {
  /// Provider for Claude AI API key (user-provided, stored locally)
  const ClaudeApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claudeApiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claudeApiKeyHash();

  @$internal
  @override
  ClaudeApiKey create() => ClaudeApiKey();
}

String _$claudeApiKeyHash() => r'792778888b04b57c811351da2e8a1094378012df';

/// Provider for Claude AI API key (user-provided, stored locally)

abstract class _$ClaudeApiKey extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for Claude AI service instance

@ProviderFor(claudeAiService)
const claudeAiServiceProvider = ClaudeAiServiceProvider._();

/// Provider for Claude AI service instance

final class ClaudeAiServiceProvider
    extends
        $FunctionalProvider<
          ClaudeAIService?,
          ClaudeAIService?,
          ClaudeAIService?
        >
    with $Provider<ClaudeAIService?> {
  /// Provider for Claude AI service instance
  const ClaudeAiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claudeAiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claudeAiServiceHash();

  @$internal
  @override
  $ProviderElement<ClaudeAIService?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClaudeAIService? create(Ref ref) {
    return claudeAiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClaudeAIService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClaudeAIService?>(value),
    );
  }
}

String _$claudeAiServiceHash() => r'41faf2d91eb8c28f9bfd7bb7673b42d5edf72265';

/// Provider to check if Claude AI is enabled

@ProviderFor(isClaudeAiEnabled)
const isClaudeAiEnabledProvider = IsClaudeAiEnabledProvider._();

/// Provider to check if Claude AI is enabled

final class IsClaudeAiEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if Claude AI is enabled
  const IsClaudeAiEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isClaudeAiEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isClaudeAiEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isClaudeAiEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isClaudeAiEnabledHash() => r'5137fedc3e0281feb5897a63c74eeed5353a753d';

/// Provider for Claude-enhanced routine generation

@ProviderFor(ClaudeRoutineGenerator)
const claudeRoutineGeneratorProvider = ClaudeRoutineGeneratorProvider._();

/// Provider for Claude-enhanced routine generation
final class ClaudeRoutineGeneratorProvider
    extends
        $AsyncNotifierProvider<ClaudeRoutineGenerator, ClaudeRoutineResponse?> {
  /// Provider for Claude-enhanced routine generation
  const ClaudeRoutineGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claudeRoutineGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claudeRoutineGeneratorHash();

  @$internal
  @override
  ClaudeRoutineGenerator create() => ClaudeRoutineGenerator();
}

String _$claudeRoutineGeneratorHash() =>
    r'7e456443953af6545cd4c40e9a2df168b19197b8';

/// Provider for Claude-enhanced routine generation

abstract class _$ClaudeRoutineGenerator
    extends $AsyncNotifier<ClaudeRoutineResponse?> {
  FutureOr<ClaudeRoutineResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ClaudeRoutineResponse?>, ClaudeRoutineResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ClaudeRoutineResponse?>,
                ClaudeRoutineResponse?
              >,
              AsyncValue<ClaudeRoutineResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for Claude AI settings

@ProviderFor(ClaudeAiSettingsNotifier)
const claudeAiSettingsProvider = ClaudeAiSettingsNotifierProvider._();

/// Provider for Claude AI settings
final class ClaudeAiSettingsNotifierProvider
    extends $AsyncNotifierProvider<ClaudeAiSettingsNotifier, ClaudeAISettings> {
  /// Provider for Claude AI settings
  const ClaudeAiSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claudeAiSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claudeAiSettingsNotifierHash();

  @$internal
  @override
  ClaudeAiSettingsNotifier create() => ClaudeAiSettingsNotifier();
}

String _$claudeAiSettingsNotifierHash() =>
    r'da96636546f4f420447aaf07f954b49f781cce87';

/// Provider for Claude AI settings

abstract class _$ClaudeAiSettingsNotifier
    extends $AsyncNotifier<ClaudeAISettings> {
  FutureOr<ClaudeAISettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<ClaudeAISettings>, ClaudeAISettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ClaudeAISettings>, ClaudeAISettings>,
              AsyncValue<ClaudeAISettings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
