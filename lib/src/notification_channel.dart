import 'dart:ffi';
import 'dart:typed_data';

part 'notification_channel_importance.dart';
part 'notification_channel_light_color.dart';

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;
  final String? groupId;
  final bool? canShowBadge;
  final bool? shouldShowLights;
  final bool? shouldVibrate;
  // final LightColor? lightColor;
  final Uri? sound;
  final Uint64List? vibrationPattern;

  NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
    this.groupId,
    this.canShowBadge,
    this.shouldShowLights,
    this.shouldVibrate,
    // this.lightColor,
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
      canShowBadge: json['canShowBadge'] as bool,
      shouldShowLights: json['shouldShowLights'] as bool,
      shouldVibrate: json['shouldVibrate'] as bool,
      // lightColor: json["shouldShowLights"]
      //     ? LightColor.values.firstWhere(
      //         (e) => e.nativeValue() == json['lightColor'],
      //         orElse: () => LightColor.transparent,
      //       )
      //     : null,
      sound: Uri.parse(json['sound'] as String),
      vibrationPattern: json['vibrationPattern'] == null
          ? null
          : Uint64List.fromList((json['vibrationPattern'] as List).map((e) => e as int).toList()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'importance': importance.nativeValue(),
      'groupId': groupId,
      'canShowBadge': canShowBadge,
      'shouldShowLights': shouldShowLights,
      'shouldVibrate': shouldVibrate,
      // 'lightColor': lightColor?.nativeValue(),
      'sound': sound?.toString(),
      'vibrationPattern': vibrationPattern?.toList(),
    };
  }
}
