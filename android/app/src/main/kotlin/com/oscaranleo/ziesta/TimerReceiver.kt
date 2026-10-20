package com.oscaranleo.ziesta

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class TimerReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        MediaPauser.pause(context)
        MediaPauser.pause(context)
        TimerStore.clear(context)
        TimerNotification.hide(context)
    }
}