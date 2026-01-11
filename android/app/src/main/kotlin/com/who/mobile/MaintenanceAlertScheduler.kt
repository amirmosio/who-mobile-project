package com.who.mobile

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.AlarmManagerCompat
import androidx.core.app.NotificationCompat

/**
 * Scheduler for maintenance alert notifications.
 * Handles scheduling repeating notifications for facility maintenance tasks.
 */
object MaintenanceAlertScheduler {

    private const val TAG = "MaintenanceAlertScheduler"
    private const val CHANNEL_ID = "maintenance_alerts"
    private const val CHANNEL_NAME = "Maintenance Alerts"
    private const val CHANNEL_DESCRIPTION = "Notifications for facility maintenance tasks"
    private const val PREFS_NAME = "maintenance_alert_prefs"
    private const val KEY_SCHEDULED_IDS = "scheduled_notification_ids"

    const val ACTION_MAINTENANCE_ALERT = "com.who.mobile.action.MAINTENANCE_ALERT"
    const val EXTRA_NOTIFICATION_ID = "extra_notification_id"
    const val EXTRA_TITLE = "extra_title"
    const val EXTRA_BODY = "extra_body"
    const val EXTRA_INTERVAL_HOURS = "extra_interval_hours"
    const val EXTRA_PAYLOAD = "extra_payload"

    /**
     * Schedule a repeating maintenance alert notification.
     *
     * @param context Application context
     * @param notificationId Unique ID for this notification
     * @param title Notification title
     * @param body Notification body text
     * @param intervalHours Hours between notifications
     * @param triggerAtMillis First trigger time in milliseconds
     * @param payload Optional payload data
     * @return true if scheduled successfully, false otherwise
     */
    fun scheduleAlert(
        context: Context,
        notificationId: Int,
        title: String,
        body: String,
        intervalHours: Int,
        triggerAtMillis: Long,
        payload: String?
    ): Boolean {
        val alarmManager =
            context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                ?: run {
                    Log.e(TAG, "AlarmManager not available")
                    return false
                }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            !alarmManager.canScheduleExactAlarms()
        ) {
            Log.w(TAG, "Exact alarm permission not granted by the system")
            return false
        }

        val pendingIntent = buildPendingIntent(
            context,
            notificationId,
            title,
            body,
            intervalHours,
            payload,
            PendingIntent.FLAG_UPDATE_CURRENT
        ) ?: run {
            Log.e(TAG, "Unable to build PendingIntent for maintenance alert")
            return false
        }

        AlarmManagerCompat.setExactAndAllowWhileIdle(
            alarmManager,
            AlarmManager.RTC_WAKEUP,
            triggerAtMillis,
            pendingIntent
        )

        saveScheduledId(context, notificationId)
        ensureNotificationChannel(context)

        Log.i(TAG, "Scheduled maintenance alert ID: $notificationId, interval: ${intervalHours}h")
        return true
    }

    /**
     * Cancel a specific maintenance alert.
     *
     * @param context Application context
     * @param notificationId ID of the notification to cancel
     */
    fun cancelAlert(context: Context, notificationId: Int) {
        val alarmManager =
            context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                ?: return

        val pendingIntent = buildPendingIntent(
            context,
            notificationId,
            "",
            "",
            0,
            null,
            PendingIntent.FLAG_NO_CREATE
        )

        pendingIntent?.let {
            alarmManager.cancel(it)
            it.cancel()
        }

        // Also cancel any shown notification
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
        notificationManager?.cancel(notificationId)

        removeScheduledId(context, notificationId)
        Log.i(TAG, "Cancelled maintenance alert ID: $notificationId")
    }

    /**
     * Cancel all scheduled maintenance alerts.
     *
     * @param context Application context
     */
    fun cancelAllAlerts(context: Context) {
        val scheduledIds = getScheduledIds(context)
        for (id in scheduledIds) {
            cancelAlert(context, id)
        }
        clearAllScheduledIds(context)
        Log.i(TAG, "Cancelled all ${scheduledIds.size} maintenance alerts")
    }

    /**
     * Handle when a maintenance alert is triggered by AlarmManager.
     * Shows the notification and reschedules for the next interval.
     */
    internal fun handleAlertTriggered(context: Context, intent: Intent) {
        val notificationId = intent.getIntExtra(EXTRA_NOTIFICATION_ID, -1)
        val title = intent.getStringExtra(EXTRA_TITLE)
        val body = intent.getStringExtra(EXTRA_BODY)
        val intervalHours = intent.getIntExtra(EXTRA_INTERVAL_HOURS, 0)
        val payload = intent.getStringExtra(EXTRA_PAYLOAD)

        if (notificationId == -1 || title.isNullOrBlank() || body.isNullOrBlank()) {
            Log.w(TAG, "Maintenance alert triggered with incomplete data; skipping")
            return
        }

        showNotification(context, notificationId, title, body, payload)

        // Reschedule for next interval if intervalHours > 0
        if (intervalHours > 0) {
            val nextTrigger = System.currentTimeMillis() + (intervalHours * 60 * 60 * 1000L)
            scheduleAlert(
                context,
                notificationId,
                title,
                body,
                intervalHours,
                nextTrigger,
                payload
            )
            Log.i(TAG, "Rescheduled maintenance alert ID: $notificationId for next ${intervalHours}h")
        }
    }

    /**
     * Restore all scheduled alerts after device reboot or app update.
     */
    internal fun restoreAlerts(context: Context) {
        // For maintenance alerts, we rely on the Flutter app to reschedule
        // when it initializes, as we don't store full alert configuration.
        Log.d(TAG, "Maintenance alerts should be restored by Flutter app on startup")
    }

    /**
     * Show a test notification immediately for verification purposes.
     *
     * @param context Application context
     * @param title Optional notification title
     * @param body Optional notification body
     * @return true if notification was shown successfully
     */
    fun showTestNotification(
        context: Context,
        title: String?,
        body: String?
    ): Boolean {
        Log.i(TAG, "showTestNotification called with title: $title, body: $body")

        ensureNotificationChannel(context)
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager

        if (notificationManager == null) {
            Log.e(TAG, "NotificationManager is null!")
            return false
        }

        // Check if notifications are enabled for this channel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = notificationManager.getNotificationChannel(CHANNEL_ID)
            Log.i(TAG, "Channel: $CHANNEL_ID, importance: ${channel?.importance}, enabled: ${channel?.importance != NotificationManager.IMPORTANCE_NONE}")
        }

        // Check if app can post notifications (Android 13+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val areNotificationsEnabled = notificationManager.areNotificationsEnabled()
            Log.i(TAG, "Notifications enabled for app: $areNotificationsEnabled")
            if (!areNotificationsEnabled) {
                Log.w(TAG, "Notifications are disabled for this app!")
            }
        }

        try {
            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info) // Use system icon for reliability
                .setContentTitle(title ?: "Maintenance Alert Test")
                .setContentText(body ?: "This is a test notification for maintenance alerts")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
                .setDefaults(NotificationCompat.DEFAULT_ALL)
                .setStyle(
                    NotificationCompat.BigTextStyle().bigText(
                        body ?: "This is a test notification for maintenance alerts"
                    )
                )
                .build()

            notificationManager.notify(TEST_NOTIFICATION_ID, notification)
            Log.i(TAG, "Notification posted with ID: $TEST_NOTIFICATION_ID")
            return true
        } catch (e: Exception) {
            Log.e(TAG, "Error posting notification: ${e.message}", e)
            return false
        }
    }

    private const val TEST_NOTIFICATION_ID = 200001

    private fun buildPendingIntent(
        context: Context,
        notificationId: Int,
        title: String,
        body: String,
        intervalHours: Int,
        payload: String?,
        flag: Int
    ): PendingIntent? {
        val intent = Intent(context, MaintenanceAlertReceiver::class.java).apply {
            action = ACTION_MAINTENANCE_ALERT
            putExtra(EXTRA_NOTIFICATION_ID, notificationId)
            putExtra(EXTRA_TITLE, title)
            putExtra(EXTRA_BODY, body)
            putExtra(EXTRA_INTERVAL_HOURS, intervalHours)
            putExtra(EXTRA_PAYLOAD, payload)
        }

        var flags = PendingIntent.FLAG_IMMUTABLE
        when (flag) {
            PendingIntent.FLAG_NO_CREATE -> flags = flags or PendingIntent.FLAG_NO_CREATE
            PendingIntent.FLAG_UPDATE_CURRENT -> flags = flags or PendingIntent.FLAG_UPDATE_CURRENT
        }

        return PendingIntent.getBroadcast(
            context,
            notificationId, // Use notificationId as request code to make each unique
            intent,
            flags
        )
    }

    private fun ensureNotificationChannel(context: Context) {
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                ?: return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (notificationManager.getNotificationChannel(CHANNEL_ID) == null) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = CHANNEL_DESCRIPTION
                    enableVibration(true)
                }
                notificationManager.createNotificationChannel(channel)
                Log.i(TAG, "Created notification channel $CHANNEL_ID")
            }
        }
    }

    private fun showNotification(
        context: Context,
        notificationId: Int,
        title: String,
        body: String,
        payload: String?
    ) {
        ensureNotificationChannel(context)
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                ?: return

        val launchIntent = context.packageManager
            .getLaunchIntentForPackage(context.packageName)
            ?: Intent(context, MainActivity::class.java)
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        payload?.let { launchIntent.putExtra("payload", it) }

        val contentIntent = PendingIntent.getActivity(
            context,
            notificationId,
            launchIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(contentIntent)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .build()

        notificationManager.notify(notificationId, notification)
        Log.i(TAG, "Displayed maintenance alert notification ID: $notificationId")
    }

    // Persistence helpers for tracking scheduled notification IDs

    private fun saveScheduledId(context: Context, notificationId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val ids = getScheduledIds(context).toMutableSet()
        ids.add(notificationId)
        prefs.edit().putStringSet(KEY_SCHEDULED_IDS, ids.map { it.toString() }.toSet()).apply()
    }

    private fun removeScheduledId(context: Context, notificationId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val ids = getScheduledIds(context).toMutableSet()
        ids.remove(notificationId)
        prefs.edit().putStringSet(KEY_SCHEDULED_IDS, ids.map { it.toString() }.toSet()).apply()
    }

    private fun getScheduledIds(context: Context): Set<Int> {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val stringIds = prefs.getStringSet(KEY_SCHEDULED_IDS, emptySet()) ?: emptySet()
        return stringIds.mapNotNull { it.toIntOrNull() }.toSet()
    }

    private fun clearAllScheduledIds(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().remove(KEY_SCHEDULED_IDS).apply()
    }
}
