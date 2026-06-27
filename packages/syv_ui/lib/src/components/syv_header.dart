import 'package:flutter/material.dart';

import 'syv_logo.dart';

/// The canonical page header: the SyV logo lockup, left-aligned.
///
/// Renders only the logo block — no Scaffold, no background color, no outer
/// padding. Pages supply the black background, SafeArea, and surrounding
/// padding.
class SyvHeader extends StatelessWidget {
  /// Creates the page header.
  const SyvHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SyvLogo(
        size: SyvLogoSize.lg,
        sub: 'generador estocástico de personajes',
      ),
    );
  }
}
