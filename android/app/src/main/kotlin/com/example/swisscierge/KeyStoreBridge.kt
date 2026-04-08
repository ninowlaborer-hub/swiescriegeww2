package com.example.swisscierge

import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger

/**
 * Native Android implementation of secure storage using EncryptedSharedPreferences
 *
 * Provides secure key-value storage backed by Android KeyStore.
 * All values are encrypted using AES256_GCM and keys are encrypted using RSA.
 */
class KeyStoreBridge(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "com.swisscierge/storage"
        private const val PREFS_NAME = "com.swisscierge.secure"

        /**
         * Register the method channel handler with the Flutter engine
         */
        fun register(messenger: BinaryMessenger, context: Context) {
            val channel = MethodChannel(messenger, CHANNEL_NAME)
            val bridge = KeyStoreBridge(context)
            channel.setMethodCallHandler(bridge)
        }
    }

    private val masterKey: MasterKey by lazy {
        MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()
    }

    private val encryptedPrefs by lazy {
        EncryptedSharedPreferences.create(
            context,
            PREFS_NAME,
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setSecureValue" -> handleSetSecureValue(call, result)
            "getSecureValue" -> handleGetSecureValue(call, result)
            "deleteSecureValue" -> handleDeleteSecureValue(call, result)
            "hasSecureValue" -> handleHasSecureValue(call, result)
            "clearAll" -> handleClearAll(result)
            else -> result.notImplemented()
        }
    }

    private fun handleSetSecureValue(call: MethodCall, result: MethodChannel.Result) {
        try {
            val key = call.argument<String>("key")
            val value = call.argument<String>("value")

            if (key == null || value == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Missing or invalid arguments",
                    null
                )
                return
            }

            encryptedPrefs.edit().putString(key, value).apply()
            result.success(null)
        } catch (e: Exception) {
            result.error(
                "KEYSTORE_ERROR",
                "Failed to store value: ${e.message}",
                null
            )
        }
    }

    private fun handleGetSecureValue(call: MethodCall, result: MethodChannel.Result) {
        try {
            val key = call.argument<String>("key")

            if (key == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Missing or invalid key",
                    null
                )
                return
            }

            val value = encryptedPrefs.getString(key, null)
            result.success(value)
        } catch (e: Exception) {
            result.error(
                "KEYSTORE_ERROR",
                "Failed to retrieve value: ${e.message}",
                null
            )
        }
    }

    private fun handleDeleteSecureValue(call: MethodCall, result: MethodChannel.Result) {
        try {
            val key = call.argument<String>("key")

            if (key == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Missing or invalid key",
                    null
                )
                return
            }

            encryptedPrefs.edit().remove(key).apply()
            result.success(null)
        } catch (e: Exception) {
            result.error(
                "KEYSTORE_ERROR",
                "Failed to delete value: ${e.message}",
                null
            )
        }
    }

    private fun handleHasSecureValue(call: MethodCall, result: MethodChannel.Result) {
        try {
            val key = call.argument<String>("key")

            if (key == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Missing or invalid key",
                    null
                )
                return
            }

            val exists = encryptedPrefs.contains(key)
            result.success(exists)
        } catch (e: Exception) {
            result.error(
                "KEYSTORE_ERROR",
                "Failed to check value existence: ${e.message}",
                null
            )
        }
    }

    private fun handleClearAll(result: MethodChannel.Result) {
        try {
            encryptedPrefs.edit().clear().apply()
            result.success(null)
        } catch (e: Exception) {
            result.error(
                "KEYSTORE_ERROR",
                "Failed to clear values: ${e.message}",
                null
            )
        }
    }
}
