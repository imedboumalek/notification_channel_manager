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
  Future<List<NotificationChannel>> getAllChannels() async {
    final result = await methodChannel.invokeMethod<List>('getChannels') ?? [];
    if (result.isEmpty) return [];

    final map = result.map((e) => Map<String, dynamic>.from(e)).toList();
    return map.map((e) => NotificationChannel.fromJson(e)).toList();
  }

  @override
  Future<NotificationChannel?> getChannel(String channelId) async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>('getChannel', channelId);
    if (result == null) return null;
    final map = Map<String, dynamic>.from(result);
    return NotificationChannel.fromJson(map);
  }

  @override
  Future<NotificationChannel> createChannel(NotificationChannel notificationChannel) async {
    var result = await methodChannel.invokeMethod<Map>(
      'createChannel',
      notificationChannel.toJson(),
    );
    result = Map<String, dynamic>.from(result!);
    return NotificationChannel.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<NotificationChannel>> createChannels(List<NotificationChannel> channels) async {
    var result = await methodChannel.invokeMethod<List>(
          'createChannels',
          channels.map((channel) => channel.toJson()).toList(),
        ) ??
        [];
    result = result.map((e) => Map<String, dynamic>.from(e)).toList();
    return result.map((json) => NotificationChannel.fromJson(json)).toList();
  }

  @override
  Future<NotificationChannel> updateChannel(NotificationChannelUpdate update) async {
    var result = await methodChannel.invokeMethod<Map>(
      'createChannel',
      update.toJson(),
    );
    result = Map<String, dynamic>.from(result!);
    return NotificationChannel.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<NotificationChannel>> updateChannels(List<NotificationChannelUpdate> updates) async {
    var result = await methodChannel.invokeMethod<List>(
          'createChannels',
          updates.map((channel) => channel.toJson()).toList(),
        ) ??
        [];
    result = result.map((e) => Map<String, dynamic>.from(e)).toList();
    return result.map((json) => NotificationChannel.fromJson(json)).toList();
  }

  @override
  Future<void> deleteChannel(String channelId) {
    return methodChannel.invokeMethod('deleteChannel', channelId);
  }

  @override
  Future<void> deleteMutliChannels(List<String> channelIds) {
    return methodChannel.invokeMethod('deleteChannels', channelIds);
  }

  @override
  Future<List<NotificationChannelGroup>> getAllGroups() {
    return methodChannel.invokeMethod('getGroups').then((result) {
      return result
          .map<NotificationChannelGroup>((json) => NotificationChannelGroup.fromJson(json))
          .toList();
    });
  }

  @override
  Future<NotificationChannelGroup?> getGroup(String groupId) {
    return methodChannel.invokeMethod('getGroup', groupId).then((result) {
      return NotificationChannelGroup.fromJson(result);
    });
  }

  @override
  Future<NotificationChannelGroup> upsertGroup(NotificationChannelGroup notificationChannelGroup) {
    return methodChannel
        .invokeMethod('createGroup', notificationChannelGroup.toJson())
        .then((result) {
      return NotificationChannelGroup.fromJson(result);
    });
  }

  @override
  Future<List<NotificationChannelGroup>> upsertGroups(List<NotificationChannelGroup> groups) {
    return methodChannel
        .invokeMethod('createGroups', groups.map((group) => group.toJson()).toList())
        .then((result) {
      return result
          .map<NotificationChannelGroup>((json) => NotificationChannelGroup.fromJson(json))
          .toList();
    });
  }

  @override
  Future<void> deleteGroup(String channelGroupId) {
    return methodChannel.invokeMethod('deleteGroup', channelGroupId);
  }

  @override
  Future<void> deleteGroups(List<String> channelGroupIds) {
    return methodChannel.invokeMethod('deleteGroups', channelGroupIds);
  }
}
