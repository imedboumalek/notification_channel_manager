import 'dart:typed_data';

import 'package:equatable/equatable.dart';

part 'notification_sound.dart';

part 'notification_channel_importance.dart';
part 'notification_channel_light_color.dart';

class NotificationChannelUpdate extends Equatable {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;

  const NotificationChannelUpdate({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
  });

  @override
  List<Object?> get props => [id, name, description, importance];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'importance': importance.nativeValue(),
    };
  }
}

class NotificationChannel extends Equatable {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;
  final String? groupId;
  final bool canShowBadge;
  final bool shouldShowLights;
  final bool shouldVibrate;
  // final LightColor? lightColor;
  final NotificationSoundUri? sound;
  final Uint64List? vibrationPattern;

  const NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
    this.groupId,
    this.canShowBadge = true,
    this.shouldShowLights = false,
    this.shouldVibrate = false,
    // this.lightColor,
    this.sound,
    this.vibrationPattern,
  });

  factory NotificationChannel.fromJson(Map<String, dynamic> json) {
    return NotificationChannel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
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
      sound: NotificationSoundUri.parse(json['sound'] as String),
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

  @override
  List<Object> get props => [
        id,
        name,
        description,
        importance,
        if (groupId != null) groupId!,
        canShowBadge,
        shouldShowLights,
        shouldVibrate,
        // if (lightColor != null) lightColor!,
        if (sound != null) sound!,
        if (vibrationPattern != null) vibrationPattern!,
      ];
}
