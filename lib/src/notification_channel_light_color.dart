part of "notification_channel.dart";

/// Preset colors for the notification LED, matching Android's
/// `android.graphics.Color` constants.
///
/// Set [NotificationChannel.lightColor] together with
/// [NotificationChannel.shouldShowLights]. Note that many modern devices no
/// longer have a notification LED, in which case the color has no visible
/// effect.
enum LightColor {
  black,
  dkGray,
  gray,
  ltGray,
  white,
  red,
  green,
  blue,
  yellow,
  cyan,
  magenta,
  transparent;

  /// maps the current color to the corresponding ARGB value
  /// used by the native platform (android.graphics.Color constants).
  int nativeValue() {
    switch (this) {
      case LightColor.black:
        return 0xFF000000;
      case LightColor.dkGray:
        return 0xFF444444;
      case LightColor.gray:
        return 0xFF888888;
      case LightColor.ltGray:
        return 0xFFCCCCCC;
      case LightColor.white:
        return 0xFFFFFFFF;
      case LightColor.red:
        return 0xFFFF0000;
      case LightColor.green:
        return 0xFF00FF00;
      case LightColor.blue:
        return 0xFF0000FF;
      case LightColor.yellow:
        return 0xFFFFFF00;
      case LightColor.cyan:
        return 0xFF00FFFF;
      case LightColor.magenta:
        return 0xFFFF00FF;
      case LightColor.transparent:
        return 0;
    }
  }
}
