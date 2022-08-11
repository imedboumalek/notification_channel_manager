import 'package:notification_channel_manager/src/notification_channel.dart';
import 'package:notification_channel_manager/src/notification_channel_group.dart';

import 'notification_channel_manager_platform_interface.dart';

class NotificationChannelManager {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      await NotificationChannelManagerPlatform.instance.initialize();
      _initialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  Future<List<NotificationChannelGroup>> getNotificationChannelGroups() {
    return _ensureInitialized().then((_) {
      return NotificationChannelManagerPlatform.instance.getNotificationChannelGroups();
    });
  }

  Future<List<NotificationChannel>> getNotificationChannels() {
    return _ensureInitialized().then((_) {
      return NotificationChannelManagerPlatform.instance.getNotificationChannels();
    });
  }
}
