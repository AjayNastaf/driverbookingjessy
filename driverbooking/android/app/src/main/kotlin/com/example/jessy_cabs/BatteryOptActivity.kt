package com.example.jessy_cabs

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log

class BatteryOptActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val packageName = packageName
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            }

            try {
                startActivity(intent)
            } catch (e: Exception) {
                Log.e("BatteryOptActivity", "Failed to open battery settings: ${e.message}")
            }
        }

        // Finish the trampoline activity after short delay to return control
        finish()
    }
}
