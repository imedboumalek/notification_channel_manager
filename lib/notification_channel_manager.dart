import 'package:notification_channel_manager/src/notification_channel_group.dart';

import 'package:notification_channel_manager/src/notification_channel.dart';

import 'notification_channel_manager_platform_interface.dart';
export 'src/notification_channel_group.dart';
export 'src/notification_channel.dart';

class NotificationChannelManager {
  NotificationChannelManager._();
  static Future<void> deleteChannel(String channelId) {
    return NotificationChannelManagerPlatform.instance.deleteChannel(channelId);
  }

  static Future<void> deleteGroup(String channelGroupId) {
    return NotificationChannelManagerPlatform.instance
        .deleteGroup(channelGroupId);
  }

  static Future<void> deleteGroups(List<String> channelGroupIds) {
    return NotificationChannelManagerPlatform.instance
        .deleteGroups(channelGroupIds);
  }

  static Future<void> deleteMutliChannels(List<String> channelIds) {
    return NotificationChannelManagerPlatform.instance
        .deleteMutliChannels(channelIds);
  }

  static Future<List<NotificationChannel>> getAllChannels() {
    return NotificationChannelManagerPlatform.instance.getAllChannels();
  }

  static Future<List<NotificationChannelGroup>> getAllGroups() {
    return NotificationChannelManagerPlatform.instance.getAllGroups();
  }

  static Future<NotificationChannel?> getChannel(String channelId) {
    return NotificationChannelManagerPlatform.instance.getChannel(channelId);
  }

  static Future<NotificationChannelGroup?> getGroup(String groupId) {
    return NotificationChannelManagerPlatform.instance.getGroup(groupId);
  }

  static Future<NotificationChannel> createChannel(
      NotificationChannel notificationChannel) {
    return NotificationChannelManagerPlatform.instance
        .createChannel(notificationChannel);
  }

  static Future<List<NotificationChannel>> createChannels(
      List<NotificationChannel> channels) {
    return NotificationChannelManagerPlatform.instance.createChannels(channels);
  }

  static Future<NotificationChannel> updateChannel(
      NotificationChannelUpdate update) {
    return NotificationChannelManagerPlatform.instance.updateChannel(update);
  }

  static Future<List<NotificationChannel>> updateChannels(
      List<NotificationChannelUpdate> updates) {
    return NotificationChannelManagerPlatform.instance.updateChannels(updates);
  }

  static Future<void> deleteAllChannels() {
    return NotificationChannelManagerPlatform.instance.deleteAllChannels();
  }

  static Future<NotificationChannelGroup> upsertGroup(
      NotificationChannelGroup notificationChannelGroup) {
    return NotificationChannelManagerPlatform.instance
        .upsertGroup(notificationChannelGroup);
  }

  static Future<List<NotificationChannelGroup>> upsertGroups(
      List<NotificationChannelGroup> groups) {
    return NotificationChannelManagerPlatform.instance.upsertGroups(groups);
  }

  static Future<void> deleteAllGroups() {
    return NotificationChannelManagerPlatform.instance.deleteAllGroups();
  }
}
