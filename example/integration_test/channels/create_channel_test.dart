import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import '../../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Creating channels", () {
    app.main();
    testWidgets("given just the required fields, should create successfully",
        (WidgetTester tester) async {
      final channel = NotificationChannel(
        id: "id",
        name: "name",
        description: "description",
        importance: NotificationChannelImportance.high,
      );
      final result = await NotificationChannelManager.upsertChannel(channel);
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
    });

    testWidgets("given all fields, should create successfully, and should match the fields",
        (WidgetTester tester) async {
      final channel = NotificationChannel(
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
      final result = await NotificationChannelManager.upsertChannel(channel);
      expect(result.id, channel.id);
      expect(result.name, channel.name);
      expect(result.description, channel.description);
      expect(result.importance, channel.importance);
      expect(result.groupId, channel.groupId);
      expect(result.canShowBadge, channel.canShowBadge);
      expect(result.shouldShowLights, channel.shouldShowLights);
      expect(result.shouldVibrate, channel.shouldVibrate);
      // expect(result.lightColor, channel.lightColor);
      expect(result.sound, channel.sound);
      expect(result.vibrationPattern, channel.vibrationPattern);
    });
  });
}
