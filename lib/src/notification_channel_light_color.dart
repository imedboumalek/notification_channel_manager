part of "notification_channel.dart";

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

  String nativeValue() {
    switch (this) {
      case LightColor.black:
        return "000000";
      case LightColor.dkGray:
        return "444444";
      case LightColor.gray:
        return "888888";
      case LightColor.ltGray:
        return "CCCCCC";
      case LightColor.white:
        return "FFFFFF";
      case LightColor.red:
        return "FF0000";
      case LightColor.green:
        return "00FF00";
      case LightColor.blue:
        return "0000FF";
      case LightColor.yellow:
        return "FFFF00";
      case LightColor.cyan:
        return "00FFFF";
      case LightColor.magenta:
        return "FF00FF";
      case LightColor.transparent:
        return "0";
    }
  }
}
