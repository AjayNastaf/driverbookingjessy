package com.example.jessy_cabs

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.jessy_cabs/background"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "startService") {
                    val serviceIntent = Intent(this, MyBackgroundService::class.java)
                    startForegroundService(serviceIntent)
                    result.success("Service started")
                } else {
                    result.notImplemented()
                }
            }
    }
}
