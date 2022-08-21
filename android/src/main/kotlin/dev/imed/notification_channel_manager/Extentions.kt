package dev.imed.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
import android.graphics.Color
import android.media.AudioAttributes
import android.net.Uri


@SuppressLint("NewApi")
fun NotificationChannel.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "description" to description,
        "importance" to importance,
        "groupId" to group,
       // "canBypassDnd" to canBypassDnd(),
        "canShowBadge" to canShowBadge(),
        "shouldShowLights" to shouldShowLights(),
        "shouldVibrate" to shouldVibrate(),
        "lightColor" to lightColor,
        "sound" to sound.toString(),
        "vibrationPattern" to vibrationPattern?.toList(),

        )
}

@SuppressLint("NewApi")
fun notificationChannelFromMap(map: Map<String, Any?>): NotificationChannel {
    val channel = NotificationChannel(
        map["id"] as String,
        map["name"] as String,
        map["importance"] as Int,
    )
    if (map["description"] != null) {
        channel.description = map["description"] as String
    }
    if (map["groupId"] != null) {
        channel.group = map["groupId"] as String
    }
  //  if (map["canBypassDnd"] != null) {
  //      channel.setBypassDnd(map["canBypassDnd"] as Boolean)
  //  }
    if (map["canShowBadge"] != null) {
        channel.setShowBadge(map["canShowBadge"] as Boolean)
    }
    if (map["shouldShowLights"] != null) {
        channel.enableLights(map["shouldShowLights"] as Boolean)
        if (map["lightColor"] != null) {
            val color =map["lightColor"] as Long

            channel.lightColor = Color.valueOf(color).toArgb()
        }
    }
    if (map["shouldVibrate"] != null) {
        channel.enableVibration(map["shouldVibrate"] as Boolean)
        if (map["vibrationPattern"] != null) {
            val vibration= map["vibrationPattern"] as ArrayList<Long>
            channel.vibrationPattern= vibration.toLongArray()
        }
    }

    if (map["sound"] != null) {
        channel.setSound(Uri.parse(map["sound"] as String), AudioAttributes.Builder().build())
    }


    return channel
}

@SuppressLint("NewApi")
fun NotificationChannelGroup.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "name" to name,
        "description" to description,
        "channels" to channels.map { it.toMap() }
    )
}

@SuppressLint("NewApi")
fun notificationChannelGroupFromMap(map: Map<String, Any?>): NotificationChannelGroup {

    val group = NotificationChannelGroup(
        map["id"] as String,
        map["name"] as String,

        )
    if (map["description"] != null) {
        group.description = map["description"] as String
    }
    return group
}