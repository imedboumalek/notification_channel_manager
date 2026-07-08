part of 'notification_channel.dart';

/// The sound a notification channel plays, as an Android content URI.
///
/// Use [NotificationSoundUri.systemDefault] for the system notification
/// sound, or [RawNotificationSound] for a sound bundled in the app's
/// `res/raw` folder.
class NotificationSoundUri {
  /// The Android content URI of the sound.
  final Uri uri;

  const NotificationSoundUri(this.uri);

  /// Parses [uri], returning a [RawNotificationSound] when it points into an
  /// app's `res/raw` resources (`android.resource://` scheme).
  factory NotificationSoundUri.parse(String uri) {
    final temp = Uri.parse(uri);
    if (temp.scheme == 'android.resource') {
      return RawNotificationSound(
        fileName: temp.pathSegments.last,
        packageName: temp.host,
      );
    }
    return NotificationSoundUri(temp);
  }

  /// The device's default notification sound.
  NotificationSoundUri.systemDefault()
      : uri = Uri.parse('content://settings/system/notification_sound');
  @override
  String toString() => uri.toString();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationSoundUri &&
            runtimeType == other.runtimeType &&
            uri == other.uri;
  }

  @override
  int get hashCode => uri.hashCode;
}

/// A notification sound bundled in an app's `res/raw` resources.
///
/// Resolves to `android.resource://<packageName>/raw/<fileName>`.
class RawNotificationSound extends NotificationSoundUri {
  /// Name of the audio file in the `res/raw` folder, without extension.
  final String fileName;

  /// Package name of the app that bundles the sound.
  final String packageName;

  RawNotificationSound({
    required this.fileName,
    required this.packageName,
  }) : super(Uri.parse("android.resource://$packageName/raw/$fileName"));

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RawNotificationSound &&
            runtimeType == other.runtimeType &&
            fileName == other.fileName &&
            packageName == other.packageName;
  }

  @override
  int get hashCode => Object.hash(fileName, packageName);
}
