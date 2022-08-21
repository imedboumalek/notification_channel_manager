import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';
import '../../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Creating channels", () {
    testWidgets("Create a channel", (WidgetTester tester) async {
      app.main();
      final channel = NotificationChannel(
        id: "id",
        name: "name",
        description: "description",
        importance: NotificationChannelImportance.high,
      );
      final result = await NotificationChannelManager.upsertChannel(channel);
      expect(result.id, "id");
      expect(result.name, "name");
      expect(result.description, "description");
      expect(result.importance, NotificationChannelImportance.high);
      expect(result.groupId, null);
      expect(result.canBypassDnd, null);
      expect(result.canShowBadge, null);
      expect(result.shouldShowLights, null);
      expect(result.shouldVibrate, null);
      expect(result.lightColor, null);
      expect(result.sound, null);
      expect(result.vibrationPattern, null);
    });
  });
  tearDownAll(() async {});
}
