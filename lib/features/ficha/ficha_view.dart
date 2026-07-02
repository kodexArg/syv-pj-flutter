import 'package:flutter/material.dart';
import 'package:syv_ui/syv_ui.dart';

/// The character-sheet canvas. Black background with the permanent brand header
/// at the top; the rest is intentionally empty — a blank slate that grows as
/// the feature ships section by section.
class FichaView extends StatelessWidget {
  /// Creates the character-sheet screen.
  const FichaView({super.key});

  @override
  Widget build(BuildContext context) {
    // Header only — a blank canvas that grows as the feature ships.
    return const SyvScreen();
  }
}
