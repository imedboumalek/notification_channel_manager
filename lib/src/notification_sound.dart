part of 'notification_channel.dart';

class NotificationSoundUri {
  final Uri uri;

  const NotificationSoundUri(this.uri);
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

class RawNotificationSound extends NotificationSoundUri {
  final String fileName;
  final String packageName;

  /// "android.resource://com.example.app/raw/my_sound"
  /// Audio file must be in your res/raw folder

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
