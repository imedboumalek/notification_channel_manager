import 'package:notification_channel_manager/src/bubble_preference.dart';
import 'package:notification_channel_manager/src/notification_channel.dart';
import 'package:notification_channel_manager/src/notification_channel_group.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'notification_channel_manager_method_channel.dart';

abstract class NotificationChannelManagerPlatform extends PlatformInterface {
  /// Constructs a NotificationChannelManagerPlatform.
  NotificationChannelManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationChannelManagerPlatform _instance =
      MethodChannelNotificationChannelManager();

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
    throw UnimplementedError(
        'getAllChannels() has not been implemented.');
  }

  Future<NotificationChannel?> getChannel(String channelId,
      {String? conversationId}) {
    throw UnimplementedError(
        'getChannel() has not been implemented.');
  }

  Future<NotificationChannel> createChannel(
      NotificationChannel notificationChannel) {
    throw UnimplementedError(
        'createChannel() has not been implemented.');
  }

  Future<List<NotificationChannel>> createChannels(
      List<NotificationChannel> channels) {
    throw UnimplementedError('createChannels() has not been implemented.');
  }

  Future<NotificationChannel> updateChannel(NotificationChannelUpdate update) {
    throw UnimplementedError(
        'updateChannel() has not been implemented.');
  }

  Future<List<NotificationChannel>> updateChannels(
      List<NotificationChannelUpdate> updates) {
    throw UnimplementedError('updateChannels() has not been implemented.');
  }

  Future<void> deleteChannel(String channelId) {
    throw UnimplementedError('deleteChannel() has not been implemented.');
  }

  Future<void> deleteMultiChannels(List<String> channelIds) {
    throw UnimplementedError('deleteMultiChannels() has not been implemented.');
  }

  Future<void> deleteAllChannels() {
    throw UnimplementedError('deleteAllChannels() has not been implemented.');
  }

  Future<List<NotificationChannelGroup>> getAllGroups() {
    throw UnimplementedError(
        'getAllGroups() has not been implemented.');
  }

  Future<NotificationChannelGroup?> getGroup(String groupId) {
    throw UnimplementedError(
        'getGroup() has not been implemented.');
  }

  Future<NotificationChannelGroup> upsertGroup(
      NotificationChannelGroup notificationChannelGroup) {
    throw UnimplementedError(
        'upsertGroup() has not been implemented.');
  }

  Future<List<NotificationChannelGroup>> upsertGroups(
      List<NotificationChannelGroup> groups) {
    throw UnimplementedError('upsertGroups() has not been implemented.');
  }

  Future<void> deleteGroup(String channelGroupId) {
    throw UnimplementedError('deleteGroup() has not been implemented.');
  }

  Future<void> deleteGroups(List<String> channelGroupIds) {
    throw UnimplementedError('deleteGroups() has not been implemented.');
  }

  Future<void> deleteAllGroups() {
    throw UnimplementedError(
        'deleteAllGroups() has not been implemented.');
  }

  Future<bool> areBubblesAllowed() {
    throw UnimplementedError('areBubblesAllowed() has not been implemented.');
  }

  Future<bool> areBubblesEnabled() {
    throw UnimplementedError('areBubblesEnabled() has not been implemented.');
  }

  Future<BubblePreference> getBubblePreference() {
    throw UnimplementedError(
        'getBubblePreference() has not been implemented.');
  }
}
