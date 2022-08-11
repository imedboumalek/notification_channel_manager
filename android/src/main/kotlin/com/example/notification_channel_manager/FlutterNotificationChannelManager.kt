package com.example.notification_channel_manager

import android.app.NotificationManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterNotificationChannelManager {

    fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getNotificationChannel" -> {

            }
            "createNotificationChannel" -> {

                result.success(null)
            }
            "deleteNotificationChannel" -> {

                result.success(null)
            }
            "deleteNotificationChannels" -> {
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }
}