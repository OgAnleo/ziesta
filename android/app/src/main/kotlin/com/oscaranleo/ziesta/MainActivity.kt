package com.oscaranleo.ziesta

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ziesta/audio")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "ping" -> result.success("pong")
                    "pauseMedia" -> result.success(MediaPauser.pause(this))
                    "scheduleTimer" -> {
                       val endMillis = call.argument<Number>("endMillis")?.toLong()
                        if (endMillis == null) {
                            result.error("INVALID", "Falta endMillis", null)
                        } else {
                            result.success(TimerScheduler.schedule(this, endMillis))
                        }
                    }
                    "cancelTimer" -> {
                        TimerScheduler.cancel(this)
                        result.success(null)
                    }
                    "canScheduleExact" -> result.success(TimerScheduler.canSchedule(this))
                    "openExactAlarmSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            startActivity(
                                Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM, Uri.parse("package:$packageName"))
                            )
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
