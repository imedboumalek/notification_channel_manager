import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:notification_channel_manager/src/notification_channel_group.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';

import 'notification_channel_manager_platform_interface.dart';

/// An implementation of [NotificationChannelManagerPlatform] that uses method channels.
class MethodChannelNotificationChannelManager implements NotificationChannelManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('notification_channel_manager');

  @override
  Future<List<NotificationChannelGroup>> getNotificationChannelGroups() {
    return methodChannel.invokeMethod('getNotificationChannelGroups').then((result) {
      return result
          .map<NotificationChannelGroup>((json) => NotificationChannelGroup.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<NotificationChannel>> getNotificationChannels() {
    return methodChannel.invokeMethod('getNotificationChannels').then((result) {
      return result.map<NotificationChannel>((json) => NotificationChannel.fromJson(json)).toList();
    });
  }

  @override
  Future<bool> initialize() {
    return methodChannel.invokeMethod('initialize') as Future<bool>;
  }
}
