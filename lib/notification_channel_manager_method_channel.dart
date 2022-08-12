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
  Future<void> deleteChannel(String channelId) {
    return methodChannel.invokeMethod('deleteChannel', channelId);
  }

  @override
  Future<void> deleteChannelGroup(String channelGroupId) {
    return methodChannel.invokeMethod('deleteChannelGroup', channelGroupId);
  }

  @override
  Future<void> deleteMultiChannelGroups(List<String> channelGroupIds) {
    return methodChannel.invokeMethod('deleteMultiChannelGroups', channelGroupIds);
  }

  @override
  Future<void> deleteMutliChannels(List<String> channelIds) {
    return methodChannel.invokeMethod('deleteMultiChannels', channelIds);
  }

  @override
  Future<List<NotificationChannelGroup>> getAllChannelGroups() {
    return methodChannel.invokeMethod('getAllChannelGroups').then((result) {
      return result
          .map<NotificationChannelGroup>((json) => NotificationChannelGroup.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<NotificationChannel>> getAllChannels() {
    return methodChannel.invokeMethod('getAllChannels').then((result) {
      return result.map<NotificationChannel>((json) => NotificationChannel.fromJson(json)).toList();
    });
  }

  @override
  Future<NotificationChannel> getChannelById(String channelId) {
    return methodChannel.invokeMethod('getChannelById', channelId).then((result) {
      return NotificationChannel.fromJson(result);
    });
  }

  @override
  Future<List<NotificationChannel>> getMultiChannelsByIds(List<String> channelIds) {
    return methodChannel.invokeMethod('getMultiChannelsByIds', channelIds).then((result) {
      return result.map<NotificationChannel>((json) => NotificationChannel.fromJson(json)).toList();
    });
  }

  @override
  Future<NotificationChannel> upsertNotificationChannel(NotificationChannel notificationChannel) {
    return methodChannel
        .invokeMethod('upsertNotificationChannel', notificationChannel.toJson())
        .then((result) {
      return NotificationChannel.fromJson(result);
    });
  }

  @override
  Future<NotificationChannelGroup> upsertNotificationChannelGroup(
    NotificationChannelGroup notificationChannelGroup,
  ) {
    return methodChannel
        .invokeMethod('upsertNotificationChannelGroup', notificationChannelGroup.toJson())
        .then((result) {
      return NotificationChannelGroup.fromJson(result);
    });
  }
}
