import 'package:notification_channel_manager/src/notification_channel.dart';
import 'package:notification_channel_manager/src/notification_channel_group.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'notification_channel_manager_method_channel.dart';

abstract class NotificationChannelManagerPlatform extends PlatformInterface {
  /// Constructs a NotificationChannelManagerPlatform.
  NotificationChannelManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationChannelManagerPlatform _instance = MethodChannelNotificationChannelManager();

  /// The default instance of [NotificationChannelManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelNotificationChannelManager].
  static NotificationChannelManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NotificationChannelManagerPlatform] when
  /// they register themselves.
  static set instance(NotificationChannelManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<NotificationChannel>> getAllChannels() {
    throw UnimplementedError('getNotificationChannels() has not been implemented.');
  }

  Future<List<NotificationChannelGroup>> getAllChannelGroups() {
    throw UnimplementedError('getNotificationChannelGroups() has not been implemented.');
  }

  Future<NotificationChannel> getChannelById(String channelId) {
    throw UnimplementedError('getNotificationChannel() has not been implemented.');
  }

  Future<List<NotificationChannel>> getMultiChannelsByIds(List<String> channelIds) {
    throw UnimplementedError('getMultiNotificationChannels() has not been implemented.');
  }

  Future<NotificationChannel> upsertNotificationChannel(NotificationChannel notificationChannel) {
    throw UnimplementedError('upsertNotificationChannel() has not been implemented.');
  }

  Future<NotificationChannelGroup> upsertNotificationChannelGroup(
      NotificationChannelGroup notificationChannelGroup) {
    throw UnimplementedError('upsertNotificationChannelGroup() has not been implemented.');
  }

  Future<void> deleteChannel(String channelId) {
    throw UnimplementedError('deleteChannel() has not been implemented.');
  }

  Future<void> deleteMutliChannels(List<String> channelIds) {
    throw UnimplementedError('deleteChannels() has not been implemented.');
  }

  Future<void> deleteChannelGroup(String channelGroupId) {
    throw UnimplementedError('deleteChannelGroup() has not been implemented.');
  }

  Future<void> deleteMultiChannelGroups(List<String> channelGroupIds) {
    throw UnimplementedError('deleteChannelGroups() has not been implemented.');
  }
}
