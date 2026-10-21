package com.oscaranleo.ziesta

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ziesta/audio")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleTimer" -> {
                        val endMillis = call.argument<Number>("endMillis")?.toLong()
                        if (endMillis == null) {
                            result.error("INVALID", "Missing endMillis", null)
                        } else {
                            result.success(TimerScheduler.schedule(this, endMillis))
                        }
                    }
                    "cancelTimer" -> {
                        TimerScheduler.cancel(this)
                        result.success(null)
                    }
                    "getEnd" -> result.success(
                        TimerStore.getEnd(this)?.takeIf { it > System.currentTimeMillis() }
                    )
                    "openExactAlarmSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                                    Uri.parse("package:$packageName")
                                )
                            )
                        }
                        result.success(null)
                    }
                    "requestNotificationPermission" -> {
                        val needsRequest =
                            Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                                checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
                                PackageManager.PERMISSION_GRANTED
                        if (needsRequest) {
                            permissionResult = result
                            requestPermissions(
                                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                                NOTIFICATION_REQUEST
                            )
                        } else {
                            result.success(true)
                        }
                    }
                    "shareText" -> {
                        val text = call.argument<String>("text")
                        if (text == null) {
                            result.error("INVALID", "Missing text", null)
                        } else {
                            val send = Intent(Intent.ACTION_SEND).apply {
                                type = "text/plain"
                                putExtra(Intent.EXTRA_TEXT, text)
                            }
                            startActivity(Intent.createChooser(send, null))
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == NOTIFICATION_REQUEST) {
            permissionResult?.success(
                grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
            )
            permissionResult = null
        }
    }

    companion object {
        private const val NOTIFICATION_REQUEST = 1001
    }
}