import 'notification_channel_importance.dart';

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;
  final String? groupId;

  NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
    this.groupId,
  });

  factory NotificationChannel.fromJson(Map<String, dynamic> json) {
    return NotificationChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      importance: NotificationChannelImportance.values.firstWhere(
        (e) => e.toString() == 'NotificationChannelImportance.${json['importance']}',
        orElse: () => NotificationChannelImportance.defaultImportance,
      ),
      groupId: json['groupId'] as String?,
    );
  }
}
