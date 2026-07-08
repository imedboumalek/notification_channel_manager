# notification_channel_manager

An Android plugin to manage (CRUD) [NotificationChannels](https://developer.android.com/reference/android/app/NotificationChannel) and [NotificationChannelGroups](https://developer.android.com/reference/android/app/NotificationChannelGroup).

Notification channels are how Android lets users control an app's notifications per category (sound, vibration, importance, …) from the system settings. This plugin gives you the full lifecycle from Dart: create channels and groups with all their options, read them back exactly as Android stored them, update what Android allows updating, and delete them.

## Requirements

- Android 8.0 (API 26) or above at runtime — on older versions every call is a **no-op** (nothing is thrown; reads return `null`/empty).
- `minSdkVersion` 24 or above, Dart 3.

This is an Android-only plugin; there is no iOS equivalent to notification channels.

## Usage

### Create a channel

```dart
import 'package:notification_channel_manager/notification_channel_manager.dart';

await NotificationChannelManager.createChannel(const NotificationChannel(
  id: 'urgent_alerts',
  name: 'Urgent alerts',
  description: 'Time-critical alerts that need your attention',
  importance: NotificationChannelImportance.high,
));
```

`createChannel` returns the channel **as Android stored it** — Android fills in defaults (like the system notification sound) and may clamp values, so the returned object can differ from what you passed in.

### Create a channel with all options

```dart
final channel = await NotificationChannelManager.createChannel(NotificationChannel(
  id: 'incoming_calls',
  name: 'Incoming calls',
  description: 'Ringing for incoming calls',
  importance: NotificationChannelImportance.high,
  groupId: 'calls',                    // group is auto-created if it doesn't exist
  canShowBadge: true,
  shouldShowLights: true,
  lightColor: LightColor.red,
  shouldVibrate: true,
  vibrationPattern: Uint64List.fromList([0, 1000, 500, 1000]),
  sound: RawNotificationSound(
    fileName: 'ringtone',              // res/raw/ringtone.mp3 in your app
    packageName: 'com.example.app',
  ),
));
```

### Groups

```dart
// Create or update (the native call is an upsert):
await NotificationChannelManager.upsertGroup(const NotificationChannelGroup(
  id: 'calls',
  name: 'Calls',
  description: 'Everything call-related', // visible on API 28+ only
));

// Read back, populated with their channels:
final groups = await NotificationChannelManager.getAllGroups();

// Deleting a group deletes its channels too:
await NotificationChannelManager.deleteGroup('calls');
```

### Conversation channels (Android 11+)

Conversation channels give users per-conversation notification settings (e.g. per contact in a messaging app). Create the parent channel first, then a channel with `parentChannelId` and `conversationId` set:

```dart
await NotificationChannelManager.createChannel(const NotificationChannel(
  id: 'messages_alice',
  name: 'Alice',
  description: 'Messages from Alice',
  importance: NotificationChannelImportance.high,
  parentChannelId: 'messages',       // must exist
  conversationId: 'contact_alice',   // typically your shortcut id
));

// Conversation-aware lookup; falls back to the parent channel if no
// conversation channel exists for that id:
final channel = await NotificationChannelManager.getChannel(
  'messages',
  conversationId: 'contact_alice',
);
```

Read-only fields tell you what the user did with it: `isConversation`, `isImportantConversation`, `isDemoted` (user turned it back into a regular channel). Below Android 11 the channel is created as a regular channel.

### Bubbles and channel state (Android 10+)

```dart
// Per-channel opt-in (only honored once the user allows bubbles for the app):
NotificationChannel(..., allowBubbles: true)

// App-level bubble state:
final allowed = await NotificationChannelManager.areBubblesAllowed();    // API 29+
final enabled = await NotificationChannelManager.areBubblesEnabled();    // API 31+
final preference = await NotificationChannelManager.getBubblePreference(); // none/all/selected
```

Channels also read back user-interaction state: `hasUserSetImportance` and `hasUserSetSound` tell you when an update to those fields would be ignored, and `canBypassDnd` lets a channel bypass Do Not Disturb.

### Read, update, delete

```dart
final all = await NotificationChannelManager.getAllChannels();
final one = await NotificationChannelManager.getChannel('urgent_alerts'); // null if absent

// Only name, description, and importance are updatable after creation:
await NotificationChannelManager.updateChannel(const NotificationChannelUpdate(
  id: 'urgent_alerts',
  name: 'Critical alerts',
  description: 'Renamed',
  importance: NotificationChannelImportance.defaultImportance,
));

await NotificationChannelManager.deleteChannel('urgent_alerts');
await NotificationChannelManager.deleteAllChannels();
```

Batch variants exist for everything: `createChannels`, `updateChannels`, `deleteMultiChannels`, `upsertGroups`, `deleteGroups`, `deleteAllGroups`.

## Things to keep in mind

These are Android behaviors, not plugin choices — see the [official docs](https://developer.android.com/develop/ui/views/notifications/channels):

- **Deleting a channel is a soft delete.** Creating another channel with the same `id` un-deletes it with its old settings. The system settings screen shows the number of deleted channels as a spam-prevention measure; on development devices, clear the app's data or reinstall to reset.
- **After creation, only name, description, and importance can change.** Importance is only ever *lowered*, and only while the user hasn't altered the channel's settings themselves.
- **Deleting a group deletes all channels in it.**
- **The user is in control.** Once a channel exists, the user can change its sound, importance, vibration, etc. from system settings, and your app cannot override their choices.
- `NotificationChannelGroup.description` and `isBlocked` require Android 9 (API 28); below that the description is ignored and `isBlocked` is always `false`.
- Many modern devices have no notification LED, in which case `lightColor` has no visible effect.

## Example app

The [example app](example/) is a small channel-manager UI that exercises the whole API: browse channels and groups, create channels with every option, update them, and delete them. Run it with `flutter run` from `example/`.

## Useful links

- [Notification channels (Android guide)](https://developer.android.com/develop/ui/views/notifications/channels)
- [NotificationChannel (API reference)](https://developer.android.com/reference/android/app/NotificationChannel)
- [NotificationChannelGroup (API reference)](https://developer.android.com/reference/android/app/NotificationChannelGroup)
- [NotificationManager (API reference)](https://developer.android.com/reference/android/app/NotificationManager)

## Contributing

This project is open source. Contributions are more than welcome!
