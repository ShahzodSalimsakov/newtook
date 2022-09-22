import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return // toggle notification with text
        SafeArea(
      child: SwitchListTile(
        title: const Text('Enable Notifications'),
        value: true,
        onChanged: (value) {
          value = !value;
        },
      ),
    );
  }
}
