import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/notification_channel_manager_method_channel.dart';

void main() {
  MethodChannelNotificationChannelManager platform = MethodChannelNotificationChannelManager();
  const MethodChannel channel = MethodChannel('notification_channel_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
