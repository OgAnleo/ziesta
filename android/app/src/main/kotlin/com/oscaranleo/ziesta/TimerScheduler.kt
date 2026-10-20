package com.oscaranleo.ziesta

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build

object TimerScheduler {
    private fun pending(context: Context): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            0,
            Intent(context, TimerReceiver::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

    private fun alarmManager(context: Context): AlarmManager =
        context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    fun canSchedule(context: Context): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.S ||
            alarmManager(context).canScheduleExactAlarms()

    fun schedule(context: Context, endMillis: Long): Boolean {
        if (!canSchedule(context)) return false
        alarmManager(context).setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            endMillis,
            pending(context)
        )
        return true
    }

    fun cancel(context: Context) {
        alarmManager(context).cancel(pending(context))
    }
}