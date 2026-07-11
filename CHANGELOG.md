## (0.4.1+0)

- linked the pub.dev page to the GitHub repository and added topics (notifications, android, notification-channels) for discoverability

## (0.4.0+0)

- added conversation channel support (API 30+): parentChannelId/conversationId on NotificationChannel, conversation-aware getChannel lookup, and isConversation/isImportantConversation/isDemoted state
- added bubble support (API 29+): allowBubbles on NotificationChannel, plus areBubblesAllowed, areBubblesEnabled, and getBubblePreference
- exposed canBypassDnd on NotificationChannel
- added read-only channel state: hasUserSetImportance, hasUserSetSound, isBlockable

## (0.3.0+0)

- **BREAKING**: renamed `deleteMutliChannels` to `deleteMultiChannels`
- updated all dependencies: Dart 3 (sdk ^3.12.0), flutter_lints 6, AGP 9.0 / Kotlin 2.3 / Gradle 9.1 (Kotlin DSL)
- removed the equatable dependency; the plugin now depends only on Flutter and plugin_platform_interface
- raised Android minSdk from 16 to 24 (current Flutter minimum)
- rewrote the example app as a self-contained, full-featured demo: create channels with all options (importance, group, badge, lights + color, vibration), update channels, manage groups
- example app package moved to dev.imed.notification_channel_manager_example
- lightColor now reads back as null when Android reports no color set (0) or an unknown custom color
- documented the entire public API (dartdoc) and rewrote the README with usage examples and Android behavior notes

## (0.2.0+0)

- added lightColor support to NotificationChannel (LightColor.nativeValue() now returns the ARGB int instead of a hex string)
- fixed NotificationChannelGroup.isBlocked always being false: the native side never sent it (API 28+, false below)

## (0.1.1+2)

- fixed method calls executing on Android < 8 (API 26) instead of no-op
- fixed null channel sound being serialized as the string "null"
- guarded group description behind API 28 (where Android introduced it)
- removed leftover debug logging

## (0.1.1+1)

bug fix

## (0.1.1+0)

- fix to group read and write

## (0.1.0+1)

style fixes

## (0.1.0+0)

### Initial beta release

- Added tests
- Bug fixes and improvements
- added deleteAll functionallities

## (0.0.4-dev+0)

- added more fields to NotificationChannel Dart class
- bug fixes

## (0.0.3-dev+1)

updated readme

## (0.0.3-dev+0)

- implemented all features on native side
- implemented features on dart side
- created utility methods to map classes from/to maps

## (0.0.1-dev+2)

Implemented delete notification channel(s) on native side

## (0.0.1-dev+1)

Added notification channel and channel groups.

## (0.0.1-dev+0)

Initiliazed plugin
