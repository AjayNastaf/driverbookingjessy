//// ✅ FINAL PRODUCTION BACKGROUND SERVICE WITH ACTUAL API CALL
//// Sends location to API using vehicleNumber, tripId, and tripStatus like in Customerlocationreached.dart


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




class MyBackgroundService : Service() {
    private val CHANNEL_ID = "location_channel"
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var windowManager: WindowManager
    private lateinit var floatingView: View
    private var locationTimer: Timer? = null
    private var backgroundTimer: Timer? = null
    private lateinit var channel: MethodChannel
    private val CHANNEL_NAME = "com.example.jessy_cabs/tracking"

    companion object {
        var isTrackingEnabled: Boolean = false
        var tripId: String = ""         // Set from Dart via MethodChannel if needed
        var vehicleNumber: String = ""  // Set from Dart if required
        var tripStatus: String = "On_Going"  // Default value
    }

    // Track distance

    private var lastLat = 0.0

    private var lastLng = 0.0

    private var totalDistanceInMeters = 0.0

    override fun onCreate() {
        super.onCreate()
        Log.d("MyBackgroundService", "Service created")
        createNotificationChannel()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
//        val engine = FlutterEngine(this)
//        engine.dartExecutor.executeDartEntrypoint(
//            DartExecutor.DartEntrypoint.createDefault()
//        )
//        FlutterEngineCache.getInstance().put("tracking_engine", engine)
//
//        channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        channel = MethodChannel(
            FlutterEngine(this).dartExecutor.binaryMessenger,
            "com.example.jessy_cabs/location"
        )

        startLocationLoop()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("MyBackgroundService", "Service started")
        startForeground(1, createNotification())

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
                    "getTotalDistance" -> result.success(totalDistanceInMeters)
                    else -> result.notImplemented()
                }
            }
        } else {
            Log.e("MyBackgroundService", "FlutterEngine 'tracking_engine' not found in cache")
        }

        return START_STICKY
    }

    private fun startLocationLoop() {
        locationTimer = Timer()
        locationTimer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                if (!isTrackingEnabled) return

                fusedLocationClient.lastLocation
                    .addOnSuccessListener { location ->
                        if (location != null) {
                            Log.d("LocationLoop", "Lat=${location.latitude}, Lon=${location.longitude}")
                            saveLocationToBackend(location.latitude, location.longitude)
                        } else {
                            Log.w("LocationLoop", "Location is null")
                        }
                    }
                    .addOnFailureListener {
                        Log.e("LocationLoop", "Failed to get location: ${it.localizedMessage}")
                    }
            }
        }, 0, 5000)
    }

    private fun saveLocationToBackend(lat: Double, lon: Double) {
            Log.i("BackgroundDebug", "📡 saveLocationToBackend triggered with: lat=$lat, lon=$lon")
        Log.d("BackgroundDebug", "🔍 Preparing to send location data:")
        Log.d("BackgroundDebug", "latitude = $lat")
        Log.d("BackgroundDebug", "longitude = $lon")
        Log.d("BackgroundDebug", "vehicleNo = $vehicleNumber")
        Log.d("BackgroundDebug", "tripId = $tripId")
        Log.d("BackgroundDebug", "tripStatus = $tripStatus")


        var distance = 0.0
        if (lastLat != 0.0 && lastLng != 0.0) {
            Log.i("DistanceTracking", "Current Location: $lat, $lon")
            Log.i("DistanceTracking", "Last Location: $lastLat, $lastLng")

            val results = FloatArray(1)
            Location.distanceBetween(lastLat, lastLng, lat, lon, results)
            distance = results[0].toDouble() // in meters

            totalDistanceInMeters += distance
            Log.i("DistanceTracking", "📏 Added distance: $distance meters, Total: $totalDistanceInMeters meters")

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

    Thread {
            try {
//                val url = URL("https://jessycabs.com:7128/addvehiclelocationUniqueLatlong")
//                val url = URL("http://192.168.0.114:3004/addvehiclelocationUniqueLatlong")
                val url = URL("http://http://75.101.215.49:7128/addvehiclelocationUniqueLatlong")

                val conn = url.openConnection() as HttpURLConnection
                conn.requestMethod = "POST"
                conn.setRequestProperty("Content-Type", "application/json")
                conn.doOutput = true

                val sdfDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val sdfTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
                val sdfCreated = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
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
                 Log.i("BackgroundDebug", "✅ Location successfully sent. Response code: $responseCode")
                Log.i("BackgroundDebug", "Response code: $responseCode")
                conn.disconnect()

            } catch (e: Exception) {
                Log.e("BackgroundDebug", "API request failed: ${e.localizedMessage}")
            }
        }.start()

        // ✅ Update last known location after processing
        lastLat = lat
        lastLng = lon
    }


    private fun sendLocationUpdate(lat: Double, lon: Double, distance: Double) {
        val locationMap = mapOf(
            "lat" to lat,
            "lon" to lon,
            "distance" to distance,
            "totalDistance" to totalDistanceInMeters
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
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
                Log.w("MyBackgroundService", "Missing overlay permission")
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
        } catch (e: Exception) {
            Log.e("MyBackgroundService", "Error showing floating bubble: ${e.localizedMessage}")
        }
    }

    inner class FloatingOnTouchListener(private val params: WindowManager.LayoutParams) : View.OnTouchListener {
        private var initialX = 0
        private var initialY = 0
        private var initialTouchX = 0f
        private var initialTouchY = 0f

        override fun onTouch(v: View?, event: MotionEvent): Boolean {
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    return true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = initialX + (event.rawX - initialTouchX).toInt()
                    params.y = initialY + (event.rawY - initialTouchY).toInt()
                    windowManager.updateViewLayout(floatingView, params)
                    return true
                }
                MotionEvent.ACTION_UP -> {
                    val intent = Intent(applicationContext, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        putExtra("fromFloatingIcon", true)
                    }
                    startActivity(intent)
                    return true
                }
            }
            return false
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            locationTimer?.cancel()
            if (::floatingView.isInitialized) windowManager.removeView(floatingView)
        } catch (e: Exception) {
            Log.e("MyBackgroundService", "Destroy error: $e")
        }

        backgroundTimer?.cancel()
        backgroundTimer = null
        Log.i("TimerService", "⛔ Timer stopped")
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
