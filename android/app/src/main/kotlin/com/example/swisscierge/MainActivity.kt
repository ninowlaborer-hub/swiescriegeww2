package com.example.swisscierge

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register KeyStore bridge for secure storage
        KeyStoreBridge.register(flutterEngine.dartExecutor.binaryMessenger, this)
    }
}
