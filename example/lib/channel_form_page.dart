import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_channel_manager/notification_channel_manager.dart';

/// Creates a channel, demonstrating every option the plugin supports at
/// creation time: importance, group, badge, lights (with color), vibration.
class ChannelFormPage extends StatefulWidget {
  const ChannelFormPage({super.key, required this.groups});

  final List<NotificationChannelGroup> groups;

  @override
  State<ChannelFormPage> createState() => _ChannelFormPageState();
}

class _ChannelFormPageState extends State<ChannelFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  var importance = NotificationChannelImportance.defaultImportance;
  String? groupId;
  var canShowBadge = true;
  var shouldShowLights = false;
  var lightColor = LightColor.white;
  var shouldVibrate = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await NotificationChannelManager.createChannel(NotificationChannel(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        importance: importance,
        groupId: groupId,
        canShowBadge: canShowBadge,
        shouldShowLights: shouldShowLights,
        lightColor: shouldShowLights ? lightColor : null,
        shouldVibrate: shouldVibrate,
      ));
      if (!mounted) return;
      Navigator.pop(context, true);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create channel: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New channel')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Id',
                helperText: 'Recreating a deleted id restores its settings',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: groupId,
              decoration: const InputDecoration(labelText: 'Group'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                for (final group in widget.groups)
                  DropdownMenuItem(value: group.id, child: Text(group.name)),
              ],
              onChanged: (value) => setState(() => groupId = value),
            ),
            SwitchListTile(
              title: const Text('Show badge'),
              value: canShowBadge,
              onChanged: (value) => setState(() => canShowBadge = value),
            ),
            SwitchListTile(
              title: const Text('Show lights'),
              value: shouldShowLights,
              onChanged: (value) => setState(() => shouldShowLights = value),
            ),
            if (shouldShowLights)
              DropdownButtonFormField<LightColor>(
                initialValue: lightColor,
                decoration: const InputDecoration(labelText: 'Light color'),
                items: [
                  for (final value in LightColor.values)
                    DropdownMenuItem(value: value, child: Text(value.name)),
                ],
                onChanged: (value) => setState(() => lightColor = value!),
              ),
            SwitchListTile(
              title: const Text('Vibrate'),
              value: shouldVibrate,
              onChanged: (value) => setState(() => shouldVibrate = value),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Create channel'),
            ),
          ],
        ),
      ),
    );
  }
}
