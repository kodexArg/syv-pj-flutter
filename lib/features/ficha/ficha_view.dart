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
    return Scaffold(
      backgroundColor: SyvColors.ink1000,
      body: SyvGlow(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SyvSpace.xxl,
                  SyvSpace.s5,
                  SyvSpace.xxl,
                  SyvSpace.s7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const <Widget>[
                    SyvHeader(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
