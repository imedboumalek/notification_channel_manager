enum NotificationChannelImportance {
  /// Value signifying that the user has not expressed an importance.
  /// This value is for persisting preferences,
  /// and should never be associated with an actual notification.
  unspecified,

  /// A notification with no importance: does not show in the shade.
  none,

  /// Min notification importance: only shows in the shade, below the fold.
  /// Do not use this to start a foreground service.
  min,

  /// Low notification importance: Shows in the shade, and potentially in the status bar,
  /// but is not audibly intrusive.
  low,

  /// Default notification importance: shows everywhere, makes noise, but does not visually intrude.

  defaultImportance,

  /// Higher notification importance: shows everywhere, makes noise and peeks. May use full screen intents.
  /// This is most likely the one you want.
  high;

  /// maps the current importance to the corresponding value for the native platform.
  int nativeValue() {
    switch (this) {
      case unspecified:
        return -1000;
      case none:
        return 0;
      case min:
        return 1;
      case low:
        return 2;
      case defaultImportance:
        return 3;
      case high:
        return 4;
    }
  }
}
