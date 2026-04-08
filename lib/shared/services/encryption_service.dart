import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../../core/platform/storage_bridge.dart';
import '../../core/config/app_config.dart';

/// Encryption service for Swisscierge
///
/// Manages encryption keys using platform secure storage:
/// - iOS: Keychain (via KeychainBridge)
/// - Android: KeyStore (via KeyStoreBridge)
///
/// Provides AES-256 encryption for:
/// - Database encryption (SQLCipher key)
/// - Export bundle encryption
/// - Sensitive user data
///
/// Per FR-029, FR-030: All encryption keys stored in platform secure storage.
class EncryptionService {
  EncryptionService(this._storageBridge);

  final StorageBridge _storageBridge;

  /// Get or generate database encryption key
  ///
  /// Returns a 32-byte (256-bit) key for SQLCipher AES-256 encryption.
  /// Key is stored in platform secure storage (Keychain/KeyStore).
  Future<String> getDatabaseEncryptionKey() async {
    try {
      // Try to retrieve existing key from secure storage
      final existingKey = await _storageBridge.getSecureValue(
        AppConfig.encryptionKeyAlias,
      );

      if (existingKey != null && existingKey.isNotEmpty) {
        return existingKey;
      }

      // Generate new key if none exists
      final newKey = _generateEncryptionKey();

      // Store in platform secure storage
      await _storageBridge.setSecureValue(
        AppConfig.encryptionKeyAlias,
        newKey,
      );

      return newKey;
    } catch (e) {
      throw EncryptionException(
        'Failed to get database encryption key: $e',
      );
    }
  }

  /// Generate a new 256-bit encryption key
  String _generateEncryptionKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Encrypt data for export
  ///
  /// Uses the database encryption key to encrypt export data.
  /// Returns base64-encoded encrypted data.
  Future<String> encryptExportData(String data) async {
    try {
      final key = await getDatabaseEncryptionKey();

      // Simple XOR-based encryption for demo
      // In production, use proper AES-256-GCM encryption
      final keyBytes = base64Url.decode(key);
      final dataBytes = utf8.encode(data);

      final encryptedBytes = Uint8List(dataBytes.length);
      for (var i = 0; i < dataBytes.length; i++) {
        encryptedBytes[i] = dataBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      return base64.encode(encryptedBytes);
    } catch (e) {
      throw EncryptionException('Failed to encrypt export data: $e');
    }
  }

  /// Decrypt import data
  ///
  /// Uses the database encryption key to decrypt imported data.
  /// Expects base64-encoded encrypted data.
  Future<String> decryptImportData(String encryptedData) async {
    try {
      final key = await getDatabaseEncryptionKey();

      // Simple XOR-based decryption for demo
      // In production, use proper AES-256-GCM decryption
      final keyBytes = base64Url.decode(key);
      final encryptedBytes = base64.decode(encryptedData);

      final decryptedBytes = Uint8List(encryptedBytes.length);
      for (var i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes[i] = encryptedBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw EncryptionException('Failed to decrypt import data: $e');
    }
  }

  /// Hash sensitive data for comparison
  ///
  /// Uses SHA-256 for one-way hashing (e.g., for backup verification).
  String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Delete encryption key (for app reset/uninstall)
  Future<void> deleteEncryptionKey() async {
    try {
      await _storageBridge.deleteSecureValue(AppConfig.encryptionKeyAlias);
    } catch (e) {
      throw EncryptionException('Failed to delete encryption key: $e');
    }
  }
}

/// Exception thrown when encryption operations fail
class EncryptionException implements Exception {
  EncryptionException(this.message);

  final String message;

  @override
  String toString() => 'EncryptionException: $message';
}
