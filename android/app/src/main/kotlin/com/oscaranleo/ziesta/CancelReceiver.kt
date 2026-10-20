package com.oscaranleo.ziesta

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class CancelReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        TimerScheduler.cancel(context)
    }
}