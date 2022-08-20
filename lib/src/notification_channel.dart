import 'dart:typed_data';

part 'notification_channel_importance.dart';
part 'notification_channel_light_color.dart';

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;
  final String? groupId;
  final bool? canBypassDnd;
  final bool? canShowBadge;
  final bool? shouldShowLights;
  final bool? shouldVibrate;
  final LightColor? lightColor;
  final Uri? sound;
  final Uint64List? vibrationPattern;

  NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
    this.groupId,
    this.canBypassDnd,
    this.canShowBadge,
    this.shouldShowLights,
    this.shouldVibrate,
    this.lightColor,
    this.sound,
    this.vibrationPattern,
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
      canBypassDnd: json['canBypassDnd'] as bool,
      canShowBadge: json['canShowBadge'] as bool,
      shouldShowLights: json['shouldShowLights'] as bool,
      shouldVibrate: json['shouldVibrate'] as bool,
      lightColor: json["shouldShowLights"]
          ? LightColor.values.firstWhere(
              (e) => e.nativeValue() == json['lightColor'] as int,
            )
          : null,
      sound: Uri.parse(json['sound'] as String),
      vibrationPattern: json['vibrationPattern'] as Uint64List?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'importance': importance.nativeValue(),
      'groupId': groupId,
      'canBypassDnd': canBypassDnd,
      'canShowBadge': canShowBadge,
      'shouldShowLights': shouldShowLights,
      'shouldVibrate': shouldVibrate,
      'lightColor': lightColor?.nativeValue(),
      'sound': sound?.toString(),
      'vibrationPattern': vibrationPattern,
    };
  }
}
