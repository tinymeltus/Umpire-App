import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SwitchPreference(
              title: 'Enable Notifications',
              value: true, // Change this to control the switch state
              onChanged: (value) {
                // Handle switch state change
              },
            ),
            SizedBox(height: 20),
            Text(
              'App Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Language'),
              subtitle: Text('English'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Navigate to language selection screen
              },
            ),
            ListTile(
              title: Text('Theme'),
              subtitle: Text('Light'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Navigate to theme selection screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchPreference extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  SwitchPreference({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
