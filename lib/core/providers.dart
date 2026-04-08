import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database/database.dart';
import 'platform/storage_bridge.dart';
import '../shared/services/encryption_service.dart';
import '../shared/services/connectivity_service.dart';
import 'error/crash_reporter.dart';
import 'accessibility/accessibility_service.dart';
import 'performance/performance_monitor.dart';

/// Base Riverpod providers for Swisscierge
///
/// Provides core services used throughout the app:
/// - Database (encrypted local storage)
/// - Storage Bridge (platform secure storage)
/// - Encryption Service (key management)
/// - Connectivity Service (offline detection)
/// - Crash Reporter (privacy-respecting error tracking)
/// - Accessibility Service (WCAG 2.1 AA compliance)
/// - Performance Monitor (tracks app performance metrics)

/// Database provider - single instance for entire app
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Storage bridge provider - platform secure storage
final storageBridgeProvider = Provider<StorageBridge>((ref) {
  return StorageBridge();
});

/// Encryption service provider
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  final storageBridge = ref.watch(storageBridgeProvider);
  return EncryptionService(storageBridge);
});

/// Connectivity service provider - monitors online/offline state
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Connectivity state stream provider
final connectivityStateProvider = StreamProvider<ConnectivityStatus>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectivityStream;
});

/// Is offline provider - convenience boolean for UI
final isOfflineProvider = Provider<bool>((ref) {
  final connectivityState = ref.watch(connectivityStateProvider);
  return connectivityState.when(
    data: (status) => status == ConnectivityStatus.offline,
    loading: () => false,
    error: (_, __) => true, // Assume offline on error
  );
});

/// Crash reporter provider - logs errors locally
final crashReporterProvider = Provider<CrashReporter>((ref) {
  return CrashReporter();
});

/// Accessibility service provider - WCAG 2.1 AA compliance
final accessibilityServiceProvider = Provider<AccessibilityService>((ref) {
  return AccessibilityService();
});

/// Performance monitor provider - tracks app performance metrics
final performanceMonitorProvider = Provider<PerformanceMonitor>((ref) {
  return PerformanceMonitor();
});
