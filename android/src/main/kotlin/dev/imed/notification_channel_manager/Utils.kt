package dev.imed.notification_channel_manager

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build


@SuppressLint("NewApi")
fun NotificationChannel.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "description" to description,
        "importance" to importance,
        "groupId" to group,
        "parentChannelId" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) parentChannelId else null,
        "conversationId" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) conversationId else null,
        "canBypassDnd" to canBypassDnd(),
        "canShowBadge" to canShowBadge(),
        "shouldShowLights" to shouldShowLights(),
        "shouldVibrate" to shouldVibrate(),
        "allowBubbles" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) canBubble() else false,
        "hasUserSetImportance" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) hasUserSetImportance() else false,
        "hasUserSetSound" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) hasUserSetSound() else false,
        "isBlockable" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) isBlockable else false,
        "isConversation" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) isConversation
        else (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && conversationId != null),
        "isImportantConversation" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) isImportantConversation else false,
        "isDemoted" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) isDemoted else false,
        // mask to unsigned 32-bit so both sides compare the same positive value
        "lightColor" to (lightColor.toLong() and 0xFFFFFFFF),
        "sound" to sound?.toString(),
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
    if (map["parentChannelId"] != null && map["conversationId"] != null &&
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
    ) {
        channel.setConversationId(
            map["parentChannelId"] as String,
            map["conversationId"] as String,
        )
    }
    if (map["canBypassDnd"] != null) {
        channel.setBypassDnd(map["canBypassDnd"] as Boolean)
    }
    if (map["allowBubbles"] != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        channel.setAllowBubbles(map["allowBubbles"] as Boolean)
    }
    if (map["canShowBadge"] != null) {
        channel.setShowBadge(map["canShowBadge"] as Boolean)
    }
    if (map["shouldShowLights"] != null) {
        channel.enableLights(map["shouldShowLights"] as Boolean)
        if (map["lightColor"] != null) {
            channel.lightColor = (map["lightColor"] as Number).toLong().toInt()
        }
    }
    if (map["shouldVibrate"] != null) {
        channel.enableVibration(map["shouldVibrate"] as Boolean)
        if (map["vibrationPattern"] != null) {
            val vibration = map["vibrationPattern"] as ArrayList<Long>
            channel.vibrationPattern = vibration.toLongArray()
        }
    }

    if (map["sound"] != null) {
        channel.setSound(Uri.parse(map["sound"] as String), AudioAttributes.Builder().build())
    }


    return channel
}

@SuppressLint("NewApi")
fun NotificationChannelGroup.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        // NotificationChannelGroup.getDescription() and isBlocked() require API 28
        "description" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) description else null,
        "isBlocked" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) isBlocked else false,
        "channels" to channels.map { it.toMap() }
    )
}

@SuppressLint("NewApi")
fun notificationChannelGroupFromMap(map: Map<String, Any?>): NotificationChannelGroup {

    val group = NotificationChannelGroup(
        map["id"] as String,
        map["name"] as String,

        )
    if (map["description"] != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        group.description = map["description"] as String
    }
    return group
}