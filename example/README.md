# notification_channel_manager_example

Demonstrates how to use the notification_channel_manager plugin.

A small channel-manager UI that exercises the whole API:

- browse the app's notification channels and groups (with pull-to-refresh),
- create channels with every option the plugin supports — importance, group,
  badge, lights with a color, vibration ([lib/channel_form_page.dart](lib/channel_form_page.dart)),
- inspect a channel as Android stored it and update the fields Android allows
  changing ([lib/channel_detail_page.dart](lib/channel_detail_page.dart)),
- create/update groups ([lib/group_form_page.dart](lib/group_form_page.dart)),
- delete individual channels and groups, or everything at once,
- send a test notification to any channel to hear/see its settings in action
  ([lib/test_notifier.dart](lib/test_notifier.dart) — posting is out of scope
  for the plugin, so the example brings its own tiny sender in
  MainActivity.kt, including the Android 13+ permission request),
- send a test *bubble* notification (Android 11+): a MessagingStyle
  conversation tied to a long-lived shortcut with BubbleMetadata expanding
  into BubbleActivity. Note that bubbles only float once the user allows
  bubbles for the app (Settings → Notifications → Bubbles, or
  `adb shell cmd notification set_bubbles <package> 1`); otherwise the
  notification shows with a bubble affordance instead.

Run it on an Android device or emulator with `flutter run`.

The plugin's integration tests also live here; run them with a device
attached:

```bash
flutter test integration_test/plugin_test.dart
```
