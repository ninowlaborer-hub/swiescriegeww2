import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_explanation.freezed.dart';
part 'routine_explanation.g.dart';

/// Explanation for why a routine was generated this way
///
/// Provides transparency into AI decision-making per FR-006.
/// References specific data sources (calendar, weather, sleep) used.
@freezed
abstract class RoutineExplanation with _$RoutineExplanation {
  const factory RoutineExplanation({
    required String summary,
    required List<String> factors,
    Map<String, dynamic>? dataSourcesUsed,
    List<String>? recommendations,
    DateTime? generatedAt,
  }) = _RoutineExplanation;

  factory RoutineExplanation.fromJson(Map<String, dynamic> json) =>
      _$RoutineExplanationFromJson(json);
}

/// Extension methods for RoutineExplanation
extension RoutineExplanationX on RoutineExplanation {
  /// Get formatted explanation text
  String get formattedText {
    final buffer = StringBuffer();

    buffer.writeln(summary);
    buffer.writeln();

    if (factors.isNotEmpty) {
      buffer.writeln('Factors considered:');
      for (final factor in factors) {
        buffer.writeln('• $factor');
      }
      buffer.writeln();
    }

    if (recommendations != null && recommendations!.isNotEmpty) {
      buffer.writeln('Recommendations:');
      for (final recommendation in recommendations!) {
        buffer.writeln('• $recommendation');
      }
    }

    return buffer.toString().trim();
  }

  /// Check if calendar data was used
  bool get usedCalendarData {
    return dataSourcesUsed?.containsKey('calendar') ?? false;
  }

  /// Check if weather data was used
  bool get usedWeatherData {
    return dataSourcesUsed?.containsKey('weather') ?? false;
  }

  /// Check if sleep data was used
  bool get usedSleepData {
    return dataSourcesUsed?.containsKey('sleep') ?? false;
  }

  /// Get count of data sources used
  int get dataSourceCount {
    return dataSourcesUsed?.length ?? 0;
  }
}

/// Builder for creating routine explanations
class RoutineExplanationBuilder {
  String? _summary;
  final List<String> _factors = [];
  final Map<String, dynamic> _dataSources = {};
  final List<String> _recommendations = [];

  RoutineExplanationBuilder setSummary(String summary) {
    _summary = summary;
    return this;
  }

  RoutineExplanationBuilder addFactor(String factor) {
    _factors.add(factor);
    return this;
  }

  RoutineExplanationBuilder addDataSource(String source, dynamic data) {
    _dataSources[source] = data;
    return this;
  }

  RoutineExplanationBuilder addRecommendation(String recommendation) {
    _recommendations.add(recommendation);
    return this;
  }

  RoutineExplanation build() {
    return RoutineExplanation(
      summary: _summary ?? 'Routine generated based on your preferences and data.',
      factors: List.unmodifiable(_factors),
      dataSourcesUsed: Map.unmodifiable(_dataSources),
      recommendations: List.unmodifiable(_recommendations),
      generatedAt: DateTime.now(),
    );
  }
}
