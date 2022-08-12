import 'notification_channel_manager_platform_interface.dart';

class NotificationChannelManager {
  Future<void> deleteChannel(String channelId) async {
    return NotificationChannelManagerPlatform.instance.deleteChannel(channelId);
  }
}
