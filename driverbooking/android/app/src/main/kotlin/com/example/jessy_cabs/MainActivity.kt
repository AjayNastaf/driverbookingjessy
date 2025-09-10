


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

















package com.example.jessy_cabs

import android.content.pm.PackageManager

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
import android.app.ActivityManager
import android.content.ComponentName

import android.app.AlertDialog

import android.os.PowerManager
import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity(), LifecycleEventObserver {

    private val CHANNEL = "com.example.jessy_cabs/background"
    private val OVERLAY_PERMISSION_REQ_CODE = 1234
    private var pendingStartFloatingIcon = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        requestPermissionsIfNeededlocation() // 👈 Call it here during app startup

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


//                    "startBackgroundService" -> {
//                        startLocationService(this)
//                        result.success("Background service started")
//                    }

                    in listOf("startBackgroundService", "startMyBackgroundService") -> {
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
                        )

                        {
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

                    "removeAllFloatingIcons" -> {

                        stopFloatingService(this)

                        MyBackgroundService.instance?.removeFloatingBubble()

                        result.success("All floating icons removed")

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

                    // ✅ NEW METHOD

                    "openLocationPermissionSettings" -> {
                        openLocationPermissionSettings()
                        result.success("Opened location settings")
                    }

                    "hasBackgroundLocationPermission" -> {
                        val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            ContextCompat.checkSelfPermission(
                                this,
                                Manifest.permission.ACCESS_BACKGROUND_LOCATION
                            ) == PackageManager.PERMISSION_GRANTED
                        } else {
                            // On Android 9 and below, ACCESS_FINE_LOCATION implies background
                            ContextCompat.checkSelfPermission(
                                this,
                                Manifest.permission.ACCESS_FINE_LOCATION
                            ) == PackageManager.PERMISSION_GRANTED
                        }
                        result.success(hasPermission)
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

                    "resetTrackingData" -> {
                        MyBackgroundService.instance?.resetTrackingData()
                        result.success("Tracking data reset on native side")
                    }


                    else -> result.notImplemented()
                }
            }







    }

    private fun requestPermissionsIfNeededlocation() {
        val permissions = mutableListOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.FOREGROUND_SERVICE
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permissions.add(Manifest.permission.FOREGROUND_SERVICE_LOCATION)
            permissions.add(Manifest.permission.POST_NOTIFICATIONS)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            permissions.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION)
        }

        ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 1001)
    }




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestPermissionsIfNeeded()
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//            requestOverlayPermission()
//        }

        askIgnoreBatteryOptimizationIfNeeded()

//        askIgnoreBatteryOptimization()
//        showManufacturerGuidance(this)


//        requestIgnoreBatteryOptimization()  // ✅ Automatically request battery optimization exclusion








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

//    private fun startLocationService(context: Context) {
//        val intent = Intent(context, MyBackgroundService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }

    private fun startLocationService(context: Context) {
        val intent = Intent(context, MyBackgroundService::class.java)
        ContextCompat.startForegroundService(context, intent)
    }


    private fun stopLocationService(context: Context) {
        val intent = Intent(context, MyBackgroundService::class.java)
        context.stopService(intent)
    }



    private fun isFloatingServiceRunning(context: Context): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (FloatingService::class.java.name == service.service.className) {
                return true
            }
        }
        return false
    }


    private fun startFloatingService(context: Context) {
        if (!isFloatingServiceRunning(context)) {
            val intent = Intent(context, FloatingService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
    }






//    private fun startFloatingService(context: Context) {
//        val intent = Intent(context, FloatingService::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }





    private fun requestIgnoreBatteryOptimization() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager

            if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {

                try {

                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {

                        data = Uri.parse("package:$packageName")

                    }

                    startActivity(intent)

                } catch (e: Exception) {

                    Log.e("BatteryOpt", "Error requesting battery optimization exclusion: ${e.message}")

                }

            } else {

                Log.i("BatteryOpt", "Battery optimization already ignored")

            }

        }

    }
//    private fun requestBatteryOptimization() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            val packageName = applicationContext.packageName
//            val pm = getSystemService(POWER_SERVICE) as PowerManager
//            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
//                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
//                    data = Uri.parse("package:$packageName")
//                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                }
//                startActivity(intent)
//            }
//        }
//    }







    private fun openAppDetailsSettings(context: Context) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:${context.packageName}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(intent)
    }


    private fun askIgnoreBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val packageName = applicationContext.packageName
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager

            if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {
                try {
                    val intent = Intent(this, BatteryOptActivity::class.java)
                    startActivity(intent)
                    Log.i("BatteryOpt", "Launched BatteryOptActivity")
                } catch (e: Exception) {
                    Log.e("BatteryOpt", "Failed to launch BatteryOptActivity: ${e.message}")
                }
            } else {
                Log.i("BatteryOpt", "Already ignoring battery optimizations")
            }
        }
    }

    private fun showManufacturerGuidancet(context: Context) {
        val manufacturer = Build.MANUFACTURER.lowercase()

        if (manufacturer.contains("oppo") || manufacturer.contains("realme")) {
            AlertDialog.Builder(context)
                .setTitle("Enable Background Access")
                .setMessage(
                    "To keep Jessy Cabs running in background:\n\n" +
                            "1. Go to App Settings > Battery Usage\n" +
                            "2. Enable 'Auto-start' and 'Allow Background Activity'\n\n" +
                            "Click OK to open settings."
                )
                .setPositiveButton("OKkk") { _, _ ->
                    openAppDetailsSettings(context)
                }
                .setNegativeButton("Cancel", null)
                .show()
        }
    }

    private fun showManufacturerGuidance(context: Context) {
        val manufacturer = Build.MANUFACTURER.lowercase()

        if (manufacturer.contains("oppo") || manufacturer.contains("realme")) {
            AlertDialog.Builder(context)
                .setTitle("Enable Background Access")
                .setMessage(
                    "To keep Jessy Cabs running in background:\n\n" +
                            "1. Go to App Settings > Battery Usage\n" +
                            "2. Enable 'Auto-start' and 'Allow Background Activity'\n\n" +
                            "Click OK to open settings."
                )
                .setPositiveButton("OK") { _, _ ->
                    openAppDetailsSettings(context)
                }
                .setNegativeButton("Cancel", null)
                .show()
        }
    }


    private fun askIgnoreBatteryOptimizationIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val packageName = applicationContext.packageName
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager

            if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {
                // ✅ Only show dialog + launch setting if not already granted
                showManufacturerGuidance(this)

                // Optional: Also trigger system dialog directly
                try {
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                        data = Uri.parse("package:$packageName")
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    startActivity(intent)
                } catch (e: Exception) {
                    Log.e("BatteryOpt", "Error requesting battery optimization: ${e.message}")
                }

            } else {
                Log.i("BatteryOpt", "Already ignoring battery optimizations")
            }
        }
    }














    private fun openLocationPermissionSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
        }
        startActivity(intent)
    }





    private fun stopFloatingService(context: Context) {
        val intent = Intent(context, FloatingService::class.java)
        context.stopService(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (Settings.canDrawOverlays(this)) {
//                Toast.makeText(this, "Overlay permission granted", Toast.LENGTH_SHORT).show()
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
