import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'notification_channel_manager_method_channel.dart';

abstract class NotificationChannelManagerPlatform extends PlatformInterface {
  /// Constructs a NotificationChannelManagerPlatform.
  NotificationChannelManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationChannelManagerPlatform _instance = MethodChannelNotificationChannelManager();

  /// The default instance of [NotificationChannelManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelNotificationChannelManager].
  static NotificationChannelManagerPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NotificationChannelManagerPlatform] when
  /// they register themselves.
  static set instance(NotificationChannelManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
