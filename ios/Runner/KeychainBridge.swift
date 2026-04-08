import Flutter
import Security

/// Native iOS implementation of secure storage using Keychain
///
/// Provides secure key-value storage using iOS Keychain Services.
/// All values are stored with kSecAttrAccessibleAfterFirstUnlock
/// for security while allowing background access.
class KeychainBridge {

    /// Service name for all keychain items (groups items together)
    private static let serviceName = "com.swisscierge.secure"

    /// Register the method channel handler with the Flutter engine
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.swisscierge/storage",
            binaryMessenger: registrar.messenger()
        )

        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "setSecureValue":
                handleSetSecureValue(call: call, result: result)
            case "getSecureValue":
                handleGetSecureValue(call: call, result: result)
            case "deleteSecureValue":
                handleDeleteSecureValue(call: call, result: result)
            case "hasSecureValue":
                handleHasSecureValue(call: call, result: result)
            case "clearAll":
                handleClearAll(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Method Handlers

    private static func handleSetSecureValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String,
              let value = args["value"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or invalid arguments",
                details: nil
            ))
            return
        }

        do {
            try setKeychainValue(key: key, value: value)
            result(nil)
        } catch {
            result(FlutterError(
                code: "KEYCHAIN_ERROR",
                message: "Failed to store value: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    private static func handleGetSecureValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or invalid key",
                details: nil
            ))
            return
        }

        do {
            let value = try getKeychainValue(key: key)
            result(value)
        } catch KeychainError.itemNotFound {
            result(nil) // Key doesn't exist
        } catch {
            result(FlutterError(
                code: "KEYCHAIN_ERROR",
                message: "Failed to retrieve value: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    private static func handleDeleteSecureValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or invalid key",
                details: nil
            ))
            return
        }

        do {
            try deleteKeychainValue(key: key)
            result(nil)
        } catch {
            result(FlutterError(
                code: "KEYCHAIN_ERROR",
                message: "Failed to delete value: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    private static func handleHasSecureValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or invalid key",
                details: nil
            ))
            return
        }

        let exists = hasKeychainValue(key: key)
        result(exists)
    }

    private static func handleClearAll(result: @escaping FlutterResult) {
        do {
            try clearAllKeychainValues()
            result(nil)
        } catch {
            result(FlutterError(
                code: "KEYCHAIN_ERROR",
                message: "Failed to clear values: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    // MARK: - Keychain Operations

    private static func setKeychainValue(key: String, value: String) throws {
        guard let valueData = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        // First, try to delete any existing item
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // Add the new item
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.operationFailed(status)
        }
    }

    private static func getKeychainValue(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == errSecSuccess else {
            throw KeychainError.operationFailed(status)
        }

        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }

        return value
    }

    private static func deleteKeychainValue(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.operationFailed(status)
        }
    }

    private static func hasKeychainValue(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private static func clearAllKeychainValues() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.operationFailed(status)
        }
    }
}

// MARK: - Error Types

enum KeychainError: Error {
    case itemNotFound
    case invalidData
    case operationFailed(OSStatus)
}

extension KeychainError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found in keychain"
        case .invalidData:
            return "Invalid data format"
        case .operationFailed(let status):
            return "Keychain operation failed with status: \(status)"
        }
    }
}
