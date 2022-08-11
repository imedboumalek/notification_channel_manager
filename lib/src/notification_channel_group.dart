import 'package:notification_channel_manager/src/notification_channel.dart';

class NotificationChannelGroup {
  final String id;
  final String name;
  final String description;
  late final List<NotificationChannel> _channels;
  late final bool _isBlocked;

  NotificationChannelGroup({
    required this.id,
    required this.name,
    required this.description,
    required bool isBlocked,
    required List<NotificationChannel> channels,
  }) {
    _isBlocked = isBlocked;
    _channels = channels;
  }
  List<NotificationChannel> get channels => _channels;

  bool get isBlocked => _isBlocked;

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
}
