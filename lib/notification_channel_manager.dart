
import 'notification_channel_manager_platform_interface.dart';

class NotificationChannelManager {
  Future<String?> getPlatformVersion() {
    return NotificationChannelManagerPlatform.instance.getPlatformVersion();
  }
}
