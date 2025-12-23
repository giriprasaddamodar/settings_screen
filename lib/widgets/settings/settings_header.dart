import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String title;

  const SettingsHeader({
    super.key,
    this.title = "Settings",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
