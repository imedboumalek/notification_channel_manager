import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

/// Shows a channel as Android stored it and lets you update the fields
/// Android allows changing after creation: name, description, importance.
class ChannelDetailPage extends StatefulWidget {
  const ChannelDetailPage({super.key, required this.channel});

  final NotificationChannel channel;

  @override
  State<ChannelDetailPage> createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  late final _nameController = TextEditingController(text: widget.channel.name);
  late final _descriptionController =
      TextEditingController(text: widget.channel.description);
  late var importance = widget.channel.importance;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await NotificationChannelManager.updateChannel(NotificationChannelUpdate(
        id: widget.channel.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        importance: importance,
      ));
      if (!mounted) return;
      Navigator.pop(context, true);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update channel: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;
    return Scaffold(
      appBar: AppBar(title: Text(channel.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('As stored by Android',
              style: Theme.of(context).textTheme.titleMedium),
          ListTile(dense: true, title: const Text('Id'), trailing: Text(channel.id)),
          ListTile(
            dense: true,
            title: const Text('Group'),
            trailing: Text(channel.groupId ?? '—'),
          ),
          ListTile(
            dense: true,
            title: const Text('Badge'),
            trailing: Text(channel.canShowBadge ? 'yes' : 'no'),
          ),
          ListTile(
            dense: true,
            title: const Text('Lights'),
            trailing: Text(channel.shouldShowLights
                ? (channel.lightColor?.name ?? 'on')
                : 'off'),
          ),
          ListTile(
            dense: true,
            title: const Text('Vibration'),
            trailing: Text(channel.shouldVibrate ? 'on' : 'off'),
          ),
          ListTile(
            dense: true,
            title: const Text('Bypasses Do Not Disturb'),
            trailing: Text(channel.canBypassDnd ? 'yes' : 'no'),
          ),
          if (channel.isConversation)
            ListTile(
              dense: true,
              title: const Text('Conversation'),
              trailing: Text(
                  '${channel.parentChannelId} · ${channel.conversationId}'
                  '${channel.isImportantConversation ? ' · important' : ''}'
                  '${channel.isDemoted ? ' · demoted' : ''}'),
            ),
          ListTile(
            dense: true,
            title: const Text('Bubbles'),
            trailing: Text(channel.allowBubbles ? 'allowed' : 'off'),
          ),
          if (channel.hasUserSetImportance || channel.hasUserSetSound)
            ListTile(
              dense: true,
              title: const Text('Changed by user'),
              trailing: Text([
                if (channel.hasUserSetImportance) 'importance',
                if (channel.hasUserSetSound) 'sound',
              ].join(', ')),
            ),
          ListTile(
            dense: true,
            title: const Text('Sound'),
            trailing: SizedBox(
              width: 200,
              child: Text(
                channel.sound?.toString() ?? '—',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const Divider(height: 32),
          Text('Update', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Android only allows changing name, description, and importance '
            'after creation — and importance can only be lowered.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<NotificationChannelImportance>(
            initialValue: importance,
            decoration: const InputDecoration(labelText: 'Importance'),
            items: [
              for (final value in NotificationChannelImportance.values)
                DropdownMenuItem(value: value, child: Text(value.name)),
            ],
            onChanged: (value) => setState(() => importance = value!),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Update channel'),
          ),
        ],
      ),
    );
  }
}
