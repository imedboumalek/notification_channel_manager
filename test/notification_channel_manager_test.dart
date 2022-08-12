import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import 'package:notification_channel_manager/notification_channel_manager_platform_interface.dart';
import 'package:notification_channel_manager/notification_channel_manager_method_channel.dart';
import 'package:notification_channel_manager/src/notification_channel_group.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNotificationChannelManagerPlatform
    with MockPlatformInterfaceMixin
    implements NotificationChannelManagerPlatform {
  @override
  Future<void> deleteChannel(String channelId) {
    // TODO: implement deleteChannel
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChannelGroup(String channelGroupId) {
    // TODO: implement deleteChannelGroup
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMultiChannelGroups(List<String> channelGroupIds) {
    // TODO: implement deleteMultiChannelGroups
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMutliChannels(List<String> channelIds) {
    // TODO: implement deleteMutliChannels
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationChannelGroup>> getAllChannelGroups() {
    // TODO: implement getAllChannelGroups
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationChannel>> getAllChannels() {
    // TODO: implement getAllChannels
    throw UnimplementedError();
  }

  @override
  Future<NotificationChannel> getChannelById(String channelId) {
    // TODO: implement getChannelById
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationChannel>> getMultiChannelsByIds(List<String> channelIds) {
    // TODO: implement getMultiChannelsByIds
    throw UnimplementedError();
  }

  @override
  Future<NotificationChannel> upsertNotificationChannel(NotificationChannel notificationChannel) {
    // TODO: implement upsertNotificationChannel
    throw UnimplementedError();
  }

  @override
  Future<NotificationChannelGroup> upsertNotificationChannelGroup(
      NotificationChannelGroup notificationChannelGroup) {
    // TODO: implement upsertNotificationChannelGroup
    throw UnimplementedError();
  }
}

void main() {
  final NotificationChannelManagerPlatform initialPlatform =
      NotificationChannelManagerPlatform.instance;

  test('$MethodChannelNotificationChannelManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNotificationChannelManager>());
  });

  test('getPlatformVersion', () async {
    NotificationChannelManager notificationChannelManagerPlugin = NotificationChannelManager();
    MockNotificationChannelManagerPlatform fakePlatform = MockNotificationChannelManagerPlatform();
    NotificationChannelManagerPlatform.instance = fakePlatform;
  });
}
