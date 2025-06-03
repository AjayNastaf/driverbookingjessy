


//working1
//
//
//package com.example.jessy_cabs
//
//import android.content.Intent
//import android.os.Build
//import android.os.Bundle
//import android.os.PowerManager
//import android.content.Context
//import android.net.Uri
//import android.provider.Settings
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
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
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        askIgnoreBatteryOptimization()
//    }
//
//    private fun askIgnoreBatteryOptimization() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            val packageName = packageName
//            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
//            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
//                val intent = Intent()
//                intent.action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
//                intent.data = Uri.parse("package:$packageName")
//                startActivity(intent)
//            }
//        }
//    }
//}






//working 2 recent
//
//package com.example.jessy_cabs
//
//import android.Manifest
//import android.content.Context
//import android.content.Intent
//import android.net.Uri
//import android.os.Build
//import android.os.Bundle
//import android.provider.Settings
//import android.widget.Toast
//import androidx.core.app.ActivityCompat
//import androidx.lifecycle.Lifecycle
//import androidx.lifecycle.LifecycleEventObserver
//import androidx.lifecycle.ProcessLifecycleOwner
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.embedding.engine.FlutterEngineCache
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity(), LifecycleEventObserver {
//
//    private val CHANNEL = "com.example.jessy_cabs/background"
//    private val OVERLAY_PERMISSION_REQ_CODE = 1234
//    private var pendingStartFloatingIcon = false
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "startBackgroundService" -> {
//                    startLocationService(this)
//                    result.success("Background service started")
//                }
//                "stopBackgroundService" -> {
//                    stopLocationService(this)
//                    result.success("Background service stopped")
//                }
//                "startFloatingIcon" -> {
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//                        pendingStartFloatingIcon = true
//                        requestOverlayPermission()
//                        result.success("Requested overlay permission")
//                    } else {
//                        startFloatingService(this)
//                        result.success("Floating icon started")
//                    }
//                }
//                "stopFloatingIcon" -> {
//                    stopFloatingService(this)
//                    result.success("Floating icon stopped")
//                }
//                else -> result.notImplemented()
//            }
//        }
//    }
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        requestPermissionsIfNeeded()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//            requestOverlayPermission()
//        }
//
//        // Observe lifecycle for foreground/background detection
//        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        ProcessLifecycleOwner.get().lifecycle.removeObserver(this)
//    }
//
//    override fun onStateChanged(source: androidx.lifecycle.LifecycleOwner, event: Lifecycle.Event) {
//        when (event) {
//            Lifecycle.Event.ON_STOP -> {
//                // App moved to background
//                if (Settings.canDrawOverlays(this)) {
//                    startFloatingService(this)
//                }
//            }
//            Lifecycle.Event.ON_START -> {
//                // App moved to foreground
//                stopFloatingService(this)
//            }
//            else -> {}
//        }
//    }
//
//    private fun requestPermissionsIfNeeded() {
//        val permissions = mutableListOf(
//            Manifest.permission.ACCESS_FINE_LOCATION,
//            Manifest.permission.ACCESS_COARSE_LOCATION,
//            Manifest.permission.FOREGROUND_SERVICE
//        )
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//            permissions.add(Manifest.permission.FOREGROUND_SERVICE_LOCATION)
//            permissions.add(Manifest.permission.POST_NOTIFICATIONS)
//        }
//
//        ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 1001)
//    }
//
//    private fun requestOverlayPermission() {
//        if (!Settings.canDrawOverlays(this)) {
//            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
//            startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
//        }
//    }
//
//    private fun startLocationService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    private fun stopLocationService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        context.stopService(intent)
//    }
//
//    private fun startFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    private fun stopFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        context.stopService(intent)
//    }
//
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
//            if (Settings.canDrawOverlays(this)) {
//                Toast.makeText(this, "Overlay permission granted", Toast.LENGTH_SHORT).show()
//                if (pendingStartFloatingIcon) {
//                    startFloatingService(this)
//                    pendingStartFloatingIcon = false
//                }
//            } else {
//                Toast.makeText(this, "Overlay permission is required to show floating icon", Toast.LENGTH_LONG).show()
//            }
//        }
//    }
//}


























//
//
//package com.example.jessy_cabs
//
//import android.content.Context
//import android.content.Intent
//import android.os.Build
//import android.os.Bundle
//import androidx.lifecycle.Lifecycle
//import androidx.lifecycle.LifecycleEventObserver
//import androidx.lifecycle.LifecycleOwner
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
//    private val CHANNEL = "com.example.jessy_cabs/background"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "startService" -> {
//                    startBackgroundService(this)
//                    result.success("Background service started")
//                }
//                "stopService" -> {
//                    stopBackgroundService(this)
//                    result.success("Background service stopped")
//                }
//                else -> result.notImplemented()
//            }
//        }
//
//        lifecycle.addObserver(object : LifecycleEventObserver {
//            override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
//                when (event) {
//                    Lifecycle.Event.ON_STOP -> startFloatingService(this@MainActivity)
//                    Lifecycle.Event.ON_START -> stopFloatingService(this@MainActivity)
//                    else -> {}
//                }
//            }
//        })
//    }
//
//    private fun startBackgroundService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    private fun stopBackgroundService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        context.stopService(intent)
//    }
//
//    private fun startFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    private fun stopFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        context.stopService(intent)
//    }
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        // Flag to pass to Dart
//        if (intent?.getBooleanExtra("fromFloatingIcon", false) == true) {
//            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, "com.example.jessy_cabs/navigation")
//                .invokeMethod("fromFloatingIcon", true)
//        }
//    }
//}























//
//
//

package com.example.jessy_cabs

import android.Manifest
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.ProcessLifecycleOwner
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity(), LifecycleEventObserver {

    private val CHANNEL = "com.example.jessy_cabs/background"
    private val OVERLAY_PERMISSION_REQ_CODE = 1234
    private var pendingStartFloatingIcon = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)

//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "startBackgroundService" -> {
//                    startLocationService(this)
//                    result.success("Background service started")
//                }
//                "stopBackgroundService" -> {
//                    stopLocationService(this)
//                    result.success("Background service stopped")
//                }
//                "startFloatingIcon" -> {
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//                        pendingStartFloatingIcon = true
//                        requestOverlayPermission()
//                        result.success("Requested overlay permission")
//                    } else {
//                        startFloatingService(this)
//                        result.success("Floating icon started")
//                    }
//                }
//                "stopFloatingIcon" -> {
//                    stopFloatingService(this)
//                    result.success("Floating icon stopped")
//                }
//                else -> result.notImplemented()
//            }
//        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {


                    "startBackgroundService" -> {
                        startLocationService(this)
                        result.success("Background service started")
                    }

                    "stopBackgroundService" -> {
                        stopLocationService(this)
                        result.success("Background service stopped")
                    }

                    "startFloatingIcon" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(
                                this
                            )
                        ) {
                            pendingStartFloatingIcon = true
                            requestOverlayPermission()
                            result.success("Requested overlay permission")
                        } else {
                            startFloatingService(this)
                            result.success("Floating icon started")
                        }
                    }

                    "stopFloatingIcon" -> {
                        stopFloatingService(this)
                        result.success("Floating icon stopped")
                    }

                    "startTrackingForCurrentPage" -> {
                        MyBackgroundService.isTrackingEnabled = true
                        result.success("Tracking started")
                    }

                    "stopTrackingForCurrentPage" -> {
                        MyBackgroundService.isTrackingEnabled = false
                        result.success("Tracking stopped")
                    }

                    // ✅ NEW CASE HERE:
                    "setTrackingMetadata" -> {
                        val args = call.arguments as Map<*, *>
                        MyBackgroundService.tripId = args["tripId"] as? String ?: ""
                        MyBackgroundService.vehicleNumber = args["vehicleNumber"] as? String ?: ""
                        Log.i(
                            "MainActivity",
                            "✅ Received metadata from Dart: tripId=${MyBackgroundService.tripId}, vehicle=${MyBackgroundService.vehicleNumber}"
                        )
                        result.success("Metadata set")
                    }

                    else -> result.notImplemented()
                }
            }




//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.jessy_cabs/tracking")
//
//            .setMethodCallHandler { call, result ->
//
//                if (call.method == "getSavedDistance") {
//
//                    val prefs = getSharedPreferences("tracking_prefs", Context.MODE_PRIVATE)
//
//                    val savedDistance = prefs.getFloat("total_distance_m", 0f)
//
//                    result.success(savedDistance.toDouble())
//
//                } else {
//
//                    result.notImplemented()
//
//                }
//
//            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.jessy_cabs/tracking")
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "getSavedDistance" -> {
                        val prefs = getSharedPreferences("tracking_prefs", Context.MODE_PRIVATE)
                        val savedDistance = prefs.getFloat("total_distance_m", 0f)
                        result.success(savedDistance.toDouble())
                    }

                    "clearSavedDistance" -> {
                        val prefs = getSharedPreferences("tracking_prefs", Context.MODE_PRIVATE)
                        prefs.edit().putFloat("total_distance_m", 0f).apply()
                        result.success("Distance cleared")
                    }

                    else -> result.notImplemented()
                }
            }



    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestPermissionsIfNeeded()
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//            requestOverlayPermission()
//        }
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }



    override fun onDestroy() {
        super.onDestroy()
        ProcessLifecycleOwner.get().lifecycle.removeObserver(this)
    }

    override fun onStateChanged(source: androidx.lifecycle.LifecycleOwner, event: Lifecycle.Event) {
        when (event) {
            Lifecycle.Event.ON_STOP -> {
                if (Settings.canDrawOverlays(this)) {
                    startFloatingService(this)
                }
            }
            Lifecycle.Event.ON_START -> {
                stopFloatingService(this)
            }
            else -> {}
        }
    }

    private fun requestPermissionsIfNeeded() {
        val permissions = mutableListOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.FOREGROUND_SERVICE
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permissions.add(Manifest.permission.FOREGROUND_SERVICE_LOCATION)
            permissions.add(Manifest.permission.POST_NOTIFICATIONS)
        }
        ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 1001)
    }

    private fun requestOverlayPermission() {
        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
        startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
    }

    private fun startLocationService(context: Context) {
        val intent = Intent(context, MyBackgroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }
    }

    private fun stopLocationService(context: Context) {
        val intent = Intent(context, MyBackgroundService::class.java)
        context.stopService(intent)
    }

    private fun startFloatingService(context: Context) {
        val intent = Intent(context, FloatingService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }
    }

    private fun stopFloatingService(context: Context) {
        val intent = Intent(context, FloatingService::class.java)
        context.stopService(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (Settings.canDrawOverlays(this)) {
                Toast.makeText(this, "Overlay permission granted", Toast.LENGTH_SHORT).show()
                if (pendingStartFloatingIcon) {
                    startFloatingService(this)
                    pendingStartFloatingIcon = false
                }
            } else {
                Toast.makeText(this, "Overlay permission is required to show floating icon", Toast.LENGTH_LONG).show()
            }
        }
    }
}


//
//
//package com.example.jessy_cabs
//
//import android.Manifest
//import android.content.Context
//import android.content.Intent
//import android.net.Uri
//import android.os.Build
//import android.os.Bundle
//import android.provider.Settings
//import android.widget.Toast
//import androidx.core.app.ActivityCompat
//import androidx.lifecycle.Lifecycle
//import androidx.lifecycle.LifecycleEventObserver
//import androidx.lifecycle.ProcessLifecycleOwner
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.embedding.engine.FlutterEngineCache
//import io.flutter.plugin.common.MethodChannel
//import android.util.Log
//
//class MainActivity : FlutterActivity(), LifecycleEventObserver {
//
//    private val CHANNEL = "com.example.jessy_cabs/background"
//    private val OVERLAY_PERMISSION_REQ_CODE = 1234
//    private var pendingStartFloatingIcon = false
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                when (call.method) {
//                    "startBackgroundService" -> {
//                        startLocationService(this)
//                        result.success("Background service started")
//                    }
//                    "stopBackgroundService" -> {
//                        stopLocationService(this)
//                        result.success("Background service stopped")
//                    }
//                    "startFloatingIcon" -> {
//                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//                            pendingStartFloatingIcon = true
//                            requestOverlayPermission()
//                            result.success("Requested overlay permission")
//                        } else {
//                            startFloatingService(this)
//                            result.success("Floating icon started")
//                        }
//                    }
//                    "stopFloatingIcon" -> {
//                        stopFloatingService(this)
//                        result.success("Floating icon stopped")
//                    }
//
//                    "startTrackingForCurrentPage" -> {
//                        MyBackgroundService.isTrackingEnabled = true
//                        result.success("Tracking started")
//                    }
//
//                    "stopTrackingForCurrentPage" -> {
//                        MyBackgroundService.isTrackingEnabled = false
//                        result.success("Tracking stopped")
//                    }
//
//                    "setTrackingMetadata" -> {
//                        val args = call.arguments as Map<*, *>
//                        MyBackgroundService.tripId = args["tripId"] as? String ?: ""
//                        MyBackgroundService.vehicleNumber = args["vehicleNumber"] as? String ?: ""
//                        Log.i("MainActivity", "✅ Received metadata from Dart: tripId=${MyBackgroundService.tripId}, vehicle=${MyBackgroundService.vehicleNumber}")
//                        result.success("Metadata set")
//                    }
//
//                    else -> result.notImplemented()
//                }
//            }
//
//        // *** NEW CHANNEL for getSavedDistance ***
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.jessy_cabs/tracking")
//            .setMethodCallHandler { call, result ->
//                if (call.method == "getSavedDistance") {
//                    val prefs = getSharedPreferences("tracking_prefs", Context.MODE_PRIVATE)
//                    val savedDistance = prefs.getFloat("total_distance_m", 0f)
//                    result.success(savedDistance.toDouble())
//                } else {
//                    result.notImplemented()
//                }
//            }
//    }
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        requestPermissionsIfNeeded()
//        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        ProcessLifecycleOwner.get().lifecycle.removeObserver(this)
//    }
//
//    override fun onStateChanged(source: androidx.lifecycle.LifecycleOwner, event: Lifecycle.Event) {
//        when (event) {
//            Lifecycle.Event.ON_STOP -> {
//                if (Settings.canDrawOverlays(this)) {
//                    startFloatingService(this)
//                }
//            }
//            Lifecycle.Event.ON_START -> {
//                stopFloatingService(this)
//            }
//            else -> {}
//        }
//    }
//
//    private fun requestPermissionsIfNeeded() {
//        val permissions = mutableListOf(
//            Manifest.permission.ACCESS_FINE_LOCATION,
//            Manifest.permission.ACCESS_COARSE_LOCATION,
//            Manifest.permission.FOREGROUND_SERVICE
//        )
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//            permissions.add(Manifest.permission.FOREGROUND_SERVICE_LOCATION)
//            permissions.add(Manifest.permission.POST_NOTIFICATIONS)
//        }
//        ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 1001)
//    }
//
//    private fun requestOverlayPermission() {
//        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
//        startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
//    }
//
//    private fun startLocationService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    private fun stopLocationService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        context.stopService(intent)
//    }
//
//    private fun startFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    private fun stopFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        context.stopService(intent)
//    }
//
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
//            if (Settings.canDrawOverlays(this)) {
//                Toast.makeText(this, "Overlay permission granted", Toast.LENGTH_SHORT).show()
//                if (pendingStartFloatingIcon) {
//                    startFloatingService(this)
//                    pendingStartFloatingIcon = false
//                }
//            } else {
//                Toast.makeText(this, "Overlay permission is required to show floating icon", Toast.LENGTH_LONG).show()
//            }
//        }
//    }
//}
