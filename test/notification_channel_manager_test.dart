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
  Future<List<NotificationChannelGroup>> getNotificationChannelGroups() {
    // TODO: implement getNotificationChannelGroups
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationChannel>> getNotificationChannels() {
    // TODO: implement getNotificationChannels
    throw UnimplementedError();
  }

  @override
  Future<bool> initialize() {
    // TODO: implement initialize
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
