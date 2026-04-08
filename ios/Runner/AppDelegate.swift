import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register generated plugins
    GeneratedPluginRegistrant.register(with: self)

    // Register custom platform channels
    if let controller = window?.rootViewController as? FlutterViewController {
      KeychainBridge.register(with: registrar(forPlugin: "KeychainBridge")!)
      CalendarBridge.register(with: registrar(forPlugin: "CalendarBridge")!)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
