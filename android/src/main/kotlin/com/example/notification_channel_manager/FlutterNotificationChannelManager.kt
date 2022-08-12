package com.example.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

@SuppressLint("NewApi")
class FlutterNotificationChannelManager(
    private val notificationManager: NotificationManager
) {


    fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.O) result.success(null)

        when (call.method) {
            "getNotificationChannels" -> {
                result.success(getNotificationChannels())
            }
            "createNotificationChannel" -> {
                val args = call.arguments as Map<String, Any>
                var nc = notificationChannelFromMap(args)
                notificationManager.createNotificationChannel(nc)
                nc = getNotificationChannel(nc.id)
                result.success(nc.toMap())
            }
            "createNotificationChannels" -> {
                val args = call.arguments as List<Map<String, Any>>
                val ncs = args.map { notificationChannelFromMap(it) }
                notificationManager.createNotificationChannels(ncs)
                result.success(getNotificationChannels())
            }
            "createNotificationChannelGroup" -> {
                val args = call.arguments as Map<String, Any>
                var ncg = notificationChannelGroupFromMap(args)
                notificationManager.createNotificationChannelGroup(ncg)
                ncg = notificationManager.getNotificationChannelGroup(ncg.id)
                result.success(ncg.toMap())

            }
            "createNotificationChannelGroups" -> {
                val args = call.arguments as List<Map<String, Any>>
                var ncgs = args.map { notificationChannelGroupFromMap(it) }
                notificationManager.createNotificationChannelGroups(ncgs)
                ncgs = notificationManager.notificationChannelGroups
                
                result.success(ncgs.map { it.toMap() })
            }
            "deleteChannel" -> {
                val id: String = call.argument<String>("id")!!
                notificationManager.deleteNotificationChannel(id)
                result.success(null)
            }
            "deleteMultiChannels" -> {
                try {
                    val ids: List<String> = call.argument<List<String>>("ids")!!
                    ids.forEach {
                        notificationManager.deleteNotificationChannel(it)
                    }
                    result.success(null)
                } catch (e: Exception) {
                    result.error("deleteNotificationChannels", e.message, e.stackTrace)

                }
            }
            "deleteChannelGroup" -> {
                val id: String = call.argument<String>("id")!!
                notificationManager.deleteNotificationChannelGroup(id)
                result.success(null)
            }
            "deleteMultiChannelGroups" -> {
                try {

                    val ids: List<String> = call.argument<List<String>>("ids")!!
                    ids.forEach {
                        notificationManager.deleteNotificationChannelGroup(it)
                    }
                    result.success(null)
                } catch (e: Exception) {
                    result.error("deleteNotificationChannelGroups", e.message, e.stackTrace)

                }
            }
            else -> result.notImplemented()
        }

    }

    private fun getNotificationChannel(id: String?): NotificationChannel {
        return notificationManager.getNotificationChannel(id)
    }

    private fun getNotificationChannels(): Map<String, Any> {
        val channels = notificationManager.notificationChannels
        val map = HashMap<String, Any>()
        channels.forEach {
            map[it.id] = it.toMap()
        }
        return map
    }
}