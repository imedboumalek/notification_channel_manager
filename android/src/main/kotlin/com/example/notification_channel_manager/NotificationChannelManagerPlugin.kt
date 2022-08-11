package com.example.notification_channel_manager

import android.app.NotificationManager
import android.content.Context.NOTIFICATION_SERVICE
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class NotificationChannelManagerPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var fNotificationChannelManager: FlutterNotificationChannelManager


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "notification_channel_manager")
        channel.setMethodCallHandler(this)

        fNotificationChannelManager = FlutterNotificationChannelManager(
            flutterPluginBinding.applicationContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        )

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.O) return
        fNotificationChannelManager.handleCall(call, result)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
    
}