import 'package:equatable/equatable.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';

class NotificationChannelGroup extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<NotificationChannel> channels;
  final bool isBlocked;

  const NotificationChannelGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.isBlocked,
    required this.channels,
  });

  factory NotificationChannelGroup.fromJson(Map<String, dynamic> json) {
    return NotificationChannelGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isBlocked: json['isBlocked'] as bool,
      channels: json['channels']
          .map((e) => NotificationChannel.fromJson(e as Map<String, dynamic>))
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
  List<Object> get props => [id, name, description, channels, isBlocked];
}
