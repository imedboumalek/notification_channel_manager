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

  /// Id of the channel this conversation channel is based on, if this is a
  /// conversation channel. Set together with [conversationId].
  ///
  /// Conversation channels give users per-conversation notification settings
  /// (e.g. per contact in a messaging app). Create the parent channel first,
  /// then create the conversation channel with the same options plus
  /// [parentChannelId] and [conversationId]. Requires Android 11 (API 30);
  /// below that the channel is created as a regular channel.
  final String? parentChannelId;

  /// Id identifying the conversation within [parentChannelId], typically a
  /// shortcut id. Set together with [parentChannelId].
  final String? conversationId;

  /// Whether notifications on this channel can bypass Do Not Disturb.
  ///
  /// The system may require the user to grant DND access before this takes
  /// effect.
  final bool canBypassDnd;

  /// Whether notifications on this channel can appear as
  /// [bubbles](https://developer.android.com/develop/ui/views/notifications/bubbles).
  ///
  /// Only meaningful on conversation channels. Android only honors the
  /// opt-in when the user has allowed bubbles for the app (see
  /// [NotificationChannelManager.areBubblesAllowed]); otherwise the channel
  /// reads back false. Requires Android 10 (API 29); ignored and false
  /// below.
  final bool allowBubbles;

  /// Read-only: whether the user changed this channel's importance in the
  /// system settings — in which case [NotificationChannelUpdate.importance]
  /// no longer has any effect. Always false below Android 10 (API 29).
  final bool hasUserSetImportance;

  /// Read-only: whether the user changed this channel's sound in the system
  /// settings. Always false below Android 11 (API 30).
  final bool hasUserSetSound;

  /// Read-only: whether this channel was explicitly marked blockable.
  ///
  /// Only meaningful for system apps whose channels are otherwise
  /// unblockable — Android reports false for regular app channels even
  /// though the user can always block those. Always false below Android 13
  /// (API 33).
  final bool isBlockable;

  /// Read-only: whether this is a conversation channel (see
  /// [parentChannelId]). Always false below Android 11 (API 30).
  final bool isConversation;

  /// Read-only: whether the user marked this conversation as important.
  /// Always false below Android 11 (API 30).
  final bool isImportantConversation;

  /// Read-only: whether the user demoted this conversation channel back to a
  /// regular channel in the system settings. Always false below Android 12
  /// (API 31).
  final bool isDemoted;

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
    this.parentChannelId,
    this.conversationId,
    this.canShowBadge = true,
    this.shouldShowLights = false,
    this.shouldVibrate = false,
    this.canBypassDnd = false,
    this.allowBubbles = false,
    this.lightColor,
    this.sound,
    this.vibrationPattern,
    this.hasUserSetImportance = false,
    this.hasUserSetSound = false,
    this.isBlockable = false,
    this.isConversation = false,
    this.isImportantConversation = false,
    this.isDemoted = false,
  }) : assert(
          (parentChannelId == null) == (conversationId == null),
          'parentChannelId and conversationId must be set together',
        );

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
      parentChannelId: json['parentChannelId'] as String?,
      conversationId: json['conversationId'] as String?,
      canShowBadge: json['canShowBadge'] as bool,
      shouldShowLights: json['shouldShowLights'] as bool,
      shouldVibrate: json['shouldVibrate'] as bool,
      canBypassDnd: json['canBypassDnd'] as bool? ?? false,
      allowBubbles: json['allowBubbles'] as bool? ?? false,
      hasUserSetImportance: json['hasUserSetImportance'] as bool? ?? false,
      hasUserSetSound: json['hasUserSetSound'] as bool? ?? false,
      isBlockable: json['isBlockable'] as bool? ?? false,
      isConversation: json['isConversation'] as bool? ?? false,
      isImportantConversation:
          json['isImportantConversation'] as bool? ?? false,
      isDemoted: json['isDemoted'] as bool? ?? false,
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
      'parentChannelId': parentChannelId,
      'conversationId': conversationId,
      'canShowBadge': canShowBadge,
      'shouldShowLights': shouldShowLights,
      'shouldVibrate': shouldVibrate,
      'canBypassDnd': canBypassDnd,
      'allowBubbles': allowBubbles,
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
            parentChannelId == other.parentChannelId &&
            conversationId == other.conversationId &&
            canShowBadge == other.canShowBadge &&
            shouldShowLights == other.shouldShowLights &&
            shouldVibrate == other.shouldVibrate &&
            canBypassDnd == other.canBypassDnd &&
            allowBubbles == other.allowBubbles &&
            lightColor == other.lightColor &&
            sound == other.sound &&
            listEquals(vibrationPattern, other.vibrationPattern) &&
            hasUserSetImportance == other.hasUserSetImportance &&
            hasUserSetSound == other.hasUserSetSound &&
            isBlockable == other.isBlockable &&
            isConversation == other.isConversation &&
            isImportantConversation == other.isImportantConversation &&
            isDemoted == other.isDemoted;
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        description,
        importance,
        groupId,
        parentChannelId,
        conversationId,
        canShowBadge,
        shouldShowLights,
        shouldVibrate,
        canBypassDnd,
        allowBubbles,
        lightColor,
        sound,
        vibrationPattern == null ? null : Object.hashAll(vibrationPattern!),
        hasUserSetImportance,
        hasUserSetSound,
        isBlockable,
        isConversation,
        isImportantConversation,
        isDemoted,
      ]);
}
