import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;

  const SettingsSection(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
