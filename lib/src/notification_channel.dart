import 'dart:typed_data';

import 'package:flutter/foundation.dart';

part 'notification_sound.dart';

part 'notification_channel_importance.dart';
part 'notification_channel_light_color.dart';

class NotificationChannelUpdate {
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationChannelUpdate &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            importance == other.importance;
  }

  @override
  int get hashCode => Object.hash(id, name, description, importance);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'importance': importance.nativeValue(),
    };
  }
}

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelImportance importance;
  final String? groupId;
  final bool canShowBadge;
  final bool shouldShowLights;
  final bool shouldVibrate;
  final LightColor? lightColor;
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
    this.lightColor,
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
      lightColor: json['shouldShowLights'] == true && json['lightColor'] != null
          ? LightColor.values.firstWhere(
              // mask to unsigned 32-bit: the native side sends a signed Int
              (e) => e.nativeValue() == (json['lightColor'] as int) & 0xFFFFFFFF,
              orElse: () => LightColor.transparent,
            )
          : null,
      sound: json['sound'] == null
          ? null
          : NotificationSoundUri.parse(json['sound'] as String),
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
      'lightColor': lightColor?.nativeValue(),
      'sound': sound?.toString(),
      'vibrationPattern': vibrationPattern?.toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationChannel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            importance == other.importance &&
            groupId == other.groupId &&
            canShowBadge == other.canShowBadge &&
            shouldShowLights == other.shouldShowLights &&
            shouldVibrate == other.shouldVibrate &&
            lightColor == other.lightColor &&
            sound == other.sound &&
            listEquals(vibrationPattern, other.vibrationPattern);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        importance,
        groupId,
        canShowBadge,
        shouldShowLights,
        shouldVibrate,
        lightColor,
        sound,
        vibrationPattern == null ? null : Object.hashAll(vibrationPattern!),
      );
}
