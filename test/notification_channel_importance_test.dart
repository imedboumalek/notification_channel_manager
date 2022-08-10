import 'package:flutter_test/flutter_test.dart';
import 'package:notification_channel_manager/src/notification_channel_importance.dart';

void main() {
  test(
    'NotificationChannelImportance nativeValue',
    () {
      expect(NotificationChannelImportance.unspecified.nativeValue(), -1000);
      expect(NotificationChannelImportance.none.nativeValue(), 0);
      expect(NotificationChannelImportance.min.nativeValue(), 1);
      expect(NotificationChannelImportance.low.nativeValue(), 2);
      expect(NotificationChannelImportance.defaultImportance.nativeValue(), 3);
      expect(NotificationChannelImportance.high.nativeValue(), 4);
    },
  );
}
