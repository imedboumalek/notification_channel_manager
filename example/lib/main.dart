import 'package:flutter/material.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

import 'channel_detail_page.dart';
import 'channel_form_page.dart';
import 'group_form_page.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Channel Manager',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<NotificationChannel> channels = [];
  List<NotificationChannelGroup> groups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // rebuild so the FAB matches the active tab
    _tabController.addListener(() => setState(() {}));
    _refresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Future<void> _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete everything?'),
        content: const Text(
            'This deletes all notification channels and groups of this app. '
            'Android soft-deletes channels: recreating one with the same id '
            'restores its old settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await NotificationChannelManager.deleteAllChannels();
    await NotificationChannelManager.deleteAllGroups();
    await _refresh();
  }

  Future<void> _openChannelForm() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ChannelFormPage(groups: groups)),
    );
    if (created == true) await _refresh();
  }

  Future<void> _openGroupForm() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const GroupFormPage()),
    );
    if (created == true) await _refresh();
  }

  Future<void> _openChannelDetail(NotificationChannel channel) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ChannelDetailPage(channel: channel)),
    );
    if (changed == true) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Delete all',
            onPressed: _deleteAll,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Channels (${channels.length})'),
            Tab(text: 'Groups (${groups.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ChannelsTab(
            channels: channels,
            onRefresh: _refresh,
            onTap: _openChannelDetail,
          ),
          _GroupsTab(groups: groups, onRefresh: _refresh),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _openChannelForm,
              icon: const Icon(Icons.add_alert),
              label: const Text('Channel'),
            )
          : FloatingActionButton.extended(
              onPressed: _openGroupForm,
              icon: const Icon(Icons.create_new_folder),
              label: const Text('Group'),
            ),
    );
  }
}

class _ChannelsTab extends StatelessWidget {
  const _ChannelsTab({
    required this.channels,
    required this.onRefresh,
    required this.onTap,
  });

  final List<NotificationChannel> channels;
  final Future<void> Function() onRefresh;
  final void Function(NotificationChannel) onTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: channels.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No channels yet.\nCreate one below.')),
              ],
            )
          : ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final channel = channels[index];
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(channel.name),
                  subtitle: Text(
                      '${channel.id} · ${channel.importance.name}'
                      '${channel.groupId != null ? ' · in ${channel.groupId}' : ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete channel',
                    onPressed: () async {
                      await NotificationChannelManager.deleteChannel(
                          channel.id);
                      await onRefresh();
                    },
                  ),
                  onTap: () => onTap(channel),
                );
              },
            ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  const _GroupsTab({required this.groups, required this.onRefresh});

  final List<NotificationChannelGroup> groups;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: groups.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No groups yet.\nCreate one below.')),
              ],
            )
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ExpansionTile(
                  leading: const Icon(Icons.folder),
                  title: Text(group.name),
                  subtitle: Text(
                      '${group.id} · ${group.channels.length} channel(s)'
                      '${group.isBlocked ? ' · blocked' : ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete group and its channels',
                    onPressed: () async {
                      await NotificationChannelManager.deleteGroup(group.id);
                      await onRefresh();
                    },
                  ),
                  children: [
                    if (group.description.isNotEmpty)
                      ListTile(
                        dense: true,
                        title: Text(group.description),
                      ),
                    for (final channel in group.channels)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.notifications, size: 20),
                        title: Text(channel.name),
                        subtitle: Text(channel.id),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
