import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

void main() {
  group("notification sound", () {
    test("should create a raw notification sound", () {
      final sound = RawNotificationSound(fileName: "sound.mp3", packageName: "dev.imed.example");
      expect(sound.fileName, "sound.mp3");
      expect(sound.packageName, "dev.imed.example");
      expect(
        sound.uri,
        Uri(
          scheme: "android.resource",
          host: "dev.imed.example",
          pathSegments: ["raw", "sound.mp3"],
        ),
      );
      expect(sound.toString(), "android.resource://dev.imed.example/raw/sound.mp3");
    });

    test("parsing a string should return the correct type", () {
      expect(
        NotificationSoundUri.parse("android.resource://dev.imed.example/raw/sound.mp3"),
        RawNotificationSound(fileName: "sound.mp3", packageName: "dev.imed.example"),
      );
      expect(
        NotificationSoundUri.parse("content://settings/system/notification_sound"),
        NotificationSoundUri(Uri.parse("content://settings/system/notification_sound")),
      );
    });
  });
}
