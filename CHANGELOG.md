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
