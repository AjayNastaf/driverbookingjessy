package com.example.jessy_cabs
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat

class ServiceRestarter : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "RESTART_MY_SERVICE") {
            context?.startForegroundService(Intent(context, MyBackgroundService::class.java))
        }
    }
}
