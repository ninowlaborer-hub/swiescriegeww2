import 'package:flutter/services.dart';

/// Platform channel interface for cloud storage
///
/// Provides unified interface for:
/// - iOS: iCloud Drive
/// - Android: Google Drive
///
/// Note: This is a simplified interface. Production apps would need
/// proper OAuth flow for Google Drive.
class CloudStorageBridge {
  static const MethodChannel _channel =
      MethodChannel('com.swisscierge/cloud_storage');

  /// Check if cloud storage is available on this platform
  ///
  /// Returns true if:
  /// - iOS: User is signed into iCloud
  /// - Android: Google Play Services available
  Future<bool> isCloudStorageAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } on PlatformException catch (e) {
      throw CloudStorageException(
        'Failed to check cloud storage availability: ${e.message}',
      );
    }
  }

  /// Upload file to cloud storage
  ///
  /// [localFilePath]: Path to local file to upload
  /// [cloudFileName]: Desired filename in cloud storage
  ///
  /// Returns the cloud file identifier/path
  Future<String> uploadFile({
    required String localFilePath,
    required String cloudFileName,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'uploadFile',
        {
          'localFilePath': localFilePath,
          'cloudFileName': cloudFileName,
        },
      );

      if (result == null) {
        throw CloudStorageException('Upload returned null result');
      }

      return result;
    } on PlatformException catch (e) {
      if (e.code == 'NOT_SIGNED_IN') {
        throw CloudStorageException(
          'Not signed in to cloud storage. Please sign in and try again.',
        );
      } else if (e.code == 'QUOTA_EXCEEDED') {
        throw CloudStorageException(
          'Cloud storage quota exceeded. Free up space and try again.',
        );
      } else if (e.code == 'NETWORK_ERROR') {
        throw CloudStorageException(
          'Network error during upload. Check your internet connection.',
        );
      }
      throw CloudStorageException('Upload failed: ${e.message}');
    }
  }

  /// Download file from cloud storage
  ///
  /// [cloudFileId]: Cloud file identifier (from uploadFile)
  /// [localFilePath]: Where to save the downloaded file
  ///
  /// Returns true if download successful
  Future<bool> downloadFile({
    required String cloudFileId,
    required String localFilePath,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'downloadFile',
        {
          'cloudFileId': cloudFileId,
          'localFilePath': localFilePath,
        },
      );

      return result ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'FILE_NOT_FOUND') {
        throw CloudStorageException(
          'File not found in cloud storage. It may have been deleted.',
        );
      } else if (e.code == 'NETWORK_ERROR') {
        throw CloudStorageException(
          'Network error during download. Check your internet connection.',
        );
      }
      throw CloudStorageException('Download failed: ${e.message}');
    }
  }

  /// List files in cloud storage
  ///
  /// Returns list of cloud file identifiers
  Future<List<String>> listFiles() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('listFiles');

      if (result == null) {
        return [];
      }

      return result.map((e) => e.toString()).toList();
    } on PlatformException catch (e) {
      throw CloudStorageException('Failed to list files: ${e.message}');
    }
  }

  /// Delete file from cloud storage
  ///
  /// [cloudFileId]: Cloud file identifier to delete
  Future<bool> deleteFile(String cloudFileId) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'deleteFile',
        {'cloudFileId': cloudFileId},
      );

      return result ?? false;
    } on PlatformException catch (e) {
      throw CloudStorageException('Failed to delete file: ${e.message}');
    }
  }

  /// Get file metadata
  ///
  /// Returns map with:
  /// - size: File size in bytes
  /// - modified: Last modified timestamp (ISO 8601)
  /// - name: File name
  Future<Map<String, dynamic>?> getFileMetadata(String cloudFileId) async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getFileMetadata',
        {'cloudFileId': cloudFileId},
      );

      if (result == null) {
        return null;
      }

      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw CloudStorageException('Failed to get file metadata: ${e.message}');
    }
  }

  /// Get current cloud storage quota
  ///
  /// Returns map with:
  /// - total: Total storage in bytes
  /// - used: Used storage in bytes
  /// - available: Available storage in bytes
  Future<Map<String, int>?> getStorageQuota() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getStorageQuota',
      );

      if (result == null) {
        return null;
      }

      return {
        'total': result['total'] as int? ?? 0,
        'used': result['used'] as int? ?? 0,
        'available': result['available'] as int? ?? 0,
      };
    } on PlatformException catch (e) {
      throw CloudStorageException('Failed to get storage quota: ${e.message}');
    }
  }
}

/// Exception thrown when cloud storage operations fail
class CloudStorageException implements Exception {
  CloudStorageException(this.message);

  final String message;

  @override
  String toString() => 'CloudStorageException: $message';
}
