//// ✅ FINAL PRODUCTION BACKGROUND SERVICE WITH ACTUAL API CALL
//// Sends location to API using vehicleNumber, tripId, and tripStatus like in Customerlocationreached.dart

//
//package com.example.jessy_cabs
//
//import android.app.*
//import android.content.Context
//import android.content.Intent
//import android.graphics.PixelFormat
//import android.os.*
//import android.provider.Settings
//import android.util.Log
//import android.view.*
//import androidx.core.app.NotificationCompat
//import com.google.android.gms.location.FusedLocationProviderClient
//import com.google.android.gms.location.LocationServices
//import org.json.JSONObject
//import java.io.BufferedWriter
//import java.io.OutputStreamWriter
//import java.net.HttpURLConnection
//import java.net.URL
//import java.util.Timer
//import java.util.TimerTask
//import java.text.SimpleDateFormat
//import java.util.Date
//import java.util.Locale
//import android.location.Location
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.embedding.engine.FlutterEngineCache
//import io.flutter.embedding.engine.dart.DartExecutor
//import java.util.concurrent.Executors
////import io.flutter.view.FlutterMain
//import io.flutter.FlutterInjector
//import android.widget.Toast
//
//
//
//
//class MyBackgroundService : Service() {
//    private val CHANNEL_ID = "location_channel"
//    private lateinit var fusedLocationClient: FusedLocationProviderClient
//    private lateinit var windowManager: WindowManager
//    private lateinit var floatingView: View
//    private var locationTimer: Timer? = null
//    private var backgroundTimer: Timer? = null
//    private lateinit var channel: MethodChannel
//    private val CHANNEL_NAME = "com.example.jessy_cabs/tracking"
//    private var isBubbleAdded = false
//    private var previousLocation: Location? = null
//    private var totalDistance: Double = 0.0
//    private val locationExecutor = Executors.newSingleThreadExecutor()
//
//    companion object {
//        var isTrackingEnabled: Boolean = false
//        var tripId: String = ""         // Set from Dart via MethodChannel if needed
//        var vehicleNumber: String = ""  // Set from Dart if required
//        var tripStatus: String = "On_Going"  // Default value
//
//        var instance: MyBackgroundService? = null
//
//    }
//
//    // Track distance
//
//    private var lastLat = 0.0
//
//    private var lastLng = 0.0
//
//    private var totalDistanceInMeters = 0.0
//
//    private val PREFS_NAME = "tracking_prefs"
//    private val DISTANCE_KEY = "total_distance_m"
//
//    private lateinit var locationRequest: com.google.android.gms.location.LocationRequest
//    private lateinit var locationCallback: com.google.android.gms.location.LocationCallback
//
//
//    override fun onCreate() {
//        super.onCreate()
//        instance = this  // ✅ Add this line
//
//        Log.d("MyBackgroundService", "Service created")
//        Log.i("MyBackgroundService", "🔥 onCreate called")
//
//        createNotificationChannel()
//        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
////        val engine = FlutterEngine(this)
////        engine.dartExecutor.executeDartEntrypoint(
////            DartExecutor.DartEntrypoint.createDefault()
////        )
////        FlutterEngineCache.getInstance().put("tracking_engine", engine)
////
////        channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//        val flutterEngine = FlutterEngine(this)
//
//        val appBundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath()
//        FlutterInjector.instance().flutterLoader().startInitialization(this)
//        FlutterInjector.instance().flutterLoader().ensureInitializationComplete(this, null)
//
//        flutterEngine.dartExecutor.executeDartEntrypoint(
//            DartExecutor.DartEntrypoint(appBundlePath, "trackingMain") // 👈 your entrypoint in Dart
//        )
//
//        FlutterEngineCache.getInstance().put("tracking_engine", flutterEngine)
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
//        totalDistanceInMeters = prefs.getFloat(DISTANCE_KEY, 0f).toDouble()
//        Log.i("MyBackgroundService", "🔁 Restored total distance from prefs: $totalDistanceInMeters meters")
//
//        val engine = FlutterEngineCache.getInstance()["my_engine_id"]
//        if (engine != null) {
//            channel = MethodChannel(engine.dartExecutor.binaryMessenger, "com.example.jessy_cabs/background")
//            Log.i("MyBackgroundService", "✅ Channel successfully created with cached engine")
//        } else {
//            Log.e("MyBackgroundService", "❌ FlutterEngine 'my_engine_id' not found in cache")
//        }
//
//
//
//        showPersistentNotification()
//        startLocationLoop()
//    }
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        Log.d("MyBackgroundService", "Service started")
//        startForeground(1, createNotification())
//
//        // Handle Dart requests
////        MethodChannel(FlutterEngineCache.getInstance()["tracking_engine"]!!.dartExecutor.binaryMessenger, CHANNEL_NAME)
////            .setMethodCallHandler { call, result ->
////                when (call.method) {
////                    "getTotalDistance" -> {
////                        result.success(totalDistanceInMeters)
////                    }
////                    else -> result.notImplemented()
////                }
////            }
//
//
//        val engine = FlutterEngineCache.getInstance()["tracking_engine"]
//        if (engine != null) {
//            channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
//            channel.setMethodCallHandler { call, result ->
//                when (call.method) {
//                    "getTotalDistance" -> result.success(totalDistanceInMeters / 1000.0)
////                    "getTotalDistance" -> result.success(totalDistanceInMeters)
//                    else -> result.notImplemented()
//                }
//            }
//        } else {
//            Log.e("MyBackgroundService", "FlutterEngine 'tracking_engine' not found in cache")
//        }
//
//        return START_STICKY
//    }
//
////    private fun startLocationLoop() {
////        locationTimer = Timer()
////        locationTimer?.scheduleAtFixedRate(object : TimerTask() {
////            override fun run() {
////                if (!isTrackingEnabled) return
////
////                fusedLocationClient.lastLocation
////                    .addOnSuccessListener { location ->
////                        if (location != null) {
////                            Log.d("LocationLoop", "Lat=${location.latitude}, Lon=${location.longitude}")
////                            saveLocationToBackend(location.latitude, location.longitude)
////                        } else {
////                            Log.w("LocationLoop", "Location is null")
////                        }
////                    }
////                    .addOnFailureListener {
////                        Log.e("LocationLoop", "Failed to get location: ${it.localizedMessage}")
////                    }
////            }
////        }, 0, 2000)
////    }
//
//
//    private fun showPersistentNotification() {
//        val channelId = "tracking_channel"
//        val channelName = "Jessy Cabs Tracking"
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val chan = NotificationChannel(
//                channelId, channelName, NotificationManager.IMPORTANCE_LOW
//            )
//            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            manager.createNotificationChannel(chan)
//        }
//
//        val notification = NotificationCompat.Builder(this, channelId)
//            .setContentTitle("Jessy Cabs is running")
//            .setContentText("Tracking your trip in background.")
//            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
//            .setOngoing(true)
//            .build()
//
//        startForeground(1, notification)
//    }
//
//
//
//    private fun startLocationLoop() {
//        locationRequest = com.google.android.gms.location.LocationRequest.Builder(
//            com.google.android.gms.location.Priority.PRIORITY_HIGH_ACCURACY,
//            5000L // 5 seconds
//        )
//            .setMinUpdateIntervalMillis(5000L)
//            .setMinUpdateDistanceMeters(0f)
//            .build()
//
//        locationCallback = object : com.google.android.gms.location.LocationCallback() {
//            override fun onLocationResult(result: com.google.android.gms.location.LocationResult) {
//                val location = result.lastLocation
//                if (location != null && isTrackingEnabled) {
//                    Log.d("LocationLoop", "📍 Lat=${location.latitude}, Lon=${location.longitude}")
//                    saveLocationToBackend(location.latitude, location.longitude)
//                } else {
//                    Log.w("LocationLoop", "⚠️ Location null or tracking disabled")
//                }
//            }
//        }
//
//        fusedLocationClient.requestLocationUpdates(
//            locationRequest,
//            locationCallback,
//            Looper.getMainLooper()
//        )
//    }
//
//
//    private fun saveLocationToBackend(lat: Double, lon: Double) {
//            Log.i("BackgroundDebug", "📡saveLocationToBackend triggered with: lat=$lat, lon=$lon")
//        Log.d("BackgroundDebug", "🔍 Preparing to send location data:")
//        Log.d("BackgroundDebug", "latitude = $lat")
//        Log.d("BackgroundDebug", "longitude = $lon")
//        Log.d("BackgroundDebug", "vehicleNo = $vehicleNumber")
//        Log.d("BackgroundDebug", "tripId = $tripId")
//        Log.d("BackgroundDebug", "tripStatus = $tripStatus")
//
//        Toast.makeText(this, "tripId=${tripId},tripStatus=${tripStatus},vehicle=${vehicleNumber}", Toast.LENGTH_LONG).show()
//
//
//        var distance = 0.0
//        if (lastLat != 0.0 && lastLng != 0.0) {
//            Log.i("DistanceTracking", "Current Location: $lat, $lon")
//            Log.i("DistanceTracking", "Last Location: $lastLat, $lastLng")
//
//            val results = FloatArray(1)
//            Location.distanceBetween(lastLat, lastLng, lat, lon, results)
//            distance = results[0].toDouble() // in meters
//
//
//
//            // 👇 Add movement threshold (e.g., 10 meters)
////            val MIN_DISTANCE_THRESHOLD = 10.0
////            if (distance < MIN_DISTANCE_THRESHOLD) {
////                Log.i("DistanceFilter", "⛔ Movement too small ($distance m), skipping update")
////                return  // Don't proceed if movement is insignificant
////            }
//
//            totalDistanceInMeters += distance
//
//            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
//            prefs.edit().putFloat(DISTANCE_KEY, totalDistanceInMeters.toFloat()).apply()
//            Log.i("MyBackgroundService", "💾 Saved total distance to prefs: $totalDistanceInMeters meters")
//
//            Log.i("DistanceTracking", "📏 Added distance: $distance meters, Total: $totalDistanceInMeters meters")
//
//            // Update last known location
//            lastLat = lat
//            lastLng = lon
//        } else {
//            Log.i("DistanceTracking", "Last lat/lng are zero, skipping distance calculation")
//            // First time location capture
//            lastLat = lat
//            lastLng = lon
//        }
//
//// Send location update to Flutter
//        sendLocationUpdate(lat, lon, distance)
//
//        if (vehicleNumber.isEmpty() || tripId.isEmpty()) {
//            Log.w("BackgroundDebug", "⚠️ vehicleNumber or tripId missing — skipping save")
//            return
//        }
//
////    Thread {
//        Log.i("inside tryies", "✅ Location successfully sent. Response code: ")
//
//        locationExecutor.execute {
//            try {
//                Log.i("inside try", "✅ Location successfully sent. Response code: ")
//
////                val url = URL("http://192.168.0.103:3008/addvehiclelocationUniqueLatlong")
////                val url = URL("http://52.91.161.155:7128/addvehiclelocationUniqueLatlong")
//                val url = URL("https://jessycabs.com:7128/addvehiclelocationUniqueLatlong")
//
//                val conn = url.openConnection() as HttpURLConnection
//                conn.requestMethod = "POST"
//                conn.setRequestProperty("Content-Type", "application/json")
//                conn.doOutput = true
//
//                val sdfDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
//                val sdfTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
//                val sdfCreated = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
//                val now = Date()
//
//                val json = JSONObject()
//                json.put("vehicleno", vehicleNumber)
//                json.put("latitudeloc", lat)
//                json.put("longitutdeloc", lon) // keep typo if backend expects it
//                json.put("Trip_id", tripId)
//                json.put("Runing_Date", sdfDate.format(now))
//                json.put("Runing_Time", sdfTime.format(now))
//                json.put("Trip_Status", tripStatus)
//                json.put("Tripstarttime", sdfTime.format(now))
//                json.put("TripEndTime", sdfTime.format(now))
//                json.put("created_at", sdfCreated.format(now))
//
//                val out = BufferedWriter(OutputStreamWriter(conn.outputStream))
//                out.write(json.toString())
//                out.flush()
//                out.close()
//
//                val responseCode = conn.responseCode
//                Toast.makeText(this, "Location successfully sent To database", Toast.LENGTH_LONG).show()
//
//                Log.i("BackgroundDebug", "✅ Location successfully sent. Response code: $responseCode")
//                Log.i("BackgroundDebug", "Response code: $responseCode")
//                conn.disconnect()
//
//            } catch (e: Exception) {
//                Log.i("inside catch", "✅ Location successfully sent. Response code: ")
//
//                Log.e("BackgroundDebug", "API request failed: ${e.localizedMessage}")
//            }
//        }
//
//
//
//
//
//
//
//
////        Thread {
////
////                try {
//////                val url = URL("http://192.168.0.103:3008/addvehiclelocationUniqueLatlong")
//////                val url = URL("http://52.91.161.155:7128/addvehiclelocationUniqueLatlong")
////                    val url = URL("https://jessycabs.com:7128/addvehiclelocationUniqueLatlong")
////
////                    val conn = url.openConnection() as HttpURLConnection
////                    conn.requestMethod = "POST"
////                    conn.setRequestProperty("Content-Type", "application/json")
////                    conn.doOutput = true
////
////                    val sdfDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
////                    val sdfTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
////                    val sdfCreated = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
////                    val now = Date()
////
////                    val json = JSONObject()
////                    json.put("vehicleno", vehicleNumber)
////                    json.put("latitudeloc", lat)
////                    json.put("longitutdeloc", lon) // keep typo if backend expects it
////                    json.put("Trip_id", tripId)
////                    json.put("Runing_Date", sdfDate.format(now))
////                    json.put("Runing_Time", sdfTime.format(now))
////                    json.put("Trip_Status", tripStatus)
////                    json.put("Tripstarttime", sdfTime.format(now))
////                    json.put("TripEndTime", sdfTime.format(now))
////                    json.put("created_at", sdfCreated.format(now))
////
////                    val out = BufferedWriter(OutputStreamWriter(conn.outputStream))
////                    out.write(json.toString())
////                    out.flush()
////                    out.close()
////
////                    val responseCode = conn.responseCode
////                    Log.i("BackgroundDebug", "✅ Location successfully sent. Response code: $responseCode")
////                    Log.i("BackgroundDebug", "Response code: $responseCode")
////                    conn.disconnect()
////
////                } catch (e: Exception) {
////                    Log.e("BackgroundDebug", "API request failed: ${e.localizedMessage}")
////                }
////            }.start()
//
//
//
//
//
//
//
//
//        // ✅ Update last known location after processing
//        lastLat = lat
//        lastLng = lon
//    }
//
//
//    private fun sendLocationUpdate(lat: Double, lon: Double, distance: Double) {
//        val locationMap = mapOf(
//            "lat" to lat,
//            "lon" to lon,
////            "distance" to distance,
////            "totalDistance" to totalDistanceInMeters
//            "distance" to distance / 1000.0, // Convert to kilometers
//            "totalDistance" to totalDistanceInMeters / 1000.0 // Convert to kilometers
//        )
//        channel.invokeMethod("locationUpdate", locationMap)
//    }
//
//
//
//
//
//    private fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                CHANNEL_ID,
//                "Location Tracking",
//                NotificationManager.IMPORTANCE_HIGH
//            ).apply { description = "Jessy Cabs tracking location" }
//            getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
//        }
//    }
//
//    private fun createNotification(): Notification {
//        val intent = Intent(this, MainActivity::class.java)
//        val pendingIntent = PendingIntent.getActivity(
//            this,
//            0,
//            intent,
//            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
//        )
//
//        return NotificationCompat.Builder(this, CHANNEL_ID)
//            .setContentTitle("Jessy Cabs: Tracking")
//            .setContentText("Tracking your location in background.")
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setContentIntent(pendingIntent)
//            .setOngoing(true)
//            .build()
//    }
//
//    override fun onTaskRemoved(rootIntent: Intent?) {
//        super.onTaskRemoved(rootIntent)
//        Log.i("MyBackgroundService", "✅ App was swiped from recents — service still running")
//
//        Handler(Looper.getMainLooper()).postDelayed({
//            try {
//                showFloatingBubble()
//            } catch (e: Exception) {
//                Log.e("MyBackgroundService", "Floating bubble crash: ${e.localizedMessage}")
//            }
//        }, 500)
//
//
//
//
//
//
//
//    }
//
//    private fun showFloatingBubble() {
//        try {
//
//            if (isBubbleAdded) {
//                Log.i("MyBackgroundService", "🔁 Bubble already added, skipping")
//                return
//            }
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//                Log.w("MyBackgroundService", "Missing overlay permission")
//                return
//            }
//
//            windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
//            val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
//            floatingView = inflater.inflate(R.layout.floating_bubble, null)
//
//            val params = WindowManager.LayoutParams(
//                WindowManager.LayoutParams.WRAP_CONTENT,
//                WindowManager.LayoutParams.WRAP_CONTENT,
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
//                else
//                    WindowManager.LayoutParams.TYPE_PHONE,
//                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//                PixelFormat.TRANSLUCENT
//            ).apply {
//                gravity = Gravity.TOP or Gravity.START
//                x = 0
//                y = 100
//            }
//
//            floatingView.setOnTouchListener(FloatingOnTouchListener(params))
//            windowManager.addView(floatingView, params)
//            isBubbleAdded = true  // ✅ Set flag true
//
//        } catch (e: Exception) {
//            Log.e("MyBackgroundService", "Error showing floating bubble: ${e.localizedMessage}")
//        }
//    }
//
//    inner class FloatingOnTouchListener(private val params: WindowManager.LayoutParams) : View.OnTouchListener {
//        private var initialX = 0
//        private var initialY = 0
//        private var initialTouchX = 0f
//        private var initialTouchY = 0f
//
//        override fun onTouch(v: View?, event: MotionEvent): Boolean {
//            when (event.action) {
//                MotionEvent.ACTION_DOWN -> {
//                    initialX = params.x
//                    initialY = params.y
//                    initialTouchX = event.rawX
//                    initialTouchY = event.rawY
//                    return true
//                }
//                MotionEvent.ACTION_MOVE -> {
//                    params.x = initialX + (event.rawX - initialTouchX).toInt()
//                    params.y = initialY + (event.rawY - initialTouchY).toInt()
//                    windowManager.updateViewLayout(floatingView, params)
//                    return true
//                }
//                MotionEvent.ACTION_UP -> {
//                    val intent = Intent(applicationContext, MainActivity::class.java).apply {
//                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//                        putExtra("fromFloatingIcon", true)
//                    }
//                    startActivity(intent)
//                    return true
//                }
//            }
//            return false
//        }
//    }
//
////    override fun onDestroy() {
////        super.onDestroy()
////        try {
////            locationTimer?.cancel()
////            if (::floatingView.isInitialized) windowManager.removeView(floatingView)
////        } catch (e: Exception) {
////            Log.e("MyBackgroundService", "Destroy error: $e")
////        }
////
////        backgroundTimer?.cancel()
////        backgroundTimer = null
////        Log.i("TimerService", "⛔ Timer stopped")
////    }
//
////    override fun onDestroy() {
////        super.onDestroy()
////        try {
////            locationTimer?.cancel()
////            if (::floatingView.isInitialized && isBubbleAdded) {
////                windowManager.removeView(floatingView)
////                isBubbleAdded = false  // ✅ Reset flag
////            }
////        } catch (e: Exception) {
////            Log.e("MyBackgroundService", "Destroy error: $e")
////        }
////
////        backgroundTimer?.cancel()
////        backgroundTimer = null
////        Log.i("TimerService", "⛔ Timer stopped")
////    }
//
//    fun resetTrackingData() {
//        previousLocation = null
//        totalDistance = 0.0
//        totalDistanceInMeters = 0.0  // ✅ FIX: reset in-memory tracker too
//
//        val prefs = getSharedPreferences("tracking_prefs", Context.MODE_PRIVATE)
//        prefs.edit().putFloat("total_distance_m", 0f).apply()
//        Log.i("MyBackgroundService", "📍 Tracking data reset (distance, prefs, lastLocation)")
//
//        Log.i("MyBackgroundService", "📍 Tracking data reset")
//    }
//
//
//
//    override fun onDestroy() {
//        super.onDestroy()
//        try {
//            fusedLocationClient.removeLocationUpdates(locationCallback) // ✅ Stop updates
//            locationTimer?.cancel()
//            if (::floatingView.isInitialized && isBubbleAdded) {
//                windowManager.removeView(floatingView)
//                isBubbleAdded = false
//            }
//        } catch (e: Exception) {
//            Log.e("MyBackgroundService", "Destroy error: $e")
//        }
//
//        backgroundTimer?.cancel()
//        backgroundTimer = null
//        Log.i("TimerService", "⛔ Service destroyed, location updates stopped")
//    }
//
//
//    fun removeFloatingBubble() {
//        try {
//            if (::floatingView.isInitialized && isBubbleAdded) {
//                windowManager.removeView(floatingView)
//                isBubbleAdded = false
//                Log.i("MyBackgroundService", "🧹 Floating bubble removed")
//            }
//        } catch (e: Exception) {
//            Log.e("MyBackgroundService", "❌ Failed to remove floating bubble: ${e.message}")
//        }
//    }
//
//
//
//    override fun onBind(intent: Intent?): IBinder? = null
//}


















package com.example.jessy_cabs

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.*
import android.provider.Settings
import android.util.Log
import android.view.*
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import org.json.JSONObject
import java.io.BufferedWriter
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.util.Timer
import java.util.TimerTask
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import android.location.Location
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import java.util.concurrent.Executors
//import io.flutter.view.FlutterMain
import io.flutter.FlutterInjector
import android.widget.Toast
import android.content.ComponentName
import kotlin.random.Random
import android.content.pm.PackageManager
import android.Manifest
import androidx.core.app.ActivityCompat
import android.os.Looper
import android.net.ConnectivityManager
import android.net.NetworkCapabilities




import com.google.android.gms.location.*

class MyBackgroundService : Service() {
    private val CHANNEL_ID = "location_channel"
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var windowManager: WindowManager
    private lateinit var floatingView: View
    private var locationTimer: Timer? = null
    private var backgroundTimer: Timer? = null
    private lateinit var channel: MethodChannel
    private val CHANNEL_NAME = "com.example.jessy_cabs/tracking"
    private var isBubbleAdded = false
    private var previousLocation: Location? = null
    private var totalDistance: Double = 0.0
    private val locationExecutor = Executors.newSingleThreadExecutor()

    companion object {
        var isTrackingEnabled: Boolean = false
        var tripId: String = ""         // Set from Dart via MethodChannel if needed
        var vehicleNumber: String = ""  // Set from Dart if required
        var tripStatus: String = "On_Going"  // Default value
        var reach_30minutes: String = "okay"  // Default value

        var instance: MyBackgroundService? = null

    }

    // Track distance

    private var lastLat = 0.0

    private var lastLng = 0.0

    private var totalDistanceInMeters = 0.0

    private val PREFS_NAME = "tracking_prefs"
    private val DISTANCE_KEY = "total_distance_m"

    private lateinit var locationRequest: com.google.android.gms.location.LocationRequest
    private lateinit var locationCallback: com.google.android.gms.location.LocationCallback

    private var offlineStart: Long? = null
    private val handler = Handler(Looper.getMainLooper())

    private val checkRunnable = object : Runnable {
        override fun run() {
            if (!isInternetAvailable(this@MyBackgroundService)) {
                // Internet is OFF
                if (offlineStart == null) {
                    offlineStart = System.currentTimeMillis()
                    Log.d("MyBackgroundService", "Internet lost at $offlineStart")
                }
            } else {
                // Internet is ON
                if (offlineStart != null) {
                    val offlineEnd = System.currentTimeMillis()
                    Log.d("MyBackgroundService", "Internet restored at $offlineEnd")
//                    saveOfflineDataToServer(offlineStart!!, offlineEnd)
                    saveOfflineDataToServer(tripId, offlineStart!!, offlineEnd)

                    offlineStart = null
                }
            }
            handler.postDelayed(this, 5000) // check every 5s
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this


//  openAutoStartSettingsIfAvailable(this)


        handler.post(checkRunnable)



        Log.d("MyBackgroundService", "Service created")
        Log.i("MyBackgroundService", "🔥 onCreate called")
//        Toast.makeText(this, "MyBackgroundService service created", Toast.LENGTH_LONG).show()

        createNotificationChannel()
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Jessy Cabs")
            .setContentText("Tracking location in background")
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .build()

        startForeground(1, notification)

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

//        val engine = FlutterEngine(this)
//        engine.dartExecutor.executeDartEntrypoint(
//            DartExecutor.DartEntrypoint.createDefault()
//        )
//        FlutterEngineCache.getInstance().put("tracking_engine", engine)
//
//        channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)


        // Only AFTER foreground is started, initialize Flutter
        setupFlutterEngine()


        startLocationLoop()

    }

    private fun setupFlutterEngine() {

        Log.i("MyBackgroundService", "🔁setupFlutterEngine meters")


        val flutterEngine = FlutterEngine(this)

        val appBundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath()
        FlutterInjector.instance().flutterLoader().startInitialization(this)
        FlutterInjector.instance().flutterLoader().ensureInitializationComplete(this, null)

        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(appBundlePath, "trackingMain") // 👈 your entrypoint in Dart
        )

        FlutterEngineCache.getInstance().put("tracking_engine", flutterEngine)




        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        totalDistanceInMeters = prefs.getFloat(DISTANCE_KEY, 0f).toDouble()
        Log.i("MyBackgroundService", "🔁 Restored total distance from prefs: $totalDistanceInMeters meters")

        val engine = FlutterEngineCache.getInstance()["my_engine_id"]
        if (engine != null) {
            channel = MethodChannel(engine.dartExecutor.binaryMessenger, "com.example.jessy_cabs/background")
//            Log.i("MyBackgroundService", "✅ Channel successfully created with cached engine")

        } else {
            Log.e("MyBackgroundService", "❌ FlutterEngine 'my_engine_id' not found in cache")
        }

    }


    fun openAutoStartSettingsIfAvailable(context: Context) {
        val prefs = context.getSharedPreferences("prefs", Context.MODE_PRIVATE)
        val shown = prefs.getBoolean("autostart_shown", false)

        if (shown) return

        val possibleIntents = listOf(
            Intent().setComponent(
                ComponentName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                )
            ),
            Intent().setComponent(
                ComponentName(
                    "com.oppo.safe",
                    "com.oppo.safe.permission.startup.StartupAppListActivity"
                )
            ),
            Intent().setComponent(
                ComponentName(
                    "com.coloros.oppoguardelf",
                    "com.coloros.oppoguardelf.permission.startup.StartupAppListActivity"
                )
            ),
            Intent().setComponent(
                ComponentName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.startupapp.StartupAppListActivity"
                )
            )
        )

        for (intent in possibleIntents) {
            try {
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
                prefs.edit().putBoolean("autostart_shown", true).apply()
                Log.i("AutoStart", "✅ Opened AutoStart settings successfully.")
                break
            } catch (e: Exception) {
                Log.w("AutoStart", "Intent failed: ${intent.component}, ${e.message}")
            }
        }
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(1, createNotification())

        Log.d("MyBackgroundService", "Service started")

        // Handle Dart requests
//        MethodChannel(FlutterEngineCache.getInstance()["tracking_engine"]!!.dartExecutor.binaryMessenger, CHANNEL_NAME)
//            .setMethodCallHandler { call, result ->
//                when (call.method) {
//                    "getTotalDistance" -> {
//                        result.success(totalDistanceInMeters)
//                    }
//                    else -> result.notImplemented()
//                }
//            }


        val engine = FlutterEngineCache.getInstance()["tracking_engine"]
        if (engine != null) {
            channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getTotalDistance" -> result.success(totalDistanceInMeters / 1000.0)
//                    "getTotalDistance" -> result.success(totalDistanceInMeters)
                    else -> result.notImplemented()
                }
            }
        } else {
            Log.e("MyBackgroundService", "FlutterEngine 'tracking_engine' not found in cache")
        }

        return START_STICKY
    }

    private fun startLocationLoopone() {
        Log.d("LocationLoop", "📍 inside LocationLoop comment")

        locationRequest = com.google.android.gms.location.LocationRequest.Builder(
            com.google.android.gms.location.Priority.PRIORITY_HIGH_ACCURACY,
            2000L // 2 seconds
        )
            .setWaitForAccurateLocation(false) // ✅ Add this
            .setMinUpdateIntervalMillis(2000L)
            .setMinUpdateDistanceMeters(0f)
            .build()
        Log.d("LocationLoop", "📍 inside LocationLoop second")

        locationCallback = object : com.google.android.gms.location.LocationCallback() {
            override fun onLocationResult(result: com.google.android.gms.location.LocationResult) {
                val location = result.lastLocation
                if (location != null && isTrackingEnabled) {
                    Log.d("LocationLoop", "📍 Lat=${location.latitude}, Lon=${location.longitude}")
                    saveLocationToBackend(location.latitude, location.longitude)
                } else {
                    Log.w("LocationLoop", "⚠️ Location null or tracking disabled")
                }
            }
        }

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            Log.e("Locationerror", "🚫 Location permissions not granted!")
            return
        }




        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            Looper.getMainLooper()

        )
    }

    //working lood but not looping
    private fun startLocationLoop() {
        Log.d("LocationLoop", "📍 inside LocationLoop")

        try {
            locationRequest = LocationRequest.Builder(
                Priority.PRIORITY_HIGH_ACCURACY,
                2000L
            )
                .setMinUpdateIntervalMillis(2000L)
                .setMinUpdateDistanceMeters(10f) // ✅ Set to 0 meters
//                .setMinUpdateDistanceMeters(0f) // ✅ Set to 0 meters
                .setGranularity(Granularity.GRANULARITY_FINE) // ✅ Ensure this is added
                .setWaitForAccurateLocation(false)
                .setMaxUpdateDelayMillis(10000L) // Optional batching
                .build()

            Log.d("LocationLoop", "📍 inside LocationLoop second")

            locationCallback = object : LocationCallback() {

                override fun onLocationResult(result: LocationResult) {
                    Log.d("LocationLoop", "✅ Before calling build()11111")

                    val location = result.lastLocation
                    Log.d("LocationLoop", "✅ Before calling build()22222")
                    Log.d("LocationLoop", "📍 Lat=${location}, Lon=${location}")

                    if (location != null && isTrackingEnabled) {
                        Log.d("LocationLoop", "📍 Lat=${location.latitude}, Lon=${location.longitude}")
                        saveLocationToBackend(location.latitude, location.longitude)
                    } else {
                        Log.w("LocationLoop", "⚠️ Location null or tracking disabled")
                    }
                    Log.d("LocationLoop", "✅ Before calling build()33333")

                }
            }
            Log.d("LocationLoop", "✅ Before calling build()")


            val fineGranted = ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
            val coarseGranted = ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED
            val bgGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED
            else true

            Log.d("LocationLoop", "🔍 Fine: $fineGranted, Coarse: $coarseGranted, Background: $bgGranted")

            if (!fineGranted || !coarseGranted || !bgGranted) {
                Handler(Looper.getMainLooper()).postDelayed({
                    startLocationLoop()
                }, 5000)
                Log.e("LocationLoop", "🚫 One or more location permissions not granted")
                return
            }


            fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback,
                Looper.getMainLooper()
            )

            Log.d("LocationLoop", "🚀 RequestLocationUpdates called")
        } catch (e: Exception) {
            Log.e("LocationLoop", "❌ Exception during location setup: ${e.message}", e)
        }
    }


//    private fun startLocationLoop() {
//        Log.d("LocationLoop", "📍 Starting Location Loop")
//
//        try {
//            // ✅ Check permissions before anything
//            val fineGranted = ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
//            val coarseGranted = ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED
//            val bgGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
//                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED
//            else true
//
//            Log.d("LocationLoop", "🔍 Fine: $fineGranted, Coarse: $coarseGranted, Background: $bgGranted")
//
//            if (!fineGranted || !coarseGranted || !bgGranted) {
//                Log.e("LocationLoop", "🚫 One or more location permissions not granted")
//                return
//            }
//
//            // ✅ Configure location request
//            locationRequest = LocationRequest.Builder(
//                Priority.PRIORITY_HIGH_ACCURACY,
//                2000L // every 2 seconds
//            )
//                .setMinUpdateIntervalMillis(2000L)
//                .setMinUpdateDistanceMeters(5f)
//                .setGranularity(Granularity.GRANULARITY_FINE)
//                .setWaitForAccurateLocation(false)
//                .setMaxUpdateDelayMillis(10000L)
//                .build()
//
//            // ✅ Define callback
//            locationCallback = object : LocationCallback() {
//                override fun onLocationResult(result: LocationResult) {
//                    val location = result.lastLocation
//
//                    if (location != null && isTrackingEnabled) {
//                        Log.d("LocationLoop", "📍 Lat=${location.latitude}, Lon=${location.longitude}")
//                        saveLocationToBackend(location.latitude, location.longitude)
//                    } else {
//                        Log.w("LocationLoop", "⚠️ Location null or tracking disabled")
//                    }
//                }
//            }
//
//            // ✅ Start updates
//            fusedLocationClient.requestLocationUpdates(
//                locationRequest,
//                locationCallback,
//                Looper.getMainLooper()
//            )
//
//            Log.d("LocationLoop", "🚀 Location updates started")
//        } catch (e: Exception) {
//            Log.e("LocationLoop", "❌ Error in startLocationLoop: ${e.message}", e)
//        }
//    }


    private fun saveLocationToBackend(lat: Double, lon: Double) {
        Log.i("BackgroundDebug", "📡inside saveLocationToBackend ")

        try {

            Log.i("BackgroundDebug", "📡saveLocationToBackend triggered with: lat=$lat, lon=$lon")
            Log.d("BackgroundDebug", "🔍 Preparing to send location data:")
            Log.d("BackgroundDebug", "latitude = $lat")
            Log.d("BackgroundDebug", "longitude = $lon")
            Log.d("BackgroundDebug", "vehicleNo = $vehicleNumber")
            Log.d("BackgroundDebug", "tripId = $tripId")
            Log.d("BackgroundDebug", "tripStatus = $tripStatus")

//        Toast.makeText(this, "tripId=${tripId},tripStatus=${tripStatus},vehicle=${vehicleNumber}", Toast.LENGTH_LONG).show()


            var distance = 0.0
            if (lastLat != 0.0 && lastLng != 0.0) {
                Log.i("DistanceTracking", "Current Location: $lat, $lon")
                Log.i("DistanceTracking", "Last Location: $lastLat, $lastLng")

                val results = FloatArray(1)
                Location.distanceBetween(lastLat, lastLng, lat, lon, results)
                distance = results[0].toDouble() // in meters

//new code 26.08.2025

                // 🚦 1. Ignore very small movements (< 25m) → GPS jitter
                if (distance < 10) {
                    Log.i("DistanceFilter", "⛔ Ignored small jump: $distance m")
                    return
                }

                // 🚦 2. Check accuracy (optional but recommended)
                val currentLocation = Location("").apply {
                    latitude = lat
                    longitude = lon
                }
                if (currentLocation.accuracy > 10) { // e.g. only allow <= 20m accuracy
                    Log.i("DistanceFilter", "⚠️ Ignored inaccurate location: ${currentLocation.accuracy}m")
                    return
                }

//new code 26.08.2025

                totalDistanceInMeters += distance

                val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                prefs.edit().putFloat(DISTANCE_KEY, totalDistanceInMeters.toFloat()).apply()
                Log.i(
                    "MyBackgroundService",
                    "💾 Saved total distance to prefs: $totalDistanceInMeters meters"
                )

                Log.i(
                    "DistanceTracking",
                    "📏 Added distance: $distance meters, Total: $totalDistanceInMeters meters"
                )

                // Update last known location
                lastLat = lat
                lastLng = lon
            } else {
                Log.i("DistanceTracking", "Last lat/lng are zero, skipping distance calculation")
                // First time location capture
                lastLat = lat
                lastLng = lon
            }

// Send location update to Flutter
            sendLocationUpdate(lat, lon, distance)

            if (vehicleNumber.isEmpty() || tripId.isEmpty()) {
                Log.w("BackgroundDebug", "⚠️ vehicleNumber or tripId missing — skipping save")
                return
            }

//    Thread {

            Log.i("inside tryies", "✅ Location successfully sent. Response code: ")

            locationExecutor.execute {
                try {
                    Log.i("inside try", "✅ Location successfully sent. Response code: ")


//                    val url = URL("http://202.83.45.236:7128/addvehiclelocationUniqueLatlong")
                    val url = URL("https://jessycabs.com:7128/addvehiclelocationUniqueLatlong")

                    val conn = url.openConnection() as HttpURLConnection
                    conn.requestMethod = "POST"
                    conn.setRequestProperty("Content-Type", "application/json")
                    conn.doOutput = true

                    val sdfDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                    val sdfTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
                    val sdfCreated =
                        SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
                    val now = Date()

                    val json = JSONObject()
                    json.put("vehicleno", vehicleNumber)
                    json.put("latitudeloc", lat)
                    json.put("longitutdeloc", lon) // keep typo if backend expects it
                    json.put("Trip_id", tripId)
                    json.put("Runing_Date", sdfDate.format(now))
                    json.put("Runing_Time", sdfTime.format(now))
                    json.put("Trip_Status", tripStatus)
                    json.put("Tripstarttime", sdfTime.format(now))
                    json.put("TripEndTime", sdfTime.format(now))
                    json.put("created_at", sdfCreated.format(now))
                    json.put("reach_30minutes", reach_30minutes)

                    val out = BufferedWriter(OutputStreamWriter(conn.outputStream))
                    out.write(json.toString())
                    out.flush()
                    out.close()

                    val responseCode = conn.responseCode

                    Log.i(
                        "BackgroundDebug",
                        "✅ Location successfully sent. Response code: $responseCode"
                    )
//                    Toast.makeText(this, "✅ Location successfully sent", Toast.LENGTH_LONG).show()

                    Log.i("BackgroundDebug", "Response code: $responseCode")
                    conn.disconnect()

                } catch (e: Exception) {

                    Log.e("BackgroundDebug", "API request failed: ${e.localizedMessage}")
                }
            }


            locationExecutor.execute {
                try {
                    Log.i("inside try", "✅ Location successfully sent. Response code: ")


                    val url = URL("https://jessycabs.com:7128/addvehiclelocationUniqueLatlong")
//                    val url = URL("http://202.83.45.236:7128/addvehiclelocationUniqueLatlong")

                    val conn = url.openConnection() as HttpURLConnection
                    conn.requestMethod = "POST"
                    conn.setRequestProperty("Content-Type", "application/json")
                    conn.doOutput = true

                    val sdfDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                    val sdfTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
                    val sdfCreated =
                        SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
                    val now = Date()

                    val json = JSONObject()
                    json.put("vehicleno", vehicleNumber)
                    json.put("latitudeloc", lat)
                    json.put("longitutdeloc", lon) // keep typo if backend expects it
                    json.put("Trip_id", tripId)
                    json.put("Runing_Date", sdfDate.format(now))
                    json.put("Runing_Time", sdfTime.format(now))
                    json.put("Trip_Status", tripStatus)
                    json.put("Tripstarttime", sdfTime.format(now))
                    json.put("TripEndTime", sdfTime.format(now))
                    json.put("created_at", sdfCreated.format(now))

                    val out = BufferedWriter(OutputStreamWriter(conn.outputStream))
                    out.write(json.toString())
                    out.flush()
                    out.close()

                    val responseCode = conn.responseCode

                    Log.i(
                        "BackgroundDebug",
                        "✅ Location successfully sent. Response code: $responseCode"
                    )
//                    Toast.makeText(this, "✅ Location successfully sent", Toast.LENGTH_LONG).show()

                    Log.i("BackgroundDebug", "Response code: $responseCode")
                    conn.disconnect()

                } catch (e: Exception) {

                    Log.e("BackgroundDebug", "API request failed: ${e.localizedMessage}")
                }
            }


//        Thread {
//
//                try {
////                val url = URL("http://192.168.0.103:3008/addvehiclelocationUniqueLatlong")
////                val url = URL("http://52.91.161.155:7128/addvehiclelocationUniqueLatlong")
//                    val url = URL("https://jessycabs.com:7128/addvehiclelocationUniqueLatlong")
//
//                    val conn = url.openConnection() as HttpURLConnection
//                    conn.requestMethod = "POST"
//                    conn.setRequestProperty("Content-Type", "application/json")
//                    conn.doOutput = true
//
//                    val sdfDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
//                    val sdfTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
//                    val sdfCreated = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
//                    val now = Date()
//
//                    val json = JSONObject()
//                    json.put("vehicleno", vehicleNumber)
//                    json.put("latitudeloc", lat)
//                    json.put("longitutdeloc", lon) // keep typo if backend expects it
//                    json.put("Trip_id", tripId)
//                    json.put("Runing_Date", sdfDate.format(now))
//                    json.put("Runing_Time", sdfTime.format(now))
//                    json.put("Trip_Status", tripStatus)
//                    json.put("Tripstarttime", sdfTime.format(now))
//                    json.put("TripEndTime", sdfTime.format(now))
//                    json.put("created_at", sdfCreated.format(now))
//
//                    val out = BufferedWriter(OutputStreamWriter(conn.outputStream))
//                    out.write(json.toString())
//                    out.flush()
//                    out.close()
//
//                    val responseCode = conn.responseCode
//                    Log.i("BackgroundDebug", "✅ Location successfully sent. Response code: $responseCode")
//                    Log.i("BackgroundDebug", "Response code: $responseCode")
//                    conn.disconnect()
//
//                } catch (e: Exception) {
//                    Log.e("BackgroundDebug", "API request failed: ${e.localizedMessage}")
//                }
//            }.start()


            // ✅ Update last known location after processing
            lastLat = lat
            lastLng = lon
        } catch (e: Exception) {

            Log.e("saveLocationToBackend", "Unhandled exception: ${e.localizedMessage}", e)
//            Toast.makeText(this, "Unhandled exception: ${e.localizedMessage}", Toast.LENGTH_LONG).show()

        }

    }


    private fun sendLocationUpdate(lat: Double, lon: Double, distance: Double) {
//        Log.e("saveLocationToBackend", "sendLocationUpdate")

        val locationMap = mapOf(
            "lat" to lat,
            "lon" to lon,
//            "distance" to distance,
//            "totalDistance" to totalDistanceInMeters
            "distance" to distance / 1000.0, // Convert to kilometers
            "totalDistance" to totalDistanceInMeters / 1000.0 // Convert to kilometers
        )
        channel.invokeMethod("locationUpdate", locationMap)
    }





    private fun createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Location Tracking",
                NotificationManager.IMPORTANCE_HIGH
            ).apply { description = "Jessy Cabs tracking location" }
            getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {

        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Jessy Cabs: Tracking")
            .setContentText("Tracking your location in background.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.i("MyBackgroundService", "✅ App was swiped from recents — service still running")
//        Toast.makeText(this, " App was swiped from recents — service still running in the background", Toast.LENGTH_LONG).show()

        Handler(Looper.getMainLooper()).postDelayed({
            try {
                showFloatingBubble()

            } catch (e: Exception) {
                Log.e("MyBackgroundService", "Floating bubble crash: ${e.localizedMessage}")

            }
        }, 500)




    }

    private fun showFloatingBubble() {
        try {

            if (isBubbleAdded) {
                Log.i("MyBackgroundService", "🔁 Bubble already added, skipping")
//                Toast.makeText(this, "Bubble already added, skipping", Toast.LENGTH_LONG).show()

                return
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
                Log.w("MyBackgroundService", "Missing overlay permission")
//                Toast.makeText(this, "Missing overlay permission", Toast.LENGTH_LONG).show()

                return
            }

            windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
            val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
            floatingView = inflater.inflate(R.layout.floating_bubble, null)

            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                else
                    WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            ).apply {
                gravity = Gravity.TOP or Gravity.START
                x = 0
                y = 100
            }

            floatingView.setOnTouchListener(FloatingOnTouchListener(params))
            windowManager.addView(floatingView, params)
            isBubbleAdded = true  // ✅ Set flag true

        } catch (e: Exception) {
            Log.e("MyBackgroundService", "Error showing floating bubble: ${e.localizedMessage}")
//            Toast.makeText(this, "Error showing floating bubble:${e.localizedMessage}", Toast.LENGTH_LONG).show()

        }
    }

//    inner class FloatingOnTouchListener(private val params: WindowManager.LayoutParams) : View.OnTouchListener {
//        private var initialX = 0
//        private var initialY = 0
//        private var initialTouchX = 0f
//        private var initialTouchY = 0f
//
//        override fun onTouch(v: View?, event: MotionEvent): Boolean {
//            when (event.action) {
//                MotionEvent.ACTION_DOWN -> {
//                    initialX = params.x
//                    initialY = params.y
//                    initialTouchX = event.rawX
//                    initialTouchY = event.rawY
//                    return true
//                }
//                MotionEvent.ACTION_MOVE -> {
//                    params.x = initialX + (event.rawX - initialTouchX).toInt()
//                    params.y = initialY + (event.rawY - initialTouchY).toInt()
//                    windowManager.updateViewLayout(floatingView, params)
//                    return true
//                }
//                MotionEvent.ACTION_UP -> {
//                    val intent = Intent(applicationContext, MainActivity::class.java).apply {
//                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//                        putExtra("fromFloatingIcon", true)
//                    }
//                    startActivity(intent)
//                    return true
//                }
//            }
//            return false
//        }
//    }



    inner class FloatingOnTouchListener(private val params: WindowManager.LayoutParams) : View.OnTouchListener {
        private var initialX = 0
        private var initialY = 0
        private var initialTouchX = 0f
        private var initialTouchY = 0f
        private var isClick = false
        private val CLICK_THRESHOLD = 10 // px tolerance for click vs drag

        override fun onTouch(v: View?, event: MotionEvent): Boolean {
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    isClick = true
                    return true
                }

                MotionEvent.ACTION_MOVE -> {
                    val dx = (event.rawX - initialTouchX).toInt()
                    val dy = (event.rawY - initialTouchY).toInt()

                    // If moved more than threshold → treat as drag, not click
                    if (Math.abs(dx) > CLICK_THRESHOLD || Math.abs(dy) > CLICK_THRESHOLD) {
                        isClick = false
                    }

                    params.x = initialX + dx
                    params.y = initialY + dy
                    windowManager.updateViewLayout(floatingView, params)
                    return true
                }

                MotionEvent.ACTION_UP -> {
                    if (isClick) {
                        // ✅ Only open activity if it was a "click", not drag
                        val intent = Intent(applicationContext, MainActivity::class.java).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            putExtra("fromFloatingIcon", true)
                        }
                        startActivity(intent)
                    }
                    return true
                }
            }
            return false
        }
    }









//    override fun onDestroy() {
//        super.onDestroy()
//        try {
//            locationTimer?.cancel()
//            if (::floatingView.isInitialized) windowManager.removeView(floatingView)
//        } catch (e: Exception) {
//            Log.e("MyBackgroundService", "Destroy error: $e")
//        }
//
//        backgroundTimer?.cancel()
//        backgroundTimer = null
//        Log.i("TimerService", "⛔ Timer stopped")
//    }

//    override fun onDestroy() {
//        super.onDestroy()
//        try {
//            locationTimer?.cancel()
//            if (::floatingView.isInitialized && isBubbleAdded) {
//                windowManager.removeView(floatingView)
//                isBubbleAdded = false  // ✅ Reset flag
//            }
//        } catch (e: Exception) {
//            Log.e("MyBackgroundService", "Destroy error: $e")
//        }
//
//        backgroundTimer?.cancel()
//        backgroundTimer = null
//        Log.i("TimerService", "⛔ Timer stopped")
//    }

    fun resetTrackingData() {
        previousLocation = null
        totalDistance = 0.0
        totalDistanceInMeters = 0.0  // ✅ FIX: reset in-memory tracker too

        val prefs = getSharedPreferences("tracking_prefs", Context.MODE_PRIVATE)
        prefs.edit().putFloat("total_distance_m", 0f).apply()
        Log.i("MyBackgroundService", "📍 Tracking data reset (distance, prefs, lastLocation)")

        Log.i("MyBackgroundService", "📍 Tracking data reset")
    }



    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(checkRunnable)

        try {
            fusedLocationClient.removeLocationUpdates(locationCallback) // ✅ Stop updates
            locationTimer?.cancel()
            if (::floatingView.isInitialized && isBubbleAdded) {
                windowManager.removeView(floatingView)
                isBubbleAdded = false
            }
        } catch (e: Exception) {
            Log.e("MyBackgroundService", "Destroy error: $e")
        }

        backgroundTimer?.cancel()
        backgroundTimer = null
        Log.i("TimerService", "⛔ Service destroyed, location updates stopped")
//        Toast.makeText(this, "Service destroyed, location updates stopped", Toast.LENGTH_LONG).show()

        val restartIntent = Intent(applicationContext, ServiceRestarter::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            applicationContext, 1, restartIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val alarmManager = applicationContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.set(
            AlarmManager.ELAPSED_REALTIME_WAKEUP,
            SystemClock.elapsedRealtime() + 5000, // 5 seconds later
            pendingIntent
        )
    }


    fun removeFloatingBubble() {
        try {
            if (::floatingView.isInitialized && isBubbleAdded) {
                windowManager.removeView(floatingView)
                isBubbleAdded = false
                Log.i("MyBackgroundService", "🧹 Floating bubble removed")
            }
        } catch (e: Exception) {
            Log.e("MyBackgroundService", "❌ Failed to remove floating bubble: ${e.message}")
        }
    }



    override fun onBind(intent: Intent?): IBinder? = null

    private fun isInternetAvailable(context: Context): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = connectivityManager.activeNetwork ?: return false
        val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
        return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
    }
    private fun formatDate(timestamp: Long): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return sdf.format(Date(timestamp))
    }

    private fun formatTime(timestamp: Long): String {
        val sdf = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
        return sdf.format(Date(timestamp))
    }

    private fun saveOfflineDataToServer(tripId: String, start: Long, end: Long) {
        // Example: API call
//        val tripId = "12345" // replace with real value

        val json = JSONObject()
        json.put("Trip_id", tripId)
//        json.put("Offline_Start", start.toString())
//        json.put("Offline_end", end.toString())
        json.put("Offline_Start", formatTime(start))  // ✅ formatted
        json.put("Offline_end", formatTime(end))
        json.put("Offline_StartDate", formatDate(start))  // ✅ formatted
        json.put("Offline_endDate", formatDate(end))
        json.put("status", "offline")

        Thread {
            try {
//                val url = URL("http://202.83.45.236:7128/networkConnection")
                val url = URL("https://jessycabs.com:7128/networkConnection")

                val conn = url.openConnection() as HttpURLConnection
                conn.requestMethod = "POST"
                conn.setRequestProperty("Content-Type", "application/json")
                conn.doOutput = true

                val outputWriter = OutputStreamWriter(conn.outputStream)
                outputWriter.write(json.toString())
                outputWriter.flush()

                val responseCode = conn.responseCode
                Log.d("MyBackgroundService", "Response Code: $responseCode")

                conn.disconnect()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }.start()
    }

}