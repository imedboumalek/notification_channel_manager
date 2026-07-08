package dev.imed.notification_channel_manager_example

import android.Manifest
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Person
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Example-local channel for posting test notifications; posting is out of
// scope for the plugin itself, which only manages channels.
class MainActivity : FlutterActivity() {
    private var notificationId = 0

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "notification_channel_manager_example/notifier",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendTestNotification" -> {
                    if (!notificationsReady()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val args = call.arguments as Map<*, *>
                    val notification = Notification.Builder(this, args["channelId"] as String)
                        .setSmallIcon(android.R.drawable.ic_dialog_info)
                        .setContentTitle(args["title"] as String)
                        .setContentText(args["body"] as String)
                        .build()
                    notificationManager().notify(notificationId++, notification)
                    result.success(true)
                }
                "sendTestBubbleNotification" -> {
                    // Bubbles require conversation notifications, which need
                    // shortcuts introduced with conversations in API 30.
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R || !notificationsReady()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val channelId = (call.arguments as Map<*, *>)["channelId"] as String
                    result.success(sendBubble(channelId))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun notificationManager() =
        getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    // Requests the POST_NOTIFICATIONS permission when missing (API 33+) and
    // reports whether a notification can be posted right now.
    private fun notificationsReady(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1)
            return false
        }
        return true
    }

    private fun sendBubble(channelId: String): Boolean {
        // A bubble must be a conversation notification: MessagingStyle, tied
        // to a published long-lived shortcut. Reuse the channel's
        // conversation id as the shortcut id when it has one.
        val shortcutId = notificationManager().getNotificationChannel(channelId)
            ?.conversationId ?: "bubble_demo_$channelId"

        val person = Person.Builder().setName("Bubble Bot").setImportant(true).build()
        val icon = Icon.createWithResource(this, R.mipmap.ic_launcher)

        val shortcut = ShortcutInfo.Builder(this, shortcutId)
            .setShortLabel("Bubble Bot")
            .setLongLived(true)
            .setIcon(icon)
            .setPerson(person)
            .setIntent(Intent(this, MainActivity::class.java).setAction(Intent.ACTION_VIEW))
            .build()
        getSystemService(ShortcutManager::class.java).pushDynamicShortcut(shortcut)

        val bubbleIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, BubbleActivity::class.java),
            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val bubbleMetadata = Notification.BubbleMetadata.Builder(bubbleIntent, icon)
            .setDesiredHeight(600)
            .build()

        val style = Notification.MessagingStyle(person)
            .addMessage(
                "Pop! This is a test bubble 🫧",
                System.currentTimeMillis(),
                person,
            )

        val notification = Notification.Builder(this, channelId)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setShortcutId(shortcutId)
            .setBubbleMetadata(bubbleMetadata)
            .setStyle(style)
            .build()
        notificationManager().notify(notificationId++, notification)
        return true
    }
}
