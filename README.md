# notification_channel_manager (WIP)

A Android plugin to Manage (CRUD) NotificationChannels and NotificationChannelGroups.

## Useful Links

- [Android Notification Channels (Android Training)](https://developer.android.com/training/notify-user/channels)
- [NotificationChannel (API reference)](https://developer.android.com/reference/android/app/NotificationChannel)

- [NotificationChannelGroup (API reference)](https://developer.android.com/reference/android/app/NotificationChannelGroup)

- [NotificationManager (API reference)](https://developer.android.com/reference/android/app/NotificationManager)

## Things to keep in mind

- Notification Channels are an API 26 (Android 8) and above feature. If your app is targeting an older version of Android, no errors will be thrown, but the plugin won't do anything.

- Deleting a notification channel is soft delete, creating another with the same `id` will undelete it and keep the same settings as the old one. see [this](https://developer.android.com/reference/android/app/NotificationManager#deleteNotificationChannel).
- Deleting a notification channel group will delete all the channels in the group.
- The notification settings screen displays the number of deleted channels, as a spam prevention mechanism. You can clear test channels on development devices either by reinstalling the app or by clearing the data associated with your copy of the app.
- After creating a notification channel, you can only update the name, description, and importance;
- The importance of an existing channel will only be changed if the new importance is lower than the current value and the user has not altered any settings on this channel.
  Make sure to check the Android documentation for further information.

## ROADMAP

- Required features:
  - Create notification channel(s)
  - Create notification channel group(s)
  - Update notification channel(s)
  - Update notification channel group(s)
  - Delete notification channel(s)
  - Delete notification channel group(s)
  - Read notification channel(s)
  - Read notification channel group(s)
- Dart:
  - [x] Define classes for NotificationChannel and NotificationChannelGroup
  - [ ] Define a NotificationChannelManager class
  - [ ] Define interfaces for NotificationChannelManager to use with the Native API
- Android:
  - [ ] Implement functionalities on Native API

## Contributing

This project is open source. Contributions are more than welcome!

## Documentation

WIP
