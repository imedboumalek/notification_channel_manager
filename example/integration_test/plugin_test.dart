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
      lightColor: LightColor.red,
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
      expect(result.lightColor, null);
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

  group("Modern channel features", () {
    setUpAll(() async {
      await NotificationChannelManager.deleteAllChannels();
      await NotificationChannelManager.deleteAllGroups();
    });
    tearDownAll(() async {
      await NotificationChannelManager.deleteAllChannels();
      await NotificationChannelManager.deleteAllGroups();
    });

    testWidgets("a plain channel reads back the model's defaults", (_) async {
      const channel = NotificationChannel(
        id: "modern1",
        name: "modern1",
        description: "modern1",
        importance: NotificationChannelImportance.defaultImportance,
      );
      final result = await NotificationChannelManager.createChannel(channel);
      expect(result.canBypassDnd, false);
      expect(result.allowBubbles, false);
      expect(result.hasUserSetImportance, false);
      expect(result.hasUserSetSound, false);
      expect(result.isBlockable, false);
      expect(result.isConversation, false);
      expect(result.isImportantConversation, false);
      expect(result.isDemoted, false);
      expect(result.parentChannelId, null);
      expect(result.conversationId, null);
    });

    testWidgets("conversation channels round trip and can be looked up",
        (_) async {
      const parent = NotificationChannel(
        id: "messages",
        name: "Messages",
        description: "Chat messages",
        importance: NotificationChannelImportance.high,
      );
      await NotificationChannelManager.createChannel(parent);

      const conversation = NotificationChannel(
        id: "messages_alice",
        name: "Alice",
        description: "Chat messages from Alice",
        importance: NotificationChannelImportance.high,
        parentChannelId: "messages",
        conversationId: "contact_alice",
      );
      final created =
          await NotificationChannelManager.createChannel(conversation);
      expect(created.parentChannelId, "messages");
      expect(created.conversationId, "contact_alice");
      expect(created.isConversation, true);
      expect(created.isDemoted, false);

      // conversation-aware lookup resolves to the conversation channel
      final byConversation = await NotificationChannelManager.getChannel(
          "messages",
          conversationId: "contact_alice");
      expect(byConversation!.id, "messages_alice");

      // unknown conversation falls back to the parent channel
      final fallback = await NotificationChannelManager.getChannel("messages",
          conversationId: "contact_nobody");
      expect(fallback!.id, "messages");
    });

    testWidgets("allowBubbles is only honored when the app may bubble",
        (_) async {
      const channel = NotificationChannel(
        id: "messages_bubbly",
        name: "Bubbly",
        description: "Bubbling conversation",
        importance: NotificationChannelImportance.high,
        parentChannelId: "messages",
        conversationId: "contact_bubbly",
        allowBubbles: true,
      );
      final created = await NotificationChannelManager.createChannel(channel);
      // Android ignores the per-channel opt-in unless the user has allowed
      // bubbles for the app.
      final appMayBubble = await NotificationChannelManager.areBubblesAllowed();
      expect(created.allowBubbles, appMayBubble);
    });

    testWidgets("app-level bubble queries return valid values", (_) async {
      final allowed = await NotificationChannelManager.areBubblesAllowed();
      final enabled = await NotificationChannelManager.areBubblesEnabled();
      final preference =
          await NotificationChannelManager.getBubblePreference();
      expect(allowed, isA<bool>());
      expect(enabled, isA<bool>());
      expect(preference, isA<BubblePreference>());
    });
  });
}
