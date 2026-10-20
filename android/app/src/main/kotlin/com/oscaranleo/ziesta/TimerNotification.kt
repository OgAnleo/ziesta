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

    private const val FLAGS =
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

    fun show(context: Context, endMillis: Long) {
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

        val notification = Notification.Builder(context, CHANNEL_ID)
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
            .addAction(action(context, R.string.action_extend, 2, ExtendReceiver::class.java))
            .addAction(action(context, R.string.action_cancel, 3, CancelReceiver::class.java))
            .build()

        manager.notify(NOTIFICATION_ID, notification)
    }

    fun hide(context: Context) {
        context.getSystemService(NotificationManager::class.java)
            .cancel(NOTIFICATION_ID)
    }

    private fun action(
        context: Context,
        titleRes: Int,
        requestCode: Int,
        receiver: Class<*>
    ): Notification.Action {
        val intent = PendingIntent.getBroadcast(
            context, requestCode, Intent(context, receiver), FLAGS
        )
        return Notification.Action.Builder(
            Icon.createWithResource(context, R.drawable.ic_stat_moon),
            context.getString(titleRes),
            intent
        ).build()
    }
}