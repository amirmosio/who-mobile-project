package com.who.mobile

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * BroadcastReceiver for maintenance alert notifications.
 * Receives alarm triggers from AlarmManager and delegates to MaintenanceAlertScheduler.
 */
class MaintenanceAlertReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent == null) {
            Log.w(TAG, "Received null intent; ignoring maintenance alert broadcast")
            return
        }

        Log.i(TAG, "Maintenance alert broadcast received: ${intent.action}")

        when (intent.action) {
            MaintenanceAlertScheduler.ACTION_MAINTENANCE_ALERT -> {
                MaintenanceAlertScheduler.handleAlertTriggered(
                    context.applicationContext,
                    intent
                )
            }
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                // Restore alerts after reboot or app update
                MaintenanceAlertScheduler.restoreAlerts(context.applicationContext)
            }
            else -> {
                Log.w(TAG, "Unknown action: ${intent.action}")
            }
        }
    }

    companion object {
        private const val TAG = "MaintenanceAlertReceiver"
    }
}
