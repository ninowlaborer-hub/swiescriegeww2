import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/database.dart';
import 'core/error/crash_reporter.dart';
import 'core/error/error_boundary.dart';
import 'core/platform/storage_bridge.dart';
import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/encryption_service.dart';
import 'screens/routine_startup_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting (logs errors locally on-device)
  final crashReporter = CrashReporter();
  crashReporter.initialize();

  // Initialize local encrypted database (offline-first, no backend)
  // Per FR-029: All data stored in encrypted local SQLite database
  final storageBridge = StorageBridge();
  final encryptionService = EncryptionService(storageBridge);

  // Get or generate database encryption key from secure storage
  // Key is stored in iOS Keychain or Android KeyStore (FR-030)
  final encryptionKey = await encryptionService.getDatabaseEncryptionKey();

  // Initialize database with encryption key (SQLCipher AES-256)
  final database = AppDatabase(encryptionKey: encryptionKey);

  runApp(
    ProviderScope(
      overrides: [
        // Provide database instance to entire app
        databaseProvider.overrideWithValue(database),
        encryptionServiceProvider.overrideWithValue(encryptionService),
        storageBridgeProvider.overrideWithValue(storageBridge),
      ],
      child: RootErrorBoundary(
        crashReporter: crashReporter,
        child: const RoutineStartupHandler(
          childApp: SwissciergeApp(),
        ),
      ),
    ),
  );
}

class SwissciergeApp extends ConsumerWidget {
  const SwissciergeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Swisscierge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
