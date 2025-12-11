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
import java.util.Calendar
import java.util.Locale
import java.util.TimeZone

object QuizReminderScheduler {

    private const val TAG = "QuizReminderScheduler"
    private const val CHANNEL_ID = "quiz_reminder_channel"
    private const val CHANNEL_NAME = "Quiz Reminder"
    private const val CHANNEL_DESCRIPTION = "Daily reminder to practice quiz"
    private const val REQUEST_CODE = 1001
    private const val PREFS_NAME = "quiz_reminder_prefs"
    private const val KEY_ENABLED = "enabled"
    private const val KEY_HOUR = "hour"
    private const val KEY_MINUTE = "minute"
    private const val KEY_TITLE = "title"
    private const val KEY_BODY = "body"

    const val ACTION_REMINDER = "com.who.mobile.action.QUIZ_REMINDER"
    const val EXTRA_TITLE = "extra_title"
    const val EXTRA_BODY = "extra_body"
    const val EXTRA_HOUR = "extra_hour"
    const val EXTRA_MINUTE = "extra_minute"

    fun scheduleReminder(
        context: Context,
        hour: Int,
        minute: Int,
        title: String,
        body: String
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

        val triggerAtMillis = computeNextTriggerMillis(hour, minute)

        val pendingIntent = buildPendingIntent(
            context,
            hour,
            minute,
            title,
            body,
            PendingIntent.FLAG_CANCEL_CURRENT
        ) ?: run {
            Log.e(TAG, "Unable to build PendingIntent for reminder")
            return false
        }

        AlarmManagerCompat.setExactAndAllowWhileIdle(
            alarmManager,
            AlarmManager.RTC_WAKEUP,
            triggerAtMillis,
            pendingIntent
        )

        Log.i(
            TAG,
            "Scheduled reminder at $hour:$minute (${formatMillis(triggerAtMillis)})"
        )

        saveConfig(context, ReminderConfig(hour, minute, title, body))
        ensureNotificationChannel(context)
        return true
    }

    fun cancelReminder(context: Context) {
        val alarmManager =
            context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                ?: return
        val pendingIntent = buildPendingIntent(
            context,
            0,
            0,
            "",
            "",
            PendingIntent.FLAG_NO_CREATE
        )
        pendingIntent?.let {
            alarmManager.cancel(it)
            it.cancel()
        }
        clearConfig(context)
        Log.i(TAG, "Cancelled quiz reminder alarm")
    }

    fun isReminderScheduled(context: Context): Boolean {
        val pendingIntent = buildPendingIntent(
            context,
            0,
            0,
            "",
            "",
            PendingIntent.FLAG_NO_CREATE
        )
        val enabled = loadConfig(context)?.enabled ?: false
        val scheduled = pendingIntent != null && enabled
        Log.d(TAG, "Reminder scheduled: $scheduled (pending=$pendingIntent, enabled=$enabled)")
        return scheduled
    }

    fun showTestNotification(
        context: Context,
        title: String?,
        body: String?
    ): Boolean {
        ensureNotificationChannel(context)
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                ?: return false

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title ?: "Quiz Reminder Test")
            .setContentText(body ?: "This is a test notification")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(
                    body ?: "This is a test notification"
                )
            )
            .build()

        notificationManager.notify(999, notification)
        Log.i(TAG, "Displayed test notification")
        return true
    }

    internal fun handleReminderTriggered(context: Context, intent: Intent) {
        val config = loadConfig(context)
        val hour = intent.getIntExtra(EXTRA_HOUR, config?.hour ?: -1)
        val minute = intent.getIntExtra(EXTRA_MINUTE, config?.minute ?: -1)
        val title = intent.getStringExtra(EXTRA_TITLE) ?: config?.title
        val body = intent.getStringExtra(EXTRA_BODY) ?: config?.body

        if (hour == -1 || minute == -1 || title.isNullOrBlank() || body.isNullOrBlank()) {
            Log.w(TAG, "Reminder triggered with incomplete data; skipping notification")
            return
        }

        showReminderNotification(context, title, body)

        // Schedule the next occurrence for the following day.
        scheduleReminder(context, hour, minute, title, body)
    }

    internal fun restoreReminder(context: Context) {
        val config = loadConfig(context)
        if (config?.enabled == true) {
            Log.i(TAG, "Restoring quiz reminder after reboot/update")
            scheduleReminder(
                context,
                config.hour,
                config.minute,
                config.title,
                config.body
            )
        } else {
            Log.d(TAG, "No reminder to restore (enabled=${config?.enabled})")
        }
    }

    private fun computeNextTriggerMillis(hour: Int, minute: Int): Long {
        val timeZone = TimeZone.getTimeZone("Europe/Rome")
        val calendar = Calendar.getInstance(timeZone, Locale.getDefault()).apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        if (calendar.timeInMillis <= System.currentTimeMillis()) {
            calendar.add(Calendar.DATE, 1)
        }
        return calendar.timeInMillis
    }

    private fun buildPendingIntent(
        context: Context,
        hour: Int,
        minute: Int,
        title: String,
        body: String,
        flag: Int
    ): PendingIntent? {
        val intent = Intent(context, QuizReminderReceiver::class.java).apply {
            action = ACTION_REMINDER
            putExtra(EXTRA_HOUR, hour)
            putExtra(EXTRA_MINUTE, minute)
            putExtra(EXTRA_TITLE, title)
            putExtra(EXTRA_BODY, body)
        }

        var flags = PendingIntent.FLAG_IMMUTABLE
        when (flag) {
            PendingIntent.FLAG_NO_CREATE -> flags = flags or PendingIntent.FLAG_NO_CREATE
            PendingIntent.FLAG_UPDATE_CURRENT -> flags = flags or PendingIntent.FLAG_UPDATE_CURRENT
        }

        return PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
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
                }
                notificationManager.createNotificationChannel(channel)
                Log.i(TAG, "Created notification channel $CHANNEL_ID")
            }
        }
    }

    private fun showReminderNotification(
        context: Context,
        title: String,
        body: String
    ) {
        ensureNotificationChannel(context)
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                ?: return

        val launchIntent = context.packageManager
            .getLaunchIntentForPackage(context.packageName)
            ?: Intent(context, MainActivity::class.java)
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)

        val contentIntent = PendingIntent.getActivity(
            context,
            0,
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

        notificationManager.notify(reminderNotificationId(), notification)
        Log.i(TAG, "Displayed reminder notification")
    }

    private fun reminderNotificationId(): Int = 1000

    private fun saveConfig(context: Context, config: ReminderConfig) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit()
            .putBoolean(KEY_ENABLED, true)
            .putInt(KEY_HOUR, config.hour)
            .putInt(KEY_MINUTE, config.minute)
            .putString(KEY_TITLE, config.title)
            .putString(KEY_BODY, config.body)
            .apply()
    }

    private fun clearConfig(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().clear().apply()
    }

    private fun loadConfig(context: Context): ReminderConfig? {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        if (!prefs.getBoolean(KEY_ENABLED, false)) {
            return ReminderConfig(enabled = false)
        }
        val title = prefs.getString(KEY_TITLE, null)
        val body = prefs.getString(KEY_BODY, null)
        val hour = prefs.getInt(KEY_HOUR, -1)
        val minute = prefs.getInt(KEY_MINUTE, -1)

        if (title.isNullOrBlank() || body.isNullOrBlank() || hour == -1 || minute == -1) {
            return ReminderConfig(enabled = false)
        }
        return ReminderConfig(
            hour = hour,
            minute = minute,
            title = title,
            body = body,
            enabled = true
        )
    }

    private fun formatMillis(millis: Long): String =
        java.text.SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
            .apply { timeZone = TimeZone.getTimeZone("Europe/Rome") }
            .format(millis)

    private data class ReminderConfig(
        val hour: Int = -1,
        val minute: Int = -1,
        val title: String = "",
        val body: String = "",
        val enabled: Boolean = false
    )
}
