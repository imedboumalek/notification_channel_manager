import 'package:notification_channel_manager/src/notification_channel_group.dart';

import 'package:notification_channel_manager/src/notification_channel.dart';

import 'notification_channel_manager_platform_interface.dart';

class NotificationChannelManager {
  static Future<void> deleteChannel(String channelId) {
    return NotificationChannelManagerPlatform.instance.deleteChannel(channelId);
  }

  static Future<void> deleteGroup(String channelGroupId) {
    return NotificationChannelManagerPlatform.instance.deleteGroup(channelGroupId);
  }

  static Future<void> deleteGroups(List<String> channelGroupIds) {
    return NotificationChannelManagerPlatform.instance.deleteGroups(channelGroupIds);
  }

  static Future<void> deleteMutliChannels(List<String> channelIds) {
    return NotificationChannelManagerPlatform.instance.deleteMutliChannels(channelIds);
  }

  static Future<List<NotificationChannel>> getAllChannels() {
    return NotificationChannelManagerPlatform.instance.getAllChannels();
  }

  static Future<List<NotificationChannelGroup>> getAllGroups() {
    return NotificationChannelManagerPlatform.instance.getAllGroups();
  }

  static Future<NotificationChannel> getChannel(String channelId) {
    return NotificationChannelManagerPlatform.instance.getChannel(channelId);
  }

  static Future<NotificationChannelGroup> getGroup(String groupId) {
    return NotificationChannelManagerPlatform.instance.getGroup(groupId);
  }

  static Future<NotificationChannel> upsertChannel(NotificationChannel notificationChannel) {
    return NotificationChannelManagerPlatform.instance.upsertChannel(notificationChannel);
  }

  static Future<List<NotificationChannel>> upsertChannels(List<NotificationChannel> channels) {
    return NotificationChannelManagerPlatform.instance.upsertChannels(channels);
  }

  static Future<NotificationChannelGroup> upsertGroup(
      NotificationChannelGroup notificationChannelGroup) {
    return NotificationChannelManagerPlatform.instance.upsertGroup(notificationChannelGroup);
  }

  static Future<List<NotificationChannelGroup>> upsertGroups(
      List<NotificationChannelGroup> groups) {
    return NotificationChannelManagerPlatform.instance.upsertGroups(groups);
  }
}
