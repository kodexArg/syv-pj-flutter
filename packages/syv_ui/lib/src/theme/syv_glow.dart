import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// Background scaffold for the "Diseño Verde" look: a pure warm-black surface
/// ([SyvColors.ink1000]) with the single off-center neon-green halo
/// ([syvGlow]) painted behind [child].
///
/// Depth in this system is glow + hairline + radius — never an elevation
/// shadow — so this widget is the canonical way to seat any SyV screen.
class SyvGlow extends StatelessWidget {
  /// Creates a glow background wrapping [child].
  const SyvGlow({super.key, required this.child});

  /// Content painted on top of the halo.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: SyvColors.ink1000),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: syvGlow),
        child: child,
      ),
    );
  }
}
