import 'dart:io';

import 'package:flutter/material.dart';

/// Placeholder landing view. Stands in for the first real feature module
/// (the character visualizer) and proves the floating-window shell works.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hola, mundo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => exit(0),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
