import 'package:notification_channel_manager/src/notification_channel_group.dart';

import 'package:notification_channel_manager/src/notification_channel.dart';

import 'notification_channel_manager_platform_interface.dart';

class NotificationChannelManager {
  Future<void> deleteChannel(String channelId) async {
    return NotificationChannelManagerPlatform.instance.deleteChannel(channelId);
  }

  Future<void> deleteChannelGroup(String channelGroupId) {
    return NotificationChannelManagerPlatform.instance.deleteChannelGroup(channelGroupId);
  }

  Future<void> deleteMultiChannelGroups(List<String> channelGroupIds) {
    return NotificationChannelManagerPlatform.instance.deleteMultiChannelGroups(channelGroupIds);
  }

  Future<void> deleteMutliChannels(List<String> channelIds) {
    return NotificationChannelManagerPlatform.instance.deleteMutliChannels(channelIds);
  }

  Future<List<NotificationChannelGroup>> getAllChannelGroups() {
    return NotificationChannelManagerPlatform.instance.getAllChannelGroups();
  }

  Future<List<NotificationChannel>> getAllChannels() {
    return NotificationChannelManagerPlatform.instance.getAllChannels();
  }

  Future<NotificationChannel> getChannelById(String channelId) {
    return NotificationChannelManagerPlatform.instance.getChannelById(channelId);
  }

  Future<List<NotificationChannel>> getMultiChannelsByIds(List<String> channelIds) {
    return NotificationChannelManagerPlatform.instance.getMultiChannelsByIds(channelIds);
  }

  Future<NotificationChannel> upsertNotificationChannel(NotificationChannel channel) {
    return NotificationChannelManagerPlatform.instance.upsertNotificationChannel(channel);
  }

  Future<NotificationChannelGroup> upsertNotificationChannelGroup(NotificationChannelGroup group) {
    return NotificationChannelManagerPlatform.instance.upsertNotificationChannelGroup(group);
  }
}
