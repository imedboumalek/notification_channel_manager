import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showMenu = false;
  @override
  void initState() {
    super.initState();
    NotificationChannelManager.upsertChannels([
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
      ),
    ]).then((channels) {
      print("success");
      print(channels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomFloatingActionButton(
        body: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: const Center(
            child: Text('Hello world'),
          ),
        ),
        options: const [
          CircleAvatar(
            child: Icon(Icons.height),
          ),
          CircleAvatar(
            child: Icon(Icons.title),
          ),
        ],
        openFloatingActionButton: Icon(Icons.add),
        closeFloatingActionButton: Icon(Icons.close),
      ),
    );
  }
}
