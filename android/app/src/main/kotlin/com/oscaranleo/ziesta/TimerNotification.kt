package com.oscaranleo.ziesta

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.drawable.Icon

object TimerNotification {
    private const val CHANNEL_ID = "ziesta_timer"
    private const val OLD_CHANNEL_ID = "ziesta_warning"
    const val NOTIFICATION_ID = 1
    const val FADE_NOTIFICATION_ID = 2

    private const val FLAGS =
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

    fun build(context: Context, endMillis: Long): Notification {
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.deleteNotificationChannel(OLD_CHANNEL_ID)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                context.getString(R.string.channel_name),
                NotificationManager.IMPORTANCE_LOW
            )
        )

        val openApp = PendingIntent.getActivity(
            context, 0, Intent(context, MainActivity::class.java), FLAGS
        )

        val extendLabel = context.getString(
            R.string.action_extend, TimerStore.getExtendMinutes(context)
        )

        return Notification.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_moon)
            .setContentTitle(context.getString(R.string.notification_title))
            .setContentText(context.getString(R.string.notification_text))
            .setWhen(endMillis)
            .setUsesChronometer(true)
            .setChronometerCountDown(true)
            .setShowWhen(true)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setContentIntent(openApp)
            .addAction(action(context, extendLabel, 2, ExtendReceiver::class.java))
            .addAction(action(context, context.getString(R.string.action_cancel), 3, CancelReceiver::class.java))
            .build()
    }

    fun show(context: Context, endMillis: Long) {
        context.getSystemService(NotificationManager::class.java)
            .notify(NOTIFICATION_ID, build(context, endMillis))
    }

    fun hide(context: Context) {
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.cancel(NOTIFICATION_ID)
        manager.cancel(FADE_NOTIFICATION_ID)
    }

    private fun action(
        context: Context,
        title: String,
        requestCode: Int,
        receiver: Class<*>
    ): Notification.Action {
        val intent = PendingIntent.getBroadcast(
            context, requestCode, Intent(context, receiver), FLAGS
        )
        return Notification.Action.Builder(
            Icon.createWithResource(context, R.drawable.ic_stat_moon),
            title,
            intent
        ).build()
    }
}