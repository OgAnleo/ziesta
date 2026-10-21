package com.oscaranleo.ziesta

import android.app.NotificationManager
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper

class FadeService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private var volumeReceiver: BroadcastReceiver? = null

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
        if (TimerStore.getVolumeExtend(this)) registerVolumeReceiver()
        handler.removeCallbacks(tick)
        handler.post(tick)
        return START_NOT_STICKY
    }

    private fun registerVolumeReceiver() {
        if (volumeReceiver != null) return
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val stream = intent.getIntExtra(EXTRA_STREAM_TYPE, -1)
                val value = intent.getIntExtra(EXTRA_STREAM_VALUE, -1)
                val previous = intent.getIntExtra(EXTRA_PREV_STREAM_VALUE, -1)
                if (stream != AudioManager.STREAM_MUSIC || value <= previous) return
                if (System.currentTimeMillis() < VolumeFader.ignoreIncreasesUntil) return
                TimerScheduler.extend(context)
            }
        }
        val filter = IntentFilter(VOLUME_CHANGED_ACTION)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(receiver, filter)
        }
        volumeReceiver = receiver
    }

    override fun onTimeout(startId: Int) {
        stopSelf()
    }

    override fun onDestroy() {
        volumeReceiver?.let { unregisterReceiver(it) }
        volumeReceiver = null
        handler.removeCallbacksAndMessages(null)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        private const val STEP_MILLIS = 1_000L
        private const val VOLUME_CHANGED_ACTION = "android.media.VOLUME_CHANGED_ACTION"
        private const val EXTRA_STREAM_TYPE = "android.media.EXTRA_VOLUME_STREAM_TYPE"
        private const val EXTRA_STREAM_VALUE = "android.media.EXTRA_VOLUME_STREAM_VALUE"
        private const val EXTRA_PREV_STREAM_VALUE =
            "android.media.EXTRA_PREV_VOLUME_STREAM_VALUE"
    }
}