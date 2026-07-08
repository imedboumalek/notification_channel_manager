package dev.imed.notification_channel_manager_example

import android.Manifest
import android.app.Notification
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
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
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                        checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
                        PackageManager.PERMISSION_GRANTED
                    ) {
                        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1)
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val args = call.arguments as Map<*, *>
                    val notification = Notification.Builder(this, args["channelId"] as String)
                        .setSmallIcon(android.R.drawable.ic_dialog_info)
                        .setContentTitle(args["title"] as String)
                        .setContentText(args["body"] as String)
                        .build()
                    val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    manager.notify(notificationId++, notification)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
