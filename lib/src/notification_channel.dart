import 'notification_channel_importance.dart';

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;

  NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
  });
}
