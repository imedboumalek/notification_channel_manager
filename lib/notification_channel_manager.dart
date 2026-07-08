import 'package:notification_channel_manager/src/bubble_preference.dart';
import 'package:notification_channel_manager/src/notification_channel_group.dart';

import 'package:notification_channel_manager/src/notification_channel.dart';

import 'notification_channel_manager_platform_interface.dart';
export 'src/bubble_preference.dart';
export 'src/notification_channel_group.dart';
export 'src/notification_channel.dart';

/// Manages Android notification channels and notification channel groups.
///
/// Notification channels exist on Android 8.0 (API 26) and above. On older
/// versions every method in this class is a no-op: nothing is thrown, calls
/// simply complete (with `null`/empty results where a value is expected).
///
/// All members are static; this class is not meant to be instantiated.
///
/// A few Android behaviors to keep in mind:
///
/// * Deleting a channel is a **soft delete**: creating another channel with
///   the same id un-deletes it and restores its previous settings.
/// * Deleting a group also deletes all channels that belong to it.
/// * After a channel is created, only its name, description, and importance
///   can be changed — and Android only lowers importance, never raises it,
///   and only while the user hasn't altered the channel's settings.
class NotificationChannelManager {
  NotificationChannelManager._();

  /// Deletes the channel with the given [channelId].
  ///
  /// This is a soft delete: recreating a channel with the same id restores
  /// its previous settings. Does nothing if no such channel exists.
  static Future<void> deleteChannel(String channelId) {
    return NotificationChannelManagerPlatform.instance.deleteChannel(channelId);
  }

  /// Deletes the group with the given [channelGroupId], along with all
  /// channels that belong to it.
  ///
  /// Does nothing if no such group exists.
  static Future<void> deleteGroup(String channelGroupId) {
    return NotificationChannelManagerPlatform.instance
        .deleteGroup(channelGroupId);
  }

  /// Deletes every group in [channelGroupIds], along with all channels that
  /// belong to them.
  ///
  /// Ids that don't match an existing group are ignored.
  static Future<void> deleteGroups(List<String> channelGroupIds) {
    return NotificationChannelManagerPlatform.instance
        .deleteGroups(channelGroupIds);
  }

  /// Deletes every channel in [channelIds].
  ///
  /// Like [deleteChannel], each deletion is a soft delete. Ids that don't
  /// match an existing channel are ignored.
  static Future<void> deleteMultiChannels(List<String> channelIds) {
    return NotificationChannelManagerPlatform.instance
        .deleteMultiChannels(channelIds);
  }

  /// Returns all notification channels of this app.
  ///
  /// Soft-deleted channels are not included. Returns an empty list below
  /// API 26.
  static Future<List<NotificationChannel>> getAllChannels() {
    return NotificationChannelManagerPlatform.instance.getAllChannels();
  }

  /// Returns all notification channel groups of this app, each populated
  /// with the channels that belong to it.
  ///
  /// Returns an empty list below API 26.
  static Future<List<NotificationChannelGroup>> getAllGroups() {
    return NotificationChannelManagerPlatform.instance.getAllGroups();
  }

  /// Returns the channel with the given [channelId], or `null` if it does
  /// not exist (or below API 26).
  ///
  /// Pass [conversationId] to look up a conversation channel; if no
  /// conversation channel exists for that conversation, the parent channel
  /// with id [channelId] is returned instead (Android 11+ behavior).
  static Future<NotificationChannel?> getChannel(String channelId,
      {String? conversationId}) {
    return NotificationChannelManagerPlatform.instance
        .getChannel(channelId, conversationId: conversationId);
  }

  /// Returns the group with the given [groupId] populated with its channels,
  /// or `null` if it does not exist (or below API 26).
  static Future<NotificationChannelGroup?> getGroup(String groupId) {
    return NotificationChannelManagerPlatform.instance.getGroup(groupId);
  }

  /// Creates [notificationChannel] and returns it as Android stored it.
  ///
  /// The returned channel may differ from the input: Android fills in
  /// defaults (e.g. the system notification sound) and may clamp values.
  ///
  /// If [NotificationChannel.groupId] refers to a group that doesn't exist
  /// yet, the group is created automatically, using the id as its name.
  ///
  /// Creating a channel whose id already exists updates the fields Android
  /// allows updating (see [updateChannel]) and restores the channel if it
  /// was soft-deleted.
  static Future<NotificationChannel> createChannel(
      NotificationChannel notificationChannel) {
    return NotificationChannelManagerPlatform.instance
        .createChannel(notificationChannel);
  }

  /// Creates every channel in [channels] and returns them as Android stored
  /// them. See [createChannel] for the exact semantics.
  static Future<List<NotificationChannel>> createChannels(
      List<NotificationChannel> channels) {
    return NotificationChannelManagerPlatform.instance.createChannels(channels);
  }

  /// Applies [update] to an existing channel and returns the resulting
  /// channel as Android stored it.
  ///
  /// Only name, description, and importance can change after creation.
  /// Android only ever *lowers* importance, and only while the user hasn't
  /// altered the channel's settings; the other fields keep the values the
  /// channel was created with.
  static Future<NotificationChannel> updateChannel(
      NotificationChannelUpdate update) {
    return NotificationChannelManagerPlatform.instance.updateChannel(update);
  }

  /// Applies every update in [updates] and returns the resulting channels as
  /// Android stored them. See [updateChannel] for the exact semantics.
  static Future<List<NotificationChannel>> updateChannels(
      List<NotificationChannelUpdate> updates) {
    return NotificationChannelManagerPlatform.instance.updateChannels(updates);
  }

  /// Deletes every notification channel of this app.
  ///
  /// Like [deleteChannel], each deletion is a soft delete.
  static Future<void> deleteAllChannels() {
    return NotificationChannelManagerPlatform.instance.deleteAllChannels();
  }

  /// Creates [notificationChannelGroup], or updates its name and description
  /// if a group with the same id already exists.
  ///
  /// Returns the group as Android stored it, populated with its channels.
  static Future<NotificationChannelGroup> upsertGroup(
      NotificationChannelGroup notificationChannelGroup) {
    return NotificationChannelManagerPlatform.instance
        .upsertGroup(notificationChannelGroup);
  }

  /// Creates or updates every group in [groups] and returns them as Android
  /// stored them. See [upsertGroup] for the exact semantics.
  static Future<List<NotificationChannelGroup>> upsertGroups(
      List<NotificationChannelGroup> groups) {
    return NotificationChannelManagerPlatform.instance.upsertGroups(groups);
  }

  /// Deletes every notification channel group of this app, along with all
  /// channels that belong to a group.
  static Future<void> deleteAllGroups() {
    return NotificationChannelManagerPlatform.instance.deleteAllGroups();
  }

  /// Whether notifications of this app are allowed to bubble at all.
  ///
  /// Always false below Android 10 (API 29). See
  /// [NotificationChannel.allowBubbles] for the per-channel setting.
  static Future<bool> areBubblesAllowed() {
    return NotificationChannelManagerPlatform.instance.areBubblesAllowed();
  }

  /// Whether bubbles are enabled system-wide on this device.
  ///
  /// Always false below Android 12 (API 31), where there is no system-wide
  /// toggle.
  static Future<bool> areBubblesEnabled() {
    return NotificationChannelManagerPlatform.instance.areBubblesEnabled();
  }

  /// The user's app-level bubble preference from the system settings.
  ///
  /// On Android 10 and 11 (API 29–30), where the preference doesn't exist
  /// yet, this is derived from [areBubblesAllowed]. Always
  /// [BubblePreference.none] below API 29.
  static Future<BubblePreference> getBubblePreference() {
    return NotificationChannelManagerPlatform.instance.getBubblePreference();
  }
}
