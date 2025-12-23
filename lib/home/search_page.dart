import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Always extract colorScheme from theme
    final colorScheme = Theme.of(context).colorScheme;

      return Center(
        child: Text(
          "Home Page Content Here",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
    );
  }
}
