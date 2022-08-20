package dev.imed.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
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
        "canBypassDnd" to canBypassDnd(),
        "canShowBadge" to canShowBadge(),
        "enableLights" to shouldShowLights(),
        "shouldVibrate" to shouldVibrate(),
        "lightColor" to lightColor,
        "sound" to sound.toString(),
        "vibrationPattern" to vibrationPattern,
        "enableBadge" to canShowBadge(),
    )
}
@SuppressLint("NewApi")
fun notificationChannelFromMap(map: Map<String, Any?>): NotificationChannel {
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
    if(map["canBypassDnd"] != null) {
        channel.setBypassDnd(  map["canBypassDnd"] as Boolean)
    }
    if(map["canShowBadge"] != null) {
        channel.setShowBadge(  map["canShowBadge"] as Boolean)
    }
    if(map["enableLights"] != null) {
        channel.enableLights(  map["enableLights"] as Boolean)
    }
    if(map["shouldVibrate"] != null) {
        channel.enableVibration(  map["shouldVibrate"] as Boolean)
    }
    if(map["lightColor"] != null) {
        channel.lightColor = map["lightColor"] as Int
    }
    if(map["sound"] != null) {
        channel.setSound(Uri.parse(map["sound"] as String), AudioAttributes.Builder().build())
    }
    if(map["vibrationPattern"] != null) {
        channel.vibrationPattern = map["vibrationPattern"] as LongArray
    }
    if(map["enableBadge"] != null) {
        channel.setShowBadge(  map["enableBadge"] as Boolean)
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
    if(map["description"] != null) {
        group.description = map["description"] as String
    }
    return group
}