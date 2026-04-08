import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/providers.dart';
import '../../../core/ml/routine_generator.dart';
import '../../../core/ai/claude_ai_provider.dart';
import '../data/routine_local_datasource.dart';
import '../data/routine_repository.dart';
import '../domain/routine_service.dart';
import '../domain/routine.dart';
import '../../calendar/presentation/calendar_providers.dart';
import '../../weather/presentation/weather_providers.dart';

/// Riverpod providers for routine feature

/// Routine generator provider (ML model)
final routineGeneratorProvider = Provider<RoutineGenerator>((ref) {
  return RoutineGenerator();
});

/// Routine local datasource provider
final routineLocalDatasourceProvider = Provider<RoutineLocalDatasource>((ref) {
  final database = ref.watch(databaseProvider);
  return RoutineLocalDatasource(database);
});

/// Routine repository provider
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final datasource = ref.watch(routineLocalDatasourceProvider);
  return RoutineRepository(datasource);
});

/// Routine service provider
final routineServiceProvider = Provider<RoutineService>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  final mlGenerator = ref.watch(routineGeneratorProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  final claudeAiService = ref.watch(claudeAiServiceProvider);
  final calendarService = ref.watch(calendarServiceProvider);
  final weatherService = ref.watch(weatherServiceProvider);
  final locationService = ref.watch(locationServiceProvider);

  return RoutineService(
    repository: repository,
    mlGenerator: mlGenerator,
    connectivityService: connectivityService,
    claudeAiService: claudeAiService,
    calendarService: calendarService,
    weatherService: weatherService,
    locationService: locationService,
  );
});

/// Today's routine provider
final todaysRoutineProvider = FutureProvider<Routine>((ref) async {
  final service = ref.watch(routineServiceProvider);
  // TODO: Get user preferences from preferences provider
  return service.getTodaysRoutine();
});

/// Routine for specific date provider
final routineForDateProvider = FutureProvider.family<Routine?, DateTime>(
  (ref, date) async {
    final service = ref.watch(routineServiceProvider);
    try {
      final routine = await service.getRoutineForDate(date);
      return routine;
    } catch (e) {
      // Return null if no routine found for this date (not an error)
      return null;
    }
  },
);

/// Routine by ID provider
final routineByIdProvider = FutureProvider.family<Routine?, String>(
  (ref, routineId) async {
    final repository = ref.watch(routineRepositoryProvider);
    try {
      return await repository.getRoutineById(routineId);
    } catch (e) {
      return null;
    }
  },
);

/// Routine history provider
final routineHistoryProvider = FutureProvider.family<List<Routine>, int>(
  (ref, page) async {
    final service = ref.watch(routineServiceProvider);
    const pageSize = 30;
    return service.getRoutineHistory(
      limit: pageSize,
      offset: page * pageSize,
    );
  },
);

/// Current routine state provider (for editing)
final currentRoutineProvider = StateProvider<Routine?>((ref) => null);

/// Routine generation loading state
final routineGenerationLoadingProvider = StateProvider<bool>((ref) => false);

/// Routine statistics provider
final routineStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(routineServiceProvider);
  return service.getStatistics();
});

/// Actions

/// Generate new routine action
Future<Routine> generateRoutineAction(
  WidgetRef ref, {
  DateTime? date,
  bool forceRegenerate = false,
  Map<String, dynamic>? userPreferences,
}) async {
  final service = ref.read(routineServiceProvider);

  // Set loading state
  ref.read(routineGenerationLoadingProvider.notifier).state = true;

  try {
    final routine = date != null
        ? await service.generateRoutine(
            date: date,
            forceRegenerate: forceRegenerate,
            userPreferences: userPreferences,
          )
        : await service.generateTodaysRoutine(
            forceRegenerate: forceRegenerate,
            userPreferences: userPreferences,
          );

    // Refresh appropriate providers
    if (date != null) {
      ref.invalidate(routineForDateProvider(date));
    }
    ref.invalidate(todaysRoutineProvider);

    return routine;
  } finally {
    // Clear loading state
    ref.read(routineGenerationLoadingProvider.notifier).state = false;
  }
}

/// Accept routine action
Future<void> acceptRoutineAction(WidgetRef ref, String routineId) async {
  final service = ref.read(routineServiceProvider);
  final repository = ref.read(routineRepositoryProvider);

  // Get routine before accepting to access its date
  final routine = await repository.getRoutineById(routineId);

  if (routine == null) {
    throw Exception('Routine not found: $routineId');
  }

  // Accept the routine
  await service.acceptRoutine(routineId);

  // Normalize the date to ensure proper invalidation
  final normalizedDate = DateTime(routine.date.year, routine.date.month, routine.date.day);

  // Invalidate all relevant providers to force UI refresh
  ref.invalidate(todaysRoutineProvider);
  ref.invalidate(routineForDateProvider(normalizedDate));
  ref.invalidate(routineByIdProvider(routineId));
  ref.invalidate(routineHistoryProvider);
}

/// Delete routine action
Future<void> deleteRoutineAction(WidgetRef ref, String routineId) async {
  final repository = ref.read(routineRepositoryProvider);
  final routine = await repository.getRoutineById(routineId);
  
  await repository.deleteRoutine(routineId);

  // Refresh providers
  if (routine != null) {
    ref.invalidate(routineForDateProvider(routine.date));
  }
  ref.invalidate(todaysRoutineProvider);
  ref.invalidate(routineHistoryProvider);
}

/// Cleanup old routines action
Future<int> cleanupOldRoutinesAction(WidgetRef ref) async {
  final service = ref.read(routineServiceProvider);
  final count = await service.cleanupOldRoutines();

  // Refresh providers
  ref.invalidate(routineHistoryProvider);
  ref.invalidate(routineStatisticsProvider);

  return count;
}
