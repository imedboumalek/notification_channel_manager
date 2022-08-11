package com.example.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterNotificationChannelManager(
    private val notificationManager: NotificationManager
) {


    @SuppressLint("NewApi")
    fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getNotificationChannel" -> {
                notificationManager.getNotificationChannel(call.argument<String>("channelId"))
                    ?.let {
                        result.success(it)
                    } ?: result.error("NOT_FOUND", "Notification channel not found", null,)

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