/// The user's app-level preference for
/// [bubbles](https://developer.android.com/develop/ui/views/notifications/bubbles),
/// from the system notification settings.
enum BubblePreference {
  /// No notifications of this app may bubble.
  none,

  /// All notifications of this app may bubble (subject to per-channel
  /// settings, see `NotificationChannel.allowBubbles`).
  all,

  /// Only notifications of channels the user selected may bubble.
  selected;

  /// Maps a native `NotificationManager` bubble preference constant to a
  /// [BubblePreference].
  static BubblePreference fromNativeValue(int value) {
    switch (value) {
      case 1:
        return BubblePreference.all;
      case 2:
        return BubblePreference.selected;
      default:
        return BubblePreference.none;
    }
  }
}
