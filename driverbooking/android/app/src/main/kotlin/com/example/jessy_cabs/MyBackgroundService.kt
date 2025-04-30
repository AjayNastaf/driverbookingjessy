//package com.example.jessy_cabs
//
//import android.app.Notification
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.Service
//import android.content.Intent
//import android.content.pm.ServiceInfo
//import android.os.Build
//import android.os.IBinder
//import androidx.core.app.NotificationCompat
//
//class MyBackgroundService : Service() {
//
//    override fun onCreate() {
//        super.onCreate()
//
//        // Create a notification channel if needed
//        createNotificationChannel()
//
//        val notification: Notification = NotificationCompat.Builder(this, "location_channel")
//            .setContentTitle("Tracking Location")
//            .setContentText("Location updates are running in the background.")
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .build()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            // Starting foreground service with location permission
//            startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
//        } else {
//            startForeground(1, notification)
//        }
//    }
//
//    private fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                "location_channel",
//                "Location Tracking Service",
//                NotificationManager.IMPORTANCE_DEFAULT
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager?.createNotificationChannel(channel)
//        }
//    }
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        // Start location updates here
//        return START_STICKY
//    }
//
//    override fun onBind(intent: Intent?): IBinder? {
//        return null
//    }
//}



//working 1


package com.example.jessy_cabs

import android.Manifest
import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class MyBackgroundService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private lateinit var locationManager: LocationManager
    private lateinit var locationListener: LocationListener

    private val timerRunnable = object : Runnable {
        override fun run() {
            Log.d("MyBackgroundService", "Timer is running in background...")
            handler.postDelayed(this, 10000) // Every 10 seconds
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()

        val notification = createNotification()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
        } else {
            startForeground(1, notification)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startTimer()
        startLocationUpdates()
        return START_STICKY
    }

    private fun startTimer() {
        handler.post(timerRunnable)
    }

    private fun startLocationUpdates() {
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                Log.d("MyBackgroundService", "Location: ${location.latitude}, ${location.longitude}")
            }
        }
        try {
            val permission = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            if (permission == android.content.pm.PackageManager.PERMISSION_GRANTED) {
                locationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER,
                    5000L,
                    5f,
                    locationListener
                )
            } else {
                Log.e("MyBackgroundService", "Location permission not granted")
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun createNotification(): Notification {
        val channelId = "location_channel"
        return NotificationCompat.Builder(this, channelId)
            .setContentTitle("Tracking Location")
            .setContentText("Your location is being tracked in the background.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH) // Important
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                "location_channel",
                "Location Service Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(timerRunnable)
        if (::locationManager.isInitialized && ::locationListener.isInitialized) {
            locationManager.removeUpdates(locationListener)
        }
    }
}



