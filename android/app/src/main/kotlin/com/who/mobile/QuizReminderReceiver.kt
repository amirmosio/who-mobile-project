package com.who.mobile

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class QuizReminderReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent == null) {
            Log.w(TAG, "Received null intent; ignoring reminder broadcast")
            return
        }

        Log.i(TAG, "Quiz reminder broadcast received: ${intent.action}")

        QuizReminderScheduler.handleReminderTriggered(
            context.applicationContext,
            intent
        )
    }

    companion object {
        private const val TAG = "QuizReminderReceiver"
    }
}
