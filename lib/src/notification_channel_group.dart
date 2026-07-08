import 'package:flutter/foundation.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';

/// An Android notification channel group, used to organize channels in the
/// system notification settings (e.g. one group per account).
///
/// Mirrors Android's `NotificationChannelGroup`. Deleting a group also
/// deletes all channels that belong to it.
class NotificationChannelGroup {
  /// Unique id of the group, referenced by [NotificationChannel.groupId].
  final String id;

  /// User-visible name, shown in the system notification settings.
  final String name;

  /// User-visible description. Only supported on Android 9 (API 28) and
  /// above; below that it is ignored on write and empty on read.
  final String description;

  /// The channels belonging to this group.
  ///
  /// Read-only: populated when reading groups back. To put a channel in a
  /// group, set [NotificationChannel.groupId] when creating the channel.
  final List<NotificationChannel> channels;

  /// Whether the user has blocked this group's notifications. Read-only,
  /// and always false below Android 9 (API 28).
  final bool isBlocked;

  const NotificationChannelGroup({
    required this.id,
    required this.name,
    this.description = "",
    this.isBlocked = false,
    this.channels = const [],
  });

  factory NotificationChannelGroup.fromJson(Map<String, dynamic> json) {
    return NotificationChannelGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      isBlocked: json['isBlocked'] ?? false,
      channels: (json['channels'] as List<Map<String, dynamic>>)
          .map((e) => NotificationChannel.fromJson(e))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isBlocked': isBlocked,
      'channels': channels.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationChannelGroup &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            isBlocked == other.isBlocked &&
            listEquals(channels, other.channels);
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, isBlocked, Object.hashAll(channels));
}
