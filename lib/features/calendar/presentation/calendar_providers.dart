import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/platform/calendar_bridge.dart';
import '../../../core/providers.dart';
import '../data/calendar_local_datasource.dart';
import '../data/calendar_repository.dart';
import '../domain/calendar_event.dart';
import '../domain/calendar_service.dart';
import '../domain/calendar_source.dart';

/// Riverpod providers for calendar feature

/// Calendar bridge provider
final calendarBridgeProvider =
    Provider<CalendarBridge>((ref) => CalendarBridge());

/// Calendar local datasource provider
final calendarLocalDatasourceProvider =
    Provider<CalendarLocalDatasource>((ref) {
  final database = ref.watch(databaseProvider);
  return CalendarLocalDatasource(database);
});

/// Calendar repository provider
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final datasource = ref.watch(calendarLocalDatasourceProvider);
  final bridge = ref.watch(calendarBridgeProvider);
  return CalendarRepository(
    localDatasource: datasource,
    calendarBridge: bridge,
  );
});

/// Calendar service provider
final calendarServiceProvider = Provider<CalendarService>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  return CalendarService(
    repository: repository,
    connectivityService: connectivityService,
  );
});

/// Calendar permissions provider
final calendarPermissionsProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.hasPermissions();
});

/// Calendar sources provider
final calendarSourcesProvider = FutureProvider<List<CalendarSource>>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getCalendarSources();
});

/// Selected calendar sources provider
final selectedCalendarSourcesProvider =
    FutureProvider<List<CalendarSource>>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getSelectedCalendarSources();
});

/// Today's calendar events provider
final todaysCalendarEventsProvider =
    FutureProvider<List<CalendarEvent>>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getTodaysEvents();
});

/// Upcoming calendar events provider (next 7 days)
final upcomingCalendarEventsProvider =
    FutureProvider<List<CalendarEvent>>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getUpcomingEvents(days: 7);
});

/// Active calendar event provider (happening now)
final activeCalendarEventProvider =
    FutureProvider<CalendarEvent?>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getActiveEvent();
});

/// Next calendar event provider
final nextCalendarEventProvider = FutureProvider<CalendarEvent?>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getNextEvent();
});

/// Calendar sync status provider
final calendarSyncStatusProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getSyncStatus();
});

/// Parameters for calendar events provider
class CalendarEventsParams {
  final DateTime startDate;
  final DateTime endDate;

  CalendarEventsParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventsParams &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}

/// Calendar events for date range provider
final calendarEventsProvider = FutureProvider.family<List<CalendarEvent>,
    CalendarEventsParams>((ref, params) async {
  final service = ref.watch(calendarServiceProvider);
  return service.getCalendarEvents(
    startDate: params.startDate,
    endDate: params.endDate,
  );
});

/// Calendar sync loading state
final calendarSyncLoadingProvider = NotifierProvider<_CalendarSyncLoadingNotifier, bool>(
  _CalendarSyncLoadingNotifier.new,
);

class _CalendarSyncLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}

/// Selected calendar IDs state (for selection UI)
final selectedCalendarIdsProvider = NotifierProvider<_SelectedCalendarIdsNotifier, Set<String>>(
  _SelectedCalendarIdsNotifier.new,
);

class _SelectedCalendarIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void setSelected(Set<String> ids) => state = ids;
  void toggleSelection(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }
}

/// Actions

/// Request calendar permissions action
Future<bool> requestCalendarPermissionsAction(WidgetRef ref) async {
  final service = ref.read(calendarServiceProvider);
  final granted = await service.requestPermissions();

  if (granted) {
    // Refresh permissions provider
    ref.invalidate(calendarPermissionsProvider);
  }

  return granted;
}

/// Sync calendar sources action
Future<List<CalendarSource>> syncCalendarSourcesAction(WidgetRef ref) async {
  final service = ref.read(calendarServiceProvider);
  final loadingNotifier = ref.read(calendarSyncLoadingProvider.notifier);

  loadingNotifier.setLoading(true);

  try {
    final sources = await service.syncCalendarSources();

    // Refresh providers
    ref
      ..invalidate(calendarSourcesProvider)
      ..invalidate(selectedCalendarSourcesProvider);

    return sources;
  } finally {
    loadingNotifier.setLoading(false);
  }
}

/// Update calendar selection action
Future<void> updateCalendarSelectionAction(
  WidgetRef ref,
  String calendarId, {
  required bool isSelected,
}) async {
  final service = ref.read(calendarServiceProvider);
  await service.updateCalendarSelection(calendarId, isSelected);

  // Refresh providers
  ref
    ..invalidate(calendarSourcesProvider)
    ..invalidate(selectedCalendarSourcesProvider)
    ..invalidate(todaysCalendarEventsProvider)
    ..invalidate(upcomingCalendarEventsProvider);
}

/// Select multiple calendars action
Future<void> selectCalendarsAction(
  WidgetRef ref,
  List<String> calendarIds,
) async {
  final service = ref.read(calendarServiceProvider);
  await service.selectCalendars(calendarIds);

  // Refresh providers
  ref
    ..invalidate(calendarSourcesProvider)
    ..invalidate(selectedCalendarSourcesProvider)
    ..invalidate(todaysCalendarEventsProvider)
    ..invalidate(upcomingCalendarEventsProvider);
}

/// Sync calendar events action
Future<List<CalendarEvent>> syncCalendarEventsAction(
  WidgetRef ref, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final service = ref.read(calendarServiceProvider);
  final loadingNotifier = ref.read(calendarSyncLoadingProvider.notifier);

  loadingNotifier.setLoading(true);

  try {
    final now = DateTime.now();
    final start = startDate ?? DateTime(now.year, now.month, now.day);
    final end = endDate ?? start.add(const Duration(days: 7));

    final events = await service.getCalendarEvents(
      startDate: start,
      endDate: end,
      forceSync: true,
    );

    // Refresh event providers
    ref
      ..invalidate(todaysCalendarEventsProvider)
      ..invalidate(upcomingCalendarEventsProvider)
      ..invalidate(activeCalendarEventProvider)
      ..invalidate(nextCalendarEventProvider);

    return events;
  } finally {
    loadingNotifier.setLoading(false);
  }
}

/// Create calendar event from time block action
Future<String> createCalendarEventFromTimeBlockAction(
  WidgetRef ref, {
  required String calendarId,
  required String title,
  required DateTime startTime,
  required DateTime endTime,
  String? description,
  String? location,
  bool isAllDay = false,
}) async {
  final service = ref.read(calendarServiceProvider);

  final eventId = await service.createEventFromTimeBlock(
    calendarId: calendarId,
    title: title,
    startTime: startTime,
    endTime: endTime,
    description: description,
    location: location,
    isAllDay: isAllDay,
  );

  // Refresh event providers
  ref
    ..invalidate(todaysCalendarEventsProvider)
    ..invalidate(upcomingCalendarEventsProvider);

  return eventId;
}

/// Update calendar event action
Future<void> updateCalendarEventAction(
  WidgetRef ref, {
  required String eventId,
  required String calendarId,
  required Map<String, dynamic> updates,
}) async {
  final service = ref.read(calendarServiceProvider);

  await service.updateCalendarEvent(
    eventId: eventId,
    calendarId: calendarId,
    updates: updates,
  );

  // Refresh event providers
  ref
    ..invalidate(todaysCalendarEventsProvider)
    ..invalidate(upcomingCalendarEventsProvider);
}

/// Delete calendar event action
Future<void> deleteCalendarEventAction(
  WidgetRef ref, {
  required String eventId,
  required String calendarId,
}) async {
  final service = ref.read(calendarServiceProvider);

  await service.deleteCalendarEvent(
    eventId: eventId,
    calendarId: calendarId,
  );

  // Refresh event providers
  ref
    ..invalidate(todaysCalendarEventsProvider)
    ..invalidate(upcomingCalendarEventsProvider);
}

/// Clear calendar cache action
Future<void> clearCalendarCacheAction(WidgetRef ref) async {
  final service = ref.read(calendarServiceProvider);
  await service.clearCache();

  // Refresh all providers
  ref
    ..invalidate(calendarSourcesProvider)
    ..invalidate(selectedCalendarSourcesProvider)
    ..invalidate(todaysCalendarEventsProvider)
    ..invalidate(upcomingCalendarEventsProvider)
    ..invalidate(calendarSyncStatusProvider);
}

/// Open calendar settings action
Future<void> openCalendarSettingsAction(WidgetRef ref) async {
  final service = ref.read(calendarServiceProvider);
  await service.openSettings();
}
