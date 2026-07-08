import 'dart:typed_data';

import 'package:flutter/foundation.dart';

part 'notification_sound.dart';

part 'notification_channel_importance.dart';
part 'notification_channel_light_color.dart';

/// The set of fields Android allows changing on an existing channel.
///
/// Pass to [NotificationChannelManager.updateChannel]. Note that Android
/// only ever *lowers* importance, never raises it, and only while the user
/// hasn't altered the channel's settings.
class NotificationChannelUpdate {
  /// The id of the existing channel to update.
  final String id;

  /// The new user-visible name.
  final String name;

  /// The new user-visible description.
  final String description;

  /// The new importance. Only applied if lower than the current value.
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

/// An Android notification channel.
///
/// Mirrors Android's `NotificationChannel`. Only [name], [description], and
/// [importance] can change after the channel is created; every other field
/// is fixed at creation time (see [NotificationChannelUpdate]).
class NotificationChannel {
  /// Unique id of the channel, used when posting notifications to it.
  final String id;

  /// User-visible name, shown in the system notification settings.
  final String name;

  /// User-visible description, shown in the system notification settings.
  final String description;

  /// How interruptive notifications on this channel are.
  final NotificationChannelImportance importance;

  /// Id of the [NotificationChannelGroup] this channel belongs to, if any.
  ///
  /// When creating a channel with a [groupId] that doesn't exist yet, the
  /// group is created automatically using the id as its name.
  final String? groupId;

  /// Whether notifications on this channel can show a launcher badge.
  final bool canShowBadge;

  /// Whether notifications on this channel light up the notification LED,
  /// on devices that have one. See [lightColor].
  final bool shouldShowLights;

  /// Whether notifications on this channel vibrate. See [vibrationPattern].
  final bool shouldVibrate;

  /// The notification LED color, only meaningful when [shouldShowLights] is
  /// true.
  ///
  /// Reads back as `null` when no color was set or when Android reports a
  /// custom color that none of the [LightColor] presets represent.
  final LightColor? lightColor;

  /// The sound played by notifications on this channel.
  ///
  /// `null` at creation means Android's default notification sound; reading
  /// the channel back returns the actual sound URI Android stored.
  final NotificationSoundUri? sound;

  /// The vibration pattern (delays and durations in milliseconds, starting
  /// with a delay), only meaningful when [shouldVibrate] is true.
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
      lightColor: json['shouldShowLights'] == true
          ? _lightColorFromNative(json['lightColor'] as int?)
          : null,
      sound: json['sound'] == null
          ? null
          : NotificationSoundUri.parse(json['sound'] as String),
      vibrationPattern: json['vibrationPattern'] == null
          ? null
          : Uint64List.fromList((json['vibrationPattern'] as List).map((e) => e as int).toList()),
    );
  }
  /// Android reports 0 when no light color was set; unknown custom colors
  /// can't be represented by the [LightColor] presets, so both read as null.
  static LightColor? _lightColorFromNative(int? nativeValue) {
    if (nativeValue == null) return null;
    // mask to unsigned 32-bit: the native side sends a signed Int
    final masked = nativeValue & 0xFFFFFFFF;
    if (masked == 0) return null;
    for (final color in LightColor.values) {
      if (color.nativeValue() == masked) return color;
    }
    return null;
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
