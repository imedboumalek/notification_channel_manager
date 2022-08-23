import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

void main() {
  group("NotificationChannel class", () {
    test("NotificationChannel should have an id, name, dsc, and importance", () {
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
      // expect(channel.lightColor, null);
      expect(channel.sound, null);
      expect(channel.vibrationPattern, null);
    });
  });
}
