package com.oscaranleo.ziesta

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build

object TimerScheduler {
    const val FADE_MILLIS = 60_000L

    private const val FLAGS =
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

    private fun endIntent(context: Context): PendingIntent =
        PendingIntent.getBroadcast(
            context, 0, Intent(context, TimerReceiver::class.java), FLAGS
        )

    private fun fadeIntent(context: Context): PendingIntent =
        PendingIntent.getForegroundService(
            context, 1, Intent(context, FadeService::class.java), FLAGS
        )

    private fun alarmManager(context: Context): AlarmManager =
        context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    private fun stopFade(context: Context) {
        context.stopService(Intent(context, FadeService::class.java))
        VolumeFader.restore(context)
    }

    fun canSchedule(context: Context): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.S ||
            alarmManager(context).canScheduleExactAlarms()

    fun schedule(context: Context, endMillis: Long): Boolean {
        if (!canSchedule(context)) return false
        stopFade(context)
        val alarms = alarmManager(context)

        alarms.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP, endMillis, endIntent(context)
        )

        val fadeAt = endMillis - FADE_MILLIS
        if (fadeAt > System.currentTimeMillis()) {
            alarms.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP, fadeAt, fadeIntent(context)
            )
        } else {
            alarms.cancel(fadeIntent(context))
        }

        TimerStore.saveEnd(context, endMillis)
        TimerNotification.show(context, endMillis)
        return true
    }

    fun extend(context: Context): Long? {
        val end = TimerStore.getEnd(context) ?: return null
        if (end <= System.currentTimeMillis()) return null
        val newEnd = end + TimerStore.getExtendMinutes(context) * 60_000L
        return if (schedule(context, newEnd)) newEnd else null
    }

    fun cancel(context: Context) {
        stopFade(context)
        val alarms = alarmManager(context)
        alarms.cancel(endIntent(context))
        alarms.cancel(fadeIntent(context))
        TimerStore.clear(context)
        TimerNotification.hide(context)
    }
}