import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import 'package:notification_channel_manager/notification_channel_manager_platform_interface.dart';
import 'package:notification_channel_manager/notification_channel_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNotificationChannelManagerPlatform 
    with MockPlatformInterfaceMixin
    implements NotificationChannelManagerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NotificationChannelManagerPlatform initialPlatform = NotificationChannelManagerPlatform.instance;

  test('$MethodChannelNotificationChannelManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNotificationChannelManager>());
  });

  test('getPlatformVersion', () async {
    NotificationChannelManager notificationChannelManagerPlugin = NotificationChannelManager();
    MockNotificationChannelManagerPlatform fakePlatform = MockNotificationChannelManagerPlatform();
    NotificationChannelManagerPlatform.instance = fakePlatform;
  
    expect(await notificationChannelManagerPlugin.getPlatformVersion(), '42');
  });
}
