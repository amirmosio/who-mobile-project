package com.who.mobile

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class QuizReminderBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent?.action
        Log.i(TAG, "Boot receiver triggered with action=$action")

        when (action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                QuizReminderScheduler.restoreReminder(context.applicationContext)
            }

            else -> Log.d(TAG, "Ignoring action=$action")
        }
    }

    companion object {
        private const val TAG = "QuizReminderBootReceiver"
    }
}
