import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// A section header for the design system — the numbered mono eyebrow promoted
/// to a standalone heading. No underline: the wide-tracked label carries the
/// divide on its own. Built on the [SyvType.kicker] identity, one point larger
/// and a touch lighter, so it reads as a heading rather than an inline eyebrow.
///
/// Keeps a comfortable lead-in above ([SyvSpace.s7]) and a quiet gap below
/// ([SyvSpace.lg]) before the section's content.
class SyvSection extends StatelessWidget {
  /// Creates a section header labelled [title], optionally prefixed with [num].
  const SyvSection({super.key, this.num, required this.title});

  /// Optional leading index, e.g. `"06"`.
  final String? num;

  /// The section label. Rendered uppercase with the wide mono tracking.
  final String title;

  @override
  Widget build(BuildContext context) {
    // Kicker identity, bumped one point for heading scale.
    final TextStyle base = SyvType.kicker.copyWith(fontSize: 13);
    return Padding(
      padding: const EdgeInsets.only(top: SyvSpace.s7, bottom: SyvSpace.lg),
      child: Wrap(
        spacing: SyvSpace.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          if (num != null)
            Text(num!, style: base.copyWith(color: SyvColors.warm200)),
          if (num != null)
            Text('·', style: base.copyWith(color: SyvColors.ink500)),
          // Lighter than the eyebrow green for a clearer heading read.
          Text(
            title.toUpperCase(),
            style: base.copyWith(color: SyvColors.green400),
          ),
        ],
      ),
    );
  }
}
