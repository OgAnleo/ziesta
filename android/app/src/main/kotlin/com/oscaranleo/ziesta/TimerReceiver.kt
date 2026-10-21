package com.oscaranleo.ziesta

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper

class TimerReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val pending = goAsync()

        MediaPauser.pause(context)
        LockController.lockIfEnabled(context)
        TimerStore.clear(context)
        context.stopService(Intent(context, FadeService::class.java))
        TimerNotification.hide(context)

        Handler(Looper.getMainLooper()).postDelayed({
            VolumeFader.restore(context)
            pending.finish()
        }, 1_500L)
    }
}