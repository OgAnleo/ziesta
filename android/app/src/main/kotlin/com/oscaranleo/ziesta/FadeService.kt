package com.oscaranleo.ziesta

import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper

class FadeService : Service() {
    private val handler = Handler(Looper.getMainLooper())

    private val tick = object : Runnable {
        override fun run() {
            val end = TimerStore.getEnd(this@FadeService)
            if (end == null) {
                stopSelf()
                return
            }
            val start = end - TimerScheduler.FADE_MILLIS
            val progress = ((System.currentTimeMillis() - start).toFloat() /
                TimerScheduler.FADE_MILLIS).coerceIn(0f, 1f)
            VolumeFader.setProgress(this@FadeService, progress)
            if (progress < 1f) {
                handler.postDelayed(this, STEP_MILLIS)
            } else {
                stopSelf()
            }
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val storedEnd = TimerStore.getEnd(this)
        val end = storedEnd ?: System.currentTimeMillis()

        getSystemService(NotificationManager::class.java)
            .cancel(TimerNotification.NOTIFICATION_ID)
        val notification = TimerNotification.build(this, end)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                TimerNotification.FADE_NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SHORT_SERVICE
            )
        } else {
            startForeground(TimerNotification.FADE_NOTIFICATION_ID, notification)
        }

        if (storedEnd == null) {
            stopSelf()
            return START_NOT_STICKY
        }

        VolumeFader.begin(this)
        handler.removeCallbacks(tick)
        handler.post(tick)
        return START_NOT_STICKY
    }

    override fun onTimeout(startId: Int) {
        stopSelf()
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        private const val STEP_MILLIS = 1_000L
    }
}