import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';
import 'package:notification_channel_manager/src/notification_channel_importance.dart';

void main() {
  group("NotificationChannel class", () {
    test("NotificationChannel should have an id, name, dsc, and importance", () {
      final channel = NotificationChannel(
        id: "id",
        name: "name",
        description: "description",
        importance: NotificationChannelImportance.high,
      );
      expect(channel.id, "id");
      expect(channel.name, "name");
      expect(channel.description, "description");
      expect(channel.importance, NotificationChannelImportance.high);
    });
  });
}
