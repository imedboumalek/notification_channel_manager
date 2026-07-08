import 'package:flutter/services.dart';

/// Posts test notifications via an example-local platform channel.
///
/// Notification *posting* is out of scope for the plugin (it only manages
/// channels), so the example app brings its own tiny sender — see
/// MainActivity.kt.
class TestNotifier {
  TestNotifier._();

  static const _channel =
      MethodChannel('notification_channel_manager_example/notifier');

  static var _counter = 0;

  /// Sends a test notification to [channelId]. Returns false when
  /// notifications aren't possible yet — most commonly because the
  /// notification permission hasn't been granted (the native side requests
  /// it, so the user can just try again after allowing).
  static Future<bool> send(String channelId) async {
    _counter++;
    return await _channel.invokeMethod<bool>('sendTestNotification', {
          'channelId': channelId,
          'title': 'Test notification #$_counter',
          'body': 'Posted to channel "$channelId"',
        }) ??
        false;
  }

  /// Sends a bubble-capable conversation notification to [channelId]:
  /// MessagingStyle + long-lived shortcut + BubbleMetadata expanding into
  /// BubbleActivity. Whether it actually bubbles depends on the user's
  /// bubble settings; otherwise it shows as a conversation notification with
  /// a bubble affordance. Requires Android 11 (API 30).
  static Future<bool> sendBubble(String channelId) async {
    return await _channel.invokeMethod<bool>('sendTestBubbleNotification', {
          'channelId': channelId,
        }) ??
        false;
  }
}
