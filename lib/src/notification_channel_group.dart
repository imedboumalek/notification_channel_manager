import 'package:flutter/foundation.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';

class NotificationChannelGroup {
  final String id;
  final String name;
  final String description;
  final List<NotificationChannel> channels;
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
