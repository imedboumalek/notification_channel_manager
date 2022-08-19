package dev.imed.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
import android.media.AudioAttributes
import android.net.Uri


@SuppressLint("NewApi")
 fun NotificationChannel.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "name" to name,
        "description" to description,
        "importance" to importance,
        "groupId" to group,
        "enableVibration" to shouldVibrate(),
        "vibrationPattern" to vibrationPattern,
        "enableLights" to shouldShowLights(),
        "lightColor" to lightColor,
        "sound" to sound.toString(),
        "enableBadge" to canShowBadge(),
    )
}
@SuppressLint("NewApi")
fun notificationChannelFromMap(map: Map<String, Any>): NotificationChannel {
    val  channel=  NotificationChannel(
        map["id"] as String,
        map["name"] as String,
        map["importance"] as Int,
    )
    if(map["description"] != null) {
        channel.description = map["description"] as String
    }
    if(map["groupId"] != null) {
        channel.group = map["groupId"] as String
    }
    if(map["enableVibration"] != null) {
        channel.enableVibration(map["enableVibration"] as Boolean)
    }
    if(map["vibrationPattern"] != null) {
        channel.vibrationPattern = map["vibrationPattern"] as LongArray
    }
    if(map["enableLights"] != null) {
        channel.enableLights(map["enableLights"] as Boolean)
    }
    if(map["lightColor"] != null) {
        channel.lightColor = map["lightColor"] as Int
    }
    if (map["sound"] != null) {
        val soundUri = Uri.parse(map["sound"] as String)
        channel.setSound(soundUri, AudioAttributes.Builder().build())
    }
    if(map["enableBadge"] != null) {
        channel.setShowBadge(map["enableBadge"] as Boolean)
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
fun notificationChannelGroupFromMap(map: Map<String, Any>): NotificationChannelGroup {

    val group = NotificationChannelGroup(
        map["id"] as String,
        map["name"] as String,

    )
    if(map["description"] != null) {
        group.description = map["description"] as String
    }
    return group
}