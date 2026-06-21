import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// The mono UPPERCASE eyebrow — the ONLY uppercase element in the system.
///
/// Renders an optional [num] (in [SyvColors.warm200]), a separator dot
/// (in [SyvColors.ink500]) and the [child] label (in [SyvColors.green500]).
/// Used as the section header throughout the design system.
class SyvKicker extends StatelessWidget {
  /// Creates a kicker with [child] as its label.
  const SyvKicker({super.key, this.num, required this.child});

  /// Optional leading index, e.g. `"01"`.
  final String? num;

  /// The eyebrow text. Forced to uppercase by [SyvType.kicker] convention;
  /// pass lowercase/normal text — the style applies the wide tracking + color.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SyvSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        if (num != null)
          Text(num!, style: SyvType.kicker.copyWith(color: SyvColors.warm200)),
        if (num != null)
          Text('·', style: SyvType.kicker.copyWith(color: SyvColors.ink500)),
        DefaultTextStyle.merge(style: SyvType.kicker, child: child),
      ],
    );
  }
}
