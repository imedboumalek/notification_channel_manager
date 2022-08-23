import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:flutter/material.dart';

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
        openFloatingActionButton: const Icon(Icons.add),
        closeFloatingActionButton: const Icon(Icons.close),
      ),
    );
  }
}
