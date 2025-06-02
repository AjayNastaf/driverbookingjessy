//package com.example.jessy_cabs
//
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.Service
//import android.content.Context
//import android.content.Intent
//import android.graphics.PixelFormat
//import android.os.Build
//import android.os.IBinder
//import android.view.Gravity
//import android.view.LayoutInflater
//import android.view.View
//import android.view.WindowManager
//import androidx.core.app.NotificationCompat
//import android.content.pm.ServiceInfo
//
//class FloatingService : Service() {
//
//    private lateinit var windowManager: WindowManager
//    private lateinit var floatingView: View
//    private val notificationId = 1234
//    private val channelId = "floating_service_channel"
//
//    override fun onBind(intent: Intent?): IBinder? = null
//
//    override fun onCreate() {
//        super.onCreate()
//        createNotificationChannel()
//        startForegroundService()
//        setupFloatingWindow()
//    }
//
//    private fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                channelId,
//                "Floating Service Channel",
//                NotificationManager.IMPORTANCE_LOW
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager.createNotificationChannel(channel)
//        }
//    }
//
//    private fun startForegroundService() {
//        val notification = NotificationCompat.Builder(this, channelId)
//            .setContentTitle("Floating Service")
//            .setContentText("Your service is running")
//            .setSmallIcon(android.R.drawable.ic_dialog_info)
//            .setPriority(NotificationCompat.PRIORITY_LOW)
//            .build()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            startForeground(notificationId, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
//        } else {
//            startForeground(notificationId, notification)
//        }
//    }
//
//    private fun setupFloatingWindow() {
//        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
//        floatingView = LayoutInflater.from(this).inflate(R.layout.layout_floating_widget, null)
//
//        val params = WindowManager.LayoutParams(
//            WindowManager.LayoutParams.WRAP_CONTENT,
//            WindowManager.LayoutParams.WRAP_CONTENT,
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
//            else
//                WindowManager.LayoutParams.TYPE_PHONE,
//            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//            PixelFormat.TRANSLUCENT
//        )
//
//        params.gravity = Gravity.TOP or Gravity.START
//        params.x = 0
//        params.y = 100
//
//        windowManager.addView(floatingView, params)
//
//        floatingView.setOnClickListener {
//            val launchIntent = Intent(applicationContext, MainActivity::class.java).apply {
//                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//                putExtra("fromFloatingIcon", true)
//            }
//            applicationContext.startActivity(launchIntent)
//        }
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        if (::windowManager.isInitialized && ::floatingView.isInitialized) {
//            windowManager.removeView(floatingView)
//        }
//    }
//}







//
//
//package com.example.jessy_cabs
//
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.Service
//import android.content.Context
//import android.content.Intent
//import android.graphics.PixelFormat
//import android.os.Build
//import android.os.IBinder
//import android.view.Gravity
//import android.view.LayoutInflater
//import android.view.View
//import android.view.WindowManager
//import androidx.core.app.NotificationCompat
//import android.content.pm.ServiceInfo
//
//class FloatingService : Service() {
//
//    private lateinit var windowManager: WindowManager
//    private lateinit var floatingView: View
//    private val notificationId = 1234
//    private val channelId = "floating_service_channel"
//
//    override fun onBind(intent: Intent?): IBinder? = null
//
//    override fun onCreate() {
//        super.onCreate()
//        createNotificationChannel()
//        startForegroundService()
//        setupFloatingWindow()
//    }
//
//    private fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                channelId,
//                "Floating Service Channel",
//                NotificationManager.IMPORTANCE_LOW
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager.createNotificationChannel(channel)
//        }
//    }
//
//    private fun startForegroundService() {
//        val notification = NotificationCompat.Builder(this, channelId)
//            .setContentTitle("Floating Service")
//            .setContentText("Floating icon active")
//            .setSmallIcon(android.R.drawable.ic_dialog_info)
//            .setPriority(NotificationCompat.PRIORITY_LOW)
//            .build()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            startForeground(notificationId, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
//        } else {
//            startForeground(notificationId, notification)
//        }
//    }
//
//    private fun setupFloatingWindow() {
//        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
//        floatingView = LayoutInflater.from(this).inflate(R.layout.layout_floating_widget, null)
//
//        val params = WindowManager.LayoutParams(
//            WindowManager.LayoutParams.WRAP_CONTENT,
//            WindowManager.LayoutParams.WRAP_CONTENT,
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
//            else
//                WindowManager.LayoutParams.TYPE_PHONE,
//            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//            PixelFormat.TRANSLUCENT
//        )
//
//        params.gravity = Gravity.TOP or Gravity.START
//        params.x = 0
//        params.y = 100
//
//        windowManager.addView(floatingView, params)
//
//        floatingView.setOnClickListener {
//            val launchIntent = Intent(applicationContext, MainActivity::class.java).apply {
//                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//                putExtra("fromFloatingIcon", true)
//            }
//            applicationContext.startActivity(launchIntent)
//        }
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        if (::windowManager.isInitialized && ::floatingView.isInitialized) {
//            windowManager.removeView(floatingView)
//        }
//    }
//}










//
//
//
//
//package com.example.jessy_cabs
//
//import android.app.*
//import android.content.Intent
//import android.graphics.PixelFormat
//import android.os.Build
//import android.os.IBinder
//import android.view.Gravity
//import android.view.LayoutInflater
//import android.view.View
//import android.view.WindowManager
//import androidx.core.app.NotificationCompat
//
//class FloatingService : Service() {
//    private var floatingView: View? = null
//    private lateinit var windowManager: WindowManager
//
//    override fun onCreate() {
//        super.onCreate()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                "floating_service_channel",
//                "Floating Service",
//                NotificationManager.IMPORTANCE_LOW
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager?.createNotificationChannel(channel)
//
//            val notification = NotificationCompat.Builder(this, "floating_service_channel")
//                .setContentTitle("Jessy Cabs")
//                .setContentText("Floating icon active")
//                .setSmallIcon(R.drawable.ic_launcher_foreground)
//                .build()
//
//            startForeground(2, notification)
//        }
//
//        floatingView = LayoutInflater.from(this).inflate(R.layout.floating_view, null)
//
//        val params = WindowManager.LayoutParams(
//            WindowManager.LayoutParams.WRAP_CONTENT,
//            WindowManager.LayoutParams.WRAP_CONTENT,
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
//            else
//                WindowManager.LayoutParams.TYPE_PHONE,
//            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//            PixelFormat.TRANSLUCENT
//        )
//        params.gravity = Gravity.TOP or Gravity.END
//        params.x = 0
//        params.y = 100
//
//        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
//        windowManager.addView(floatingView, params)
//
//        floatingView?.setOnTouchListener { _, _ ->
//            val intent = Intent(this, MainActivity::class.java)
//            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
//            intent.putExtra("fromFloatingIcon", true)
//            startActivity(intent)
//            stopSelf()
//            false
//        }
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        if (floatingView != null) {
//            windowManager.removeView(floatingView)
//        }
//    }
//
//    override fun onBind(intent: Intent?): IBinder? = null
//}













package com.example.jessy_cabs

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.*
import androidx.core.app.NotificationCompat
import android.content.pm.ServiceInfo

class FloatingService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var floatingView: View
    private val notificationId = 1234
    private val channelId = "floating_service_channel"

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startFloatingNotification()
        setupFloatingWindow()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Floating Service Channel",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun startFloatingNotification() {
        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Floating Icon Active")
            .setContentText("Jessy Cabs is running in background.")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(notificationId, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
        } else {
            startForeground(notificationId, notification)
        }
    }

    private fun setupFloatingWindow() {
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        floatingView = LayoutInflater.from(this).inflate(R.layout.layout_floating_widget, null)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.TOP or Gravity.START
        params.x = 0
        params.y = 100

        floatingView.setOnTouchListener(FloatingTouchListener(params))
        windowManager.addView(floatingView, params)

        floatingView.setOnClickListener {
            val launchIntent = Intent(applicationContext, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                putExtra("fromFloatingIcon", true)
            }
            startActivity(launchIntent)
        }
    }

    inner class FloatingTouchListener(private val params: WindowManager.LayoutParams) : View.OnTouchListener {
        private var initialX = 0
        private var initialY = 0
        private var initialTouchX = 0f
        private var initialTouchY = 0f

        override fun onTouch(view: View?, event: MotionEvent): Boolean {
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
                    // Already handled in onClick
                    return true
                }
            }
            return false
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::windowManager.isInitialized && ::floatingView.isInitialized) {
            windowManager.removeView(floatingView)
        }
    }
}
