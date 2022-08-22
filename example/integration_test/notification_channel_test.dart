import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import 'package:notification_channel_manager_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Notification channels", () {
    app.main();
    const channel1 = NotificationChannel(
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
      sound: RawNotificationSound(fileName: "sound.mp3", packageName: "dev.imed.example"),

      vibrationPattern: Uint64List.fromList([0, 1000, 500, 1000]),
    );
    final results = <NotificationChannel>[];
    testWidgets("given just the required fields, should create successfully", (_) async {
      final result = await NotificationChannelManager.createChannel(channel1);
      expect(result.id, "id");
      expect(result.name, "name");
      expect(result.description, "description");
      expect(result.importance, NotificationChannelImportance.high);
      expect(result.groupId, null);
      expect(result.canShowBadge, true);
      expect(result.shouldShowLights, false);
      expect(result.shouldVibrate, false);
      // expect(result.lightColor, null);
      expect(result.sound, isA<NotificationSoundUri>());
      expect(result.sound.toString(), "content://settings/system/notification_sound",
          reason: "Default android notification sound");
      expect(result.vibrationPattern, null);
      results.add(result);
    });

    testWidgets("given all fields, should create successfully, and should match the fields",
        (_) async {
      final result = await NotificationChannelManager.createChannel(channel2);
      expect(result, channel2);
      expect(result.sound, isA<RawNotificationSound>());
      results.add(result);
    });
    testWidgets("should read notification channel", (_) async {
      var result = await NotificationChannelManager.getChannel(channel1.id);
      expect(result, results.first);
      result = await NotificationChannelManager.getChannel(channel2.id);
      expect(result, channel2);
    });
    testWidgets("should read all notification channels", (_) async {
      final result = await NotificationChannelManager.getAllChannels();
      expect(result, results);
    });

    testWidgets("should delete notification channel", (_) async {
      await NotificationChannelManager.deleteChannel(channel1.id);
      var result = await NotificationChannelManager.getChannel(channel1.id);
      expect(result, null);
      await NotificationChannelManager.deleteChannel(channel2.id);
      result = await NotificationChannelManager.getChannel(channel2.id);
      expect(result, null);
    });
    testWidgets("should return an empty list when there are no channels", (_) async {
      final result = await NotificationChannelManager.getAllChannels();
      expect(result, isEmpty);
    });
  });
}
