enum LightColor {
  red,
  orange,
  yellow,
  green,
  blue,
  purple,
  white;

  int nativeValue() {
    switch (this) {
      case LightColor.red:
        return 0;
      case LightColor.orange:
        return 1;
      case LightColor.yellow:
        return 2;
      case LightColor.green:
        return 3;
      case LightColor.blue:
        return 4;
      case LightColor.purple:
        return 5;
      case LightColor.white:
        return 6;
    }
  }
}
