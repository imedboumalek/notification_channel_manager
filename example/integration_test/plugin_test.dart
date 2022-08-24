import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import 'package:notification_channel_manager_example/main.dart' as app;

import 'fixtures/channels.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  group("Notification Channel groups", () {
    const group = NotificationChannelGroup(
      id: "group1",
      name: "group1",
      description: "group1",
    );
    const groups = [
      NotificationChannelGroup(
        id: "group2",
        name: "group2",
        description: "group2",
      ),
      NotificationChannelGroup(
        id: "group3",
        name: "group3",
        description: "group3",
      ),
      NotificationChannelGroup(
        id: "group4",
        name: "group4",
        description: "group4",
      ),
    ];
    testWidgets('create a single group', (_) async {
      final result = await NotificationChannelManager.upsertGroup(group);
      expect(result, equals(group));
    });
    testWidgets('create multiple groups', (_) async {
      final result = await NotificationChannelManager.upsertGroups(groups);
      expect(result, equals(groups));
    });
    testWidgets('get a single group', (_) async {
      var result = await NotificationChannelManager.getGroup("group1");
      expect(result, equals(group));
      result = await NotificationChannelManager.getGroup("group2");
      expect(result, equals(groups[0]));
    });
    testWidgets('get all groups', (_) async {
      final result = await NotificationChannelManager.getAllGroups();
      expect(result, equals([group] + groups));
    });
    testWidgets('delete a single group', (_) async {
      await NotificationChannelManager.deleteGroup("group1");
      final result = await NotificationChannelManager.getAllGroups();
      expect(result, equals(groups));
    });
    testWidgets('delete multiple groups', (_) async {
      await NotificationChannelManager.deleteGroups(["group2", "group3"]);
      final result = await NotificationChannelManager.getAllGroups();
      expect(result, equals([groups.last]));
    });
    testWidgets("delete all groups", (_) async {
      await NotificationChannelManager.deleteAllGroups();
      final result = await NotificationChannelManager.getAllGroups();
      expect(result, equals([]));
    });
  });

  group("Notification channels", () {
    setUpAll(() async {
      await NotificationChannelManager.deleteAllChannels();
      await NotificationChannelManager.deleteAllGroups();
    });
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
      groupId: "alarms",
      canShowBadge: true,
      shouldShowLights: true,
      shouldVibrate: true,
      // lightColor: LightColor.red,
      sound: RawNotificationSound(fileName: "sound.mp3", packageName: "dev.imed.example"),

      vibrationPattern: Uint64List.fromList([0, 1000, 500, 1000]),
    );
    final createdChannels = <NotificationChannel>[];
    testWidgets("should return an empty list when there are no channels", (_) async {
      final result = await NotificationChannelManager.getAllChannels();
      expect(result, isEmpty);
    });
    testWidgets("should return an empty list when there are not groups", (_) async {
      final result = await NotificationChannelManager.getAllGroups();
      expect(result, isEmpty);
    });
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
      createdChannels.add(result);
    });

    testWidgets(
        "given all fields, should create successfully, and values should match, reading again should also match",
        (_) async {
      var result = await NotificationChannelManager.createChannel(channel2);
      expect(result, channel2);
      expect(result.sound, isA<RawNotificationSound>());
      createdChannels.add(result);
    });
    testWidgets("reading a channel that doesn't exist should return null", (_) async {
      final result = await NotificationChannelManager.getChannel("lkdjqlsdjqlid");
      expect(result, null);
    });
    testWidgets("reading a channel that exists should return the channel", (_) async {
      final result = await NotificationChannelManager.getChannel(channel2.id);
      expect(result, channel2);
    });
    testWidgets("creating a channel with a group that doesn't exist, should create the group",
        (_) async {
      final group = await NotificationChannelManager.getGroup("alarms");
      expect(group, isA<NotificationChannelGroup>());
      expect(group!.id, "alarms");
      expect(group.name, "alarms");
      expect(group.channels.contains(channel2), isTrue);
    });

    testWidgets("creating multiple channels at once", (_) async {
      final result = await NotificationChannelManager.createChannels(channelsWithAllFields);
      expect(result, isNotEmpty);
      expect(result.length, channelsWithAllFields.length);
      expect(result, channelsWithAllFields);
    });

    testWidgets("should read all notification channels", (_) async {
      final result = await NotificationChannelManager.getAllChannels();
      expect(result, isNotEmpty);
      expect(result, createdChannels + channelsWithAllFields);
    });

    testWidgets("should delete notification channel", (_) async {
      await NotificationChannelManager.deleteChannel(channel1.id);
      var result = await NotificationChannelManager.getChannel(channel1.id);
      expect(result, null);
      await NotificationChannelManager.deleteChannel(channel2.id);
      result = await NotificationChannelManager.getChannel(channel2.id);
      expect(result, null);
    });
  });
}
