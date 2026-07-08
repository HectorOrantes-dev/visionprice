package com.visionprice.vision_price

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val raspChannel = "com.visionprice.vision_price/rasp"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, raspChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Lectura autoritativa del sistema: 1 = Depuración USB activa.
                    "isUsbDebuggingEnabled" -> {
                        val enabled = Settings.Global.getInt(
                            contentResolver,
                            Settings.Global.ADB_ENABLED,
                            0
                        ) == 1
                        result.success(enabled)
                    }
                    "openDeveloperSettings" -> {
                        startActivity(Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS))
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
