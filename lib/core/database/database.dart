import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'tables.dart';

part 'database.g.dart';

/// Swisscierge local database with SQLCipher encryption
///
/// All user data (routines, calendar cache, sleep records, preferences)
/// is stored in this encrypted local database. AES-256 encryption ensures
/// data privacy and GDPR/HIPAA compliance per FR-029, FR-030.
@DriftDatabase(
  tables: [Routines, TimeBlocks, CalendarCache, WeatherCache, UserPreferences],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({String? encryptionKey}) : super(_openConnection(encryptionKey));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future schema migrations will go here
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  // Cleanup routines older than 90 days (FR-036)
  Future<int> cleanupOldRoutines() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
    return (delete(
      routines,
    )..where((tbl) => tbl.createdAt.isSmallerThanValue(cutoffDate))).go();
  }

  // Get database size for monitoring (FR-036)
  Future<int> getDatabaseSizeBytes() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'swisscierge.db');
    final file = File(dbPath);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }
}

/// Opens encrypted database connection using SQLCipher
///
/// [encryptionKey] - Base64-encoded 256-bit encryption key from secure storage
/// Per FR-029: AES-256 encryption using SQLCipher
/// Per FR-030: Key stored in iOS Keychain / Android KeyStore
LazyDatabase _openConnection(String? encryptionKey) {
  return LazyDatabase(() async {
    // Initialize SQLCipher for the platform
    if (Platform.isAndroid) {
      // On Android, use SQLCipher from sqlcipher_flutter_libs
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    }

    // Get application documents directory for database storage
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'swisscierge.db'));

    // Load SQLCipher library
    if (Platform.isAndroid) {
      // Configure sqlite3 to use libsqlcipher.so instead of libsqlite3.so
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);

      // Ensure native SQLCipher library is loaded on Android
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    }
    // Note: iOS uses the system SQLCipher library automatically

    // Open database with encryption using SQLCipher
    final db = sqlite3.open(file.path);

    // Set SQLCipher encryption key (AES-256)
    // IMPORTANT: This MUST be the first operation after opening the database
    // SQLCipher requires PRAGMA key to be set before any other database operations
    if (encryptionKey != null && encryptionKey.isNotEmpty) {
      // Escape single quotes in the key for SQL safety
      final escapedKey = encryptionKey.replaceAll("'", "''");
      db.execute("PRAGMA key = '$escapedKey';");

      // Verify encryption is working by testing database access
      // If key is wrong, this will throw an error
      try {
        db.execute("SELECT count(*) FROM sqlite_master;");
      } catch (e) {
        // Database is encrypted but key is wrong, or database is corrupted
        throw DatabaseEncryptionException(
          'Failed to decrypt database. Key may be incorrect or database corrupted.',
        );
      }
    } else {
      // No encryption key provided - database will be unencrypted
      // This should only happen in development/testing scenarios
      // Production MUST always have an encryption key (FR-029)
      throw DatabaseEncryptionException(
        'Encryption key required for production database. Per FR-029, all local data must be encrypted.',
      );
    }

    return NativeDatabase.opened(db);
  });
}

/// Exception thrown when database encryption fails
class DatabaseEncryptionException implements Exception {
  DatabaseEncryptionException(this.message);

  final String message;

  @override
  String toString() => 'DatabaseEncryptionException: $message';
}
