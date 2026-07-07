import 'package:flutter/material.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ChannelListPage());
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({super.key});

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  List<NotificationChannel> channels = [];
  List<NotificationChannelGroup> groups = [];
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final fetchedChannels = await NotificationChannelManager.getAllChannels();
    final fetchedGroups = await NotificationChannelManager.getAllGroups();
    if (!mounted) return;
    setState(() {
      channels = fetchedChannels;
      groups = fetchedGroups;
    });
  }

  Future<void> _createChannel() async {
    counter++;
    await NotificationChannelManager.createChannel(NotificationChannel(
      id: 'channel_$counter',
      name: 'Channel $counter',
      description: 'Created from the example app',
      importance: NotificationChannelImportance.high,
    ));
    await _refresh();
  }

  Future<void> _createGroup() async {
    counter++;
    await NotificationChannelManager.upsertGroup(NotificationChannelGroup(
      id: 'group_$counter',
      name: 'Group $counter',
      description: 'Created from the example app',
    ));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Channel Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Delete all channels and groups',
            onPressed: () async {
              await NotificationChannelManager.deleteAllChannels();
              await NotificationChannelManager.deleteAllGroups();
              await _refresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            if (groups.isNotEmpty)
              const ListTile(
                title: Text('Groups',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            for (final group in groups)
              ListTile(
                leading: const Icon(Icons.folder),
                title: Text(group.name),
                subtitle:
                    Text('${group.id} · ${group.channels.length} channel(s)'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await NotificationChannelManager.deleteGroup(group.id);
                    await _refresh();
                  },
                ),
              ),
            if (channels.isNotEmpty)
              const ListTile(
                title: Text('Channels',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            for (final channel in channels)
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(channel.name),
                subtitle: Text('${channel.id} · ${channel.importance.name}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await NotificationChannelManager.deleteChannel(channel.id);
                    await _refresh();
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'group',
            onPressed: _createGroup,
            icon: const Icon(Icons.create_new_folder),
            label: const Text('Group'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'channel',
            onPressed: _createChannel,
            icon: const Icon(Icons.add_alert),
            label: const Text('Channel'),
          ),
        ],
      ),
    );
  }
}
