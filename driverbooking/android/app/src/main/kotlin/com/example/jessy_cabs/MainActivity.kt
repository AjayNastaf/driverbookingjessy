//package com.example.jessy_cabs
//
//import android.content.Intent
//import android.os.Bundle
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "com.example.jessy_cabs/background"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                if (call.method == "startService") {
//                    val serviceIntent = Intent(this, MyBackgroundService::class.java)
//                    startForegroundService(serviceIntent)
//                    result.success("Service started")
//                } else {
//                    result.notImplemented()
//                }
//            }
//    }
//}



//working1


package com.example.jessy_cabs

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.content.Context
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        askIgnoreBatteryOptimization()
    }

    private fun askIgnoreBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val packageName = packageName
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                val intent = Intent()
                intent.action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                intent.data = Uri.parse("package:$packageName")
                startActivity(intent)
            }
        }
    }
}











