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
  Future<void> deleteAllChannels() {
    return methodChannel.invokeMethod('deleteAllChannels');
  }

  @override
  Future<List<NotificationChannelGroup>> getAllGroups() async {
    var result = await methodChannel.invokeMethod<List>('getGroups') ?? [];
    if (result.isEmpty) return [];
    result = result.map((e) => Map<String, dynamic>.from(e)).toList();
    for (var json in result) {
      json['channels'] =
          (json['channels'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return result.map((json) => NotificationChannelGroup.fromJson(json)).toList();
  }

  @override
  Future<NotificationChannelGroup?> getGroup(String groupId) async {
    final result = await methodChannel.invokeMethod<Map>('getGroup', groupId);
    if (result == null) return null;
    final map = Map<String, dynamic>.from(result);
    map['channels'] = (map['channels'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    return NotificationChannelGroup.fromJson(map);
  }

  @override
  Future<NotificationChannelGroup> upsertGroup(
      NotificationChannelGroup notificationChannelGroup) async {
    final result = await methodChannel.invokeMethod<Map>(
      'createGroup',
      notificationChannelGroup.toJson(),
    );

    final map = Map<String, dynamic>.from(result!);
    map['channels'] = (map['channels'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    return NotificationChannelGroup.fromJson(map);
  }

  @override
  Future<List<NotificationChannelGroup>> upsertGroups(List<NotificationChannelGroup> groups) async {
    var result = await methodChannel.invokeMethod<List>(
          'createGroups',
          groups.map((group) => group.toJson()).toList(),
        ) ??
        [];
    result = result.map((e) => Map<String, dynamic>.from(e)).toList();
    for (var json in result) {
      json['channels'] =
          (json['channels'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return result.map((json) => NotificationChannelGroup.fromJson(json)).toList();
  }

  @override
  Future<void> deleteGroup(String channelGroupId) {
    return methodChannel.invokeMethod('deleteGroup', channelGroupId);
  }

  @override
  Future<void> deleteGroups(List<String> channelGroupIds) {
    return methodChannel.invokeMethod('deleteGroups', channelGroupIds);
  }

  @override
  Future<void> deleteAllGroups() {
    return methodChannel.invokeMethod('deleteAllGroups');
  }
}
