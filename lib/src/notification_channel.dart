import 'dart:typed_data';

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
  final Uint64List? vibrationPattern;
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
      canBypassDnd: json['canBypassDnd'] as bool,
      canShowBadge: json['canShowBadge'] as bool,
      canShowLights: json['canShowLights'] as bool,
      enableLights: json['enableLights'] as bool,
      shouldVibrate: json['shouldVibrate'] as bool,
      lightColor: json["shouldVibrate"]
          ? LightColor.values.firstWhere(
              (e) => e.nativeValue() == json['lightColor'] as int,
            )
          : null,
      sound: Uri.parse(json['sound'] as String),
      vibrationPattern: json['vibrationPattern'] as Uint64List?,
      showBadge: json['showBadge'] as bool,
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
      'canShowLights': canShowLights,
      'enableLights': enableLights,
      'shouldVibrate': shouldVibrate,
      'lightColor': lightColor?.nativeValue(),
      'sound': sound?.toString(),
      'vibrationPattern': vibrationPattern,
      'showBadge': showBadge,
    };
  }
}
