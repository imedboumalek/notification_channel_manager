import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

void main() {
  group("NotificationChannel class", () {
    test("NotificationChannel should have an id, name, dsc, and importance",
        () {
      const channel = NotificationChannel(
        id: "id",
        name: "name",
        description: "description",
        importance: NotificationChannelImportance.high,
      );
      expect(channel.id, "id");
      expect(channel.name, "name");
      expect(channel.description, "description");
      expect(channel.importance, NotificationChannelImportance.high);
      expect(channel.groupId, null);
      expect(channel.canShowBadge, true);
      expect(channel.shouldShowLights, false);
      expect(channel.shouldVibrate, false);
      expect(channel.lightColor, null);
      expect(channel.sound, null);
      expect(channel.vibrationPattern, null);
    });

    test("lightColor should survive a toJson/fromJson round trip", () {
      const channel = NotificationChannel(
        id: "id",
        name: "name",
        description: "description",
        importance: NotificationChannelImportance.high,
        shouldShowLights: true,
        lightColor: LightColor.red,
      );
      final decoded = NotificationChannel.fromJson(channel.toJson());
      expect(decoded.lightColor, LightColor.red);
      expect(decoded, equals(channel));
    });

    test("lightColor should parse the signed int the native side sends", () {
      final json = {
        'id': 'id',
        'name': 'name',
        'description': 'description',
        'importance': NotificationChannelImportance.high.nativeValue(),
        'canShowBadge': true,
        'shouldShowLights': true,
        'shouldVibrate': false,
        // 0xFFFF0000 (red) as a signed 32-bit Int
        'lightColor': -65536,
      };
      expect(NotificationChannel.fromJson(json).lightColor, LightColor.red);
    });

    test("lightColor should be null when lights are disabled", () {
      final json = {
        'id': 'id',
        'name': 'name',
        'description': 'description',
        'importance': NotificationChannelImportance.high.nativeValue(),
        'canShowBadge': true,
        'shouldShowLights': false,
        'shouldVibrate': false,
        'lightColor': 0,
      };
      expect(NotificationChannel.fromJson(json).lightColor, null);
    });
  });
}
