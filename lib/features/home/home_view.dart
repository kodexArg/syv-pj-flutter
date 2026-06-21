import 'package:flutter/material.dart';

/// Placeholder landing view. Stands in for the first real feature module
/// (the character visualizer) and proves the app shell renders on mobile.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hola, mundo!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
