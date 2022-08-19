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
            // channels
            "getChannels" -> {
                result.success(getNotificationChannels())
            }
            "getChannel" -> {
                val channelId = call.argument as String
                result.success(getNotificationChannelById(channelId))
            }
            "createChannel" -> {
                val args = call.arguments as Map<String, Any>
                var nc = notificationChannelFromMap(args)
                notificationManager.createNotificationChannel(nc)
                nc = getNotificationChannel(nc.id)
                result.success(nc.toMap())
            }
            "createChannels" -> {
                val args = call.arguments as List<Map<String, Any>>
                val ncs = args.map { notificationChannelFromMap(it) }
                notificationManager.createNotificationChannels(ncs)
                result.success(getNotificationChannels())
            }

            "deleteChannel" -> {
                val id: String = call.argument<String>("id")!!
                notificationManager.deleteNotificationChannel(id)
                result.success(null)
            }
            "deleteChannels" -> {
                
                    val ids: List<String> = call.argument<List<String>>("ids")!!
                    ids.forEach {
                        notificationManager.deleteNotificationChannel(it)
                    }
                    result.success(null)
               
            }
            "getGroups" -> {
                // TODO
            }
            "getGroup" -> {
                // TODO
            }
            // Groups
            "createGroup" -> {
                val args = call.arguments as Map<String, Any>
                var ncg = notificationChannelGroupFromMap(args)
                notificationManager.createNotificationChannelGroup(ncg)
                ncg = notificationManager.getNotificationChannelGroup(ncg.id)
                result.success(ncg.toMap())

            }
            "createGroups" -> {
                val args = call.arguments as List<Map<String, Any>>
                var ncgs = args.map { notificationChannelGroupFromMap(it) }
                notificationManager.createNotificationChannelGroups(ncgs)
                ncgs = notificationManager.notificationChannelGroups
                result.success(ncgs.map { it.toMap() })
            }
            "deleteGroup" -> {
                val id: String = call.argument<String>("id")!!
                notificationManager.deleteNotificationChannelGroup(id)
                result.success(null)
            }
            "deleteGroups" -> {
               
                    val ids: List<String> = call.argument<List<String>>("ids")!!
                    ids.forEach {
                        notificationManager.deleteNotificationChannelGroup(it)
                    }
                    result.success(null)
               
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