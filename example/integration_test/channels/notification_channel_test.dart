import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import '../../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Notification channels", () {
    app.main();
    final channel1 = NotificationChannel(
      id: "id",
      name: "name",
      description: "description",
      importance: NotificationChannelImportance.high,
    );

    final channel2 = NotificationChannel(
      id: "id2",
      name: "name2",
      description: "description2",
      importance: NotificationChannelImportance.high,
      groupId: null,
      canShowBadge: true,
      shouldShowLights: true,
      shouldVibrate: true,
      // lightColor: LightColor.red,
      sound: Uri.parse("android.resource://com.example.app/raw/notification"),
      vibrationPattern: Uint64List.fromList([0, 1000, 500, 1000]),
    );
    final results = <NotificationChannel>[];
    testWidgets("given just the required fields, should create successfully",
        (WidgetTester tester) async {
      final result = await NotificationChannelManager.upsertChannel(channel1);
      expect(result.id, "id");
      expect(result.name, "name");
      expect(result.description, "description");
      expect(result.importance, NotificationChannelImportance.high);
      expect(result.groupId, null);
      expect(result.canShowBadge, true);
      expect(result.shouldShowLights, false);
      expect(result.shouldVibrate, false);
      // expect(result.lightColor, null);
      expect(result.sound, Uri.parse("content://settings/system/notification_sound"),
          reason: "Default android notification sound");
      expect(result.vibrationPattern, null);
      results.add(result);
    });

    testWidgets("given all fields, should create successfully, and should match the fields",
        (WidgetTester tester) async {
      final result = await NotificationChannelManager.upsertChannel(channel2);
      expect(result.id, channel2.id);
      expect(result.name, channel2.name);
      expect(result.description, channel2.description);
      expect(result.importance, channel2.importance);
      expect(result.groupId, channel2.groupId);
      expect(result.canShowBadge, channel2.canShowBadge);
      expect(result.shouldShowLights, channel2.shouldShowLights);
      expect(result.shouldVibrate, channel2.shouldVibrate);
      // expect(result.lightColor, channel2.lightColor);
      expect(result.sound, channel2.sound);
      expect(result.vibrationPattern, channel2.vibrationPattern);
      results.add(result);
    });
    testWidgets("should read notification channel", (WidgetTester tester) async {
      var result = await NotificationChannelManager.getChannel(channel1.id);
      expect(result, results.first);
      result = await NotificationChannelManager.getChannel(channel2.id);
      expect(result, results.last);
    });
    testWidgets("should read all notification channels", (WidgetTester tester) async {
      final result = await NotificationChannelManager.getAllChannels();
      expect(result, results);
    });
    testWidgets("should delete notification channel", (WidgetTester tester) async {
      await NotificationChannelManager.deleteChannel(channel1.id);
      var result = await NotificationChannelManager.getChannel(channel1.id);
      expect(result, null);
      await NotificationChannelManager.deleteChannel(channel2.id);
      result = await NotificationChannelManager.getChannel(channel2.id);
      expect(result, null);
    });
    testWidgets("should return an empty list when there are no channels",
        (WidgetTester tester) async {
      final result = await NotificationChannelManager.getAllChannels();
      expect(result, isEmpty);
    });
  });
}
