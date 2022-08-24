package dev.imed.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
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
                val id = call.arguments as String
                val ch = getNotificationChannel(id)
                result.success(ch?.toMap())
            }
            "createChannel" -> {
                val args = call.arguments as Map<String, Any?>
                val nc = createNotificationChannel(args)
                result.success(nc.toMap())
            }
            "createChannels" -> {
                val args = call.arguments as List<Map<String, Any?>>
                val ncs = args.map { createNotificationChannel(it) }

                result.success(ncs.map { it.toMap() })
            }
            "deleteChannel" -> {
                val id: String = call.arguments as String
                notificationManager.deleteNotificationChannel(id)
                result.success(null)
            }
            "deleteChannels" -> {
                val ids: List<String> = call.arguments as List<String>
                ids.forEach {
                    notificationManager.deleteNotificationChannel(it)
                }
                result.success(null)

            }
            "deleteAllChannels" -> {
            notificationManager.notificationChannels.forEach {
                notificationManager.deleteNotificationChannel(it.id)
            }
                result.success(null)
            }
            // Groups
            "getGroups" -> {
                val groups = notificationManager.notificationChannelGroups
                result.success(groups.map { it.toMap() })
            }
            "getGroup" -> {
                val id = call.arguments as String
                val group = getNotificationChannelGroup(id)
                result.success(group?.toMap())
            }
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
                ncgs = notificationManager.notificationChannelGroups.filter { ncgs.any( { item->  item.id == it.id }) }
                result.success(ncgs.map { it.toMap() })
            }
            "deleteGroup" -> {
                val id: String = call.arguments as String
                notificationManager.deleteNotificationChannelGroup(id)
                result.success(null)
            }
            "deleteGroups" -> {

                val ids: List<String> = call.arguments as List<String>
                ids.forEach {
                    notificationManager.deleteNotificationChannelGroup(it)
                }
                result.success(null)

            }
            "deleteAllGroups" -> {
                notificationManager.notificationChannelGroups.forEach {
                    notificationManager.deleteNotificationChannelGroup(it.id)
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }

    }

    private fun getNotificationChannel(id: String): NotificationChannel? {
        return try {
            notificationManager.getNotificationChannel(id)
        } catch (e: Exception) {
            null
        }
    }

    private fun getNotificationChannels(): List<Map<String, Any?>> {
        val channels = notificationManager.notificationChannels
        val list = ArrayList<Map<String, Any?>>()
        channels.forEach {
            list.add(it.toMap())
        }
        return list
    }

    private fun getNotificationChannelGroup(id: String): NotificationChannelGroup? {
        return try {
            notificationManager.getNotificationChannelGroup(id)
        } catch (e: Exception) {
            null
        }
    }


    private fun createNotificationChannel(args: Map<String, Any?>): NotificationChannel {
        val nc = notificationChannelFromMap(args)
        if (nc.group != null) {
            val g = getNotificationChannelGroup(nc.group!!)
            if (g == null) {
                notificationManager.createNotificationChannelGroup(
                    NotificationChannelGroup(
                        nc.group,
                        nc.group
                    )
                )
            }
        }
        notificationManager.createNotificationChannel(nc)
        return notificationManager.getNotificationChannel(nc.id)!!
    }
}