import 'package:flutter/services.dart';

/// Platform bridge for secure storage
///
/// Provides secure key-value storage using platform-specific mechanisms:
/// - iOS: Keychain (see ios/Runner/KeychainBridge.swift)
/// - Android: KeyStore (see android/app/src/main/kotlin/KeyStoreBridge.kt)
///
/// Used for storing sensitive data like encryption keys per FR-030.
class StorageBridge {
  /// Method channel for platform communication
  static const MethodChannel _channel = MethodChannel('com.swisscierge/storage');

  /// Store a secure value in platform secure storage
  ///
  /// - iOS: Stores in Keychain with kSecAttrAccessibleAfterFirstUnlock
  /// - Android: Stores in EncryptedSharedPreferences backed by KeyStore
  Future<void> setSecureValue(String key, String value) async {
    try {
      await _channel.invokeMethod('setSecureValue', {
        'key': key,
        'value': value,
      });
    } on PlatformException catch (e) {
      throw StorageBridgeException(
        'Failed to store secure value: ${e.message}',
      );
    }
  }

  /// Retrieve a secure value from platform secure storage
  ///
  /// Returns null if the key doesn't exist.
  Future<String?> getSecureValue(String key) async {
    try {
      final result = await _channel.invokeMethod<String>('getSecureValue', {
        'key': key,
      });
      return result;
    } on PlatformException catch (e) {
      throw StorageBridgeException(
        'Failed to retrieve secure value: ${e.message}',
      );
    }
  }

  /// Delete a secure value from platform secure storage
  Future<void> deleteSecureValue(String key) async {
    try {
      await _channel.invokeMethod('deleteSecureValue', {
        'key': key,
      });
    } on PlatformException catch (e) {
      throw StorageBridgeException(
        'Failed to delete secure value: ${e.message}',
      );
    }
  }

  /// Check if a key exists in platform secure storage
  Future<bool> hasSecureValue(String key) async {
    try {
      final result = await _channel.invokeMethod<bool>('hasSecureValue', {
        'key': key,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw StorageBridgeException(
        'Failed to check secure value existence: ${e.message}',
      );
    }
  }

  /// Clear all secure values (use with caution!)
  Future<void> clearAllSecureValues() async {
    try {
      await _channel.invokeMethod('clearAll');
    } on PlatformException catch (e) {
      throw StorageBridgeException(
        'Failed to clear all secure values: ${e.message}',
      );
    }
  }
}

/// Exception thrown when storage bridge operations fail
class StorageBridgeException implements Exception {
  StorageBridgeException(this.message);

  final String message;

  @override
  String toString() => 'StorageBridgeException: $message';
}
