import 'dart:typed_data';

import 'package:notification_channel_manager/notification_channel_manager.dart';

const channelsWithRequiredFieldsOnly = [
  NotificationChannel(
    id: 'channel1',
    name: 'Channel 1',
    description: 'Channel 1 description',
    importance: NotificationChannelImportance.high,
  ),
  NotificationChannel(
    id: 'channel2',
    name: 'Channel 2',
    description: 'Channel 2 description',
    importance: NotificationChannelImportance.high,
  ),
  NotificationChannel(
    id: 'channel3',
    name: 'Channel 3',
    description: 'Channel 3 description',
    importance: NotificationChannelImportance.high,
  )
];

final channelsWithAllFields = [
  NotificationChannel(
    id: 'channel1',
    name: 'Channel 1',
    description: 'Channel 1 description',
    importance: NotificationChannelImportance.high,
    groupId: 'group1',
    canShowBadge: true,
    shouldShowLights: true,
    shouldVibrate: true,
    // lightColor: LightColor.red,
    sound: NotificationSoundUri.parse(
        'android.resource://com.example.app/raw/notification'),
    vibrationPattern: Uint64List.fromList([0, 1000, 500, 1000]),
  ),
  NotificationChannel(
    id: 'channel2',
    name: 'Channel 2',
    description: 'Channel 2 description',
    importance: NotificationChannelImportance.min,
    groupId: 'group2',
    canShowBadge: true,
    shouldShowLights: true,
    shouldVibrate: true,
    sound: NotificationSoundUri.parse(
        'content://settings/system/notification_sound'),
  ),
  NotificationChannel(
    id: 'channel3',
    name: 'Channel 3',
    description: 'Channel 3 description',
    importance: NotificationChannelImportance.none,
    groupId: 'group3',
    canShowBadge: true,
    shouldShowLights: true,
    shouldVibrate: true,
    // lightColor: LightColor.red,
    sound: NotificationSoundUri.parse(
        'android.resource://com.example.app/raw/notification'),
    vibrationPattern: Uint64List.fromList([0, 1000, 500, 1000]),
  )
];
