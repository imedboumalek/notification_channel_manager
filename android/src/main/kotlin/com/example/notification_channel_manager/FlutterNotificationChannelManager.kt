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
            "deleteNotificationChannel" -> {
                val id: String = call.argument<String>("id")!!
                notificationManager.deleteNotificationChannel(id)
                result.success(null)
            }
            "deleteNotificationChannels" -> {
                val ids: List<String> = call.argument<List<String>>("ids")!!
                ids.forEach {
                    notificationManager.deleteNotificationChannel(it)
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }

    }
}