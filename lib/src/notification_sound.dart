part of 'notification_channel.dart';

class NotificationSoundUri extends Equatable {
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
  List<Object> get props => [uri];
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
  List<Object> get props => [fileName, packageName, super.props];
}
