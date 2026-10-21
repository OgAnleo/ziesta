package com.oscaranleo.ziesta

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class ExtendReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        TimerScheduler.extend(context)
    }
}