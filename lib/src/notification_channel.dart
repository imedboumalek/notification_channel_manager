import 'notification_channel_importance.dart';
import 'notification_channel_light_color.dart';

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;
  final String? groupId;
  final bool? canBypassDnd;
  final bool? canShowBadge;
  final bool? canShowLights;
  final bool? enableLights;
  final bool? shouldVibrate;
  final LightColor? lightColor;
  final Uri? sound;
  final int? vibrationPattern;
  final bool? showBadge;

  NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
    this.groupId,
    this.canBypassDnd,
    this.canShowBadge,
    this.canShowLights,
    this.enableLights,
    this.shouldVibrate,
    this.lightColor,
    this.sound,
    this.vibrationPattern,
    this.showBadge,
  });

  factory NotificationChannel.fromJson(Map<String, dynamic> json) {
    return NotificationChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      importance: NotificationChannelImportance.values.firstWhere(
        (e) => e.nativeValue() == json['importance'] as int,
        orElse: () => NotificationChannelImportance.defaultImportance,
      ),
      groupId: json['groupId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'importance': importance.nativeValue(),
      'groupId': groupId,
    };
  }
}
