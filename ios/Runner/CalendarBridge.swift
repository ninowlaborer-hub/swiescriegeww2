import Flutter
import EventKit

/// Native iOS implementation of calendar access using EventKit
///
/// Provides access to device calendars with user permission.
/// All calendar data stays on device - no external syncing.
class CalendarBridge {

    private let eventStore = EKEventStore()

    /// Register the method channel handler with the Flutter engine
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.swisscierge/calendar",
            binaryMessenger: registrar.messenger()
        )

        let instance = CalendarBridge()

        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "requestPermissions":
                instance.requestPermissions(result: result)
            case "hasPermissions":
                instance.hasPermissions(result: result)
            case "getCalendarSources":
                instance.getCalendarSources(result: result)
            case "getEvents":
                instance.getEvents(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Permission Methods

    private func requestPermissions(result: @escaping FlutterResult) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        result(FlutterError(
                            code: "PERMISSION_ERROR",
                            message: "Failed to request calendar permissions: \(error.localizedDescription)",
                            details: nil
                        ))
                    } else {
                        result(granted)
                    }
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        result(FlutterError(
                            code: "PERMISSION_ERROR",
                            message: "Failed to request calendar permissions: \(error.localizedDescription)",
                            details: nil
                        ))
                    } else {
                        result(granted)
                    }
                }
            }
        }
    }

    private func hasPermissions(result: @escaping FlutterResult) {
        let status = EKEventStore.authorizationStatus(for: .event)

        if #available(iOS 17.0, *) {
            result(status == .authorized || status == .fullAccess)
        } else {
            result(status == .authorized)
        }
    }

    // MARK: - Calendar Sources

    private func getCalendarSources(result: @escaping FlutterResult) {
        let calendars = eventStore.calendars(for: .event)

        let calendarData = calendars.map { calendar -> [String: Any] in
            return [
                "id": calendar.calendarIdentifier,
                "name": calendar.title,
                "account_name": calendar.source.title,
                "account_type": sourceTypeToString(calendar.source.sourceType),
                "color": colorToInt(calendar.cgColor),
                "is_primary": calendar.source.sourceType == .local,
                "is_read_only": !calendar.allowsContentModifications,
                "source_type": sourceTypeToString(calendar.source.sourceType),
                "metadata": [
                    "allows_modifications": calendar.allowsContentModifications,
                    "subscribed": calendar.isSubscribed,
                    "immutable": calendar.isImmutable
                ]
            ]
        }

        result(calendarData)
    }

    // MARK: - Events

    private func getEvents(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let calendarIds = args["calendar_ids"] as? [String],
              let startDateStr = args["start_date"] as? String,
              let endDateStr = args["end_date"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or invalid arguments",
                details: nil
            ))
            return
        }

        guard let startDate = ISO8601DateFormatter().date(from: startDateStr),
              let endDate = ISO8601DateFormatter().date(from: endDateStr) else {
            result(FlutterError(
                code: "INVALID_DATE",
                message: "Invalid date format",
                details: nil
            ))
            return
        }

        // Get calendars by IDs
        let allCalendars = eventStore.calendars(for: .event)
        let selectedCalendars = allCalendars.filter { calendarIds.contains($0.calendarIdentifier) }

        if selectedCalendars.isEmpty {
            result([])
            return
        }

        // Create predicate for date range
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: selectedCalendars
        )

        // Fetch events
        let events = eventStore.events(matching: predicate)

        let eventData = events.map { event -> [String: Any] in
            return [
                "id": event.eventIdentifier ?? "",
                "calendar_id": event.calendar?.calendarIdentifier ?? "",
                "title": event.title ?? "",
                "notes": event.notes ?? "",
                "location": event.location ?? "",
                "start_time": ISO8601DateFormatter().string(from: event.startDate),
                "end_time": ISO8601DateFormatter().string(from: event.endDate),
                "is_all_day": event.isAllDay,
                "status": eventStatusToString(event.status),
                "availability": availabilityToString(event.availability),
                "url": event.url?.absoluteString ?? "",
                "has_alarms": !(event.alarms?.isEmpty ?? true),
                "has_recurrence": event.hasRecurrenceRules,
                "metadata": [
                    "organizer": event.organizer?.name ?? "",
                    "attendee_count": event.attendees?.count ?? 0,
                    "calendar_name": event.calendar?.title ?? ""
                ]
            ]
        }

        result(eventData)
    }

    // MARK: - Helper Methods

    private func sourceTypeToString(_ sourceType: EKSourceType) -> String {
        switch sourceType {
        case .local:
            return "local"
        case .exchange:
            return "exchange"
        case .calDAV:
            return "caldav"
        case .mobileMe:
            return "mobileme"
        case .subscribed:
            return "subscribed"
        case .birthdays:
            return "birthdays"
        @unknown default:
            return "unknown"
        }
    }

    private func eventStatusToString(_ status: EKEventStatus) -> String {
        switch status {
        case .none:
            return "none"
        case .confirmed:
            return "confirmed"
        case .tentative:
            return "tentative"
        case .canceled:
            return "canceled"
        @unknown default:
            return "unknown"
        }
    }

    private func availabilityToString(_ availability: EKEventAvailability) -> String {
        switch availability {
        case .notSupported:
            return "not_supported"
        case .busy:
            return "busy"
        case .free:
            return "free"
        case .tentative:
            return "tentative"
        case .unavailable:
            return "unavailable"
        @unknown default:
            return "unknown"
        }
    }

    private func colorToInt(_ cgColor: CGColor) -> Int {
        guard let components = cgColor.components, components.count >= 3 else {
            return 0xFF2196F3 // Default blue
        }

        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        let alpha = components.count >= 4 ? Int(components[3] * 255) : 255

        return (alpha << 24) | (red << 16) | (green << 8) | blue
    }
}
