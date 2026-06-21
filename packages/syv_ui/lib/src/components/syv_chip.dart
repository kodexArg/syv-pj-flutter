import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// Tonal voice of a [SyvChip]. `neutral` is the borderless-accent default;
/// `solid` is the only filled tone (olive fill, ink text).
enum SyvChipTone { ok, work, stop, celeste, bad, solid, neutral }

/// A small mono status pill with an optional leading [dot].
///
/// Hairline-bordered, [SyvRadius.sm], depth from border + color only (no
/// shadow). The dot inherits the chip's text color.
class SyvChip extends StatelessWidget {
  /// Creates a chip labelled [label].
  const SyvChip({
    super.key,
    required this.label,
    this.tone = SyvChipTone.neutral,
    this.dot = false,
  });

  /// Chip text.
  final String label;

  /// Tonal voice.
  final SyvChipTone tone;

  /// Whether to show the leading status dot.
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(tone);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: spec.fill,
        border: Border.all(color: spec.border, width: SyvBorders.hairlineWidth),
        borderRadius: const BorderRadius.all(SyvRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (dot) ...<Widget>[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: spec.text,
                  borderRadius: const BorderRadius.all(SyvRadius.pill),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: SyvType.mono_.copyWith(
                fontSize: 13,
                height: 1.2,
                letterSpacing: 0.4,
                color: spec.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static _ChipSpec _spec(SyvChipTone tone) {
    switch (tone) {
      case SyvChipTone.ok:
        return const _ChipSpec(
            text: SyvColors.green300, border: Color(0x8C7B8A4E));
      case SyvChipTone.work:
        return const _ChipSpec(
            text: SyvColors.amber300, border: Color(0x80E0A23C));
      case SyvChipTone.stop:
        return const _ChipSpec(
            text: SyvColors.teal300, border: Color(0x804FA6AB));
      case SyvChipTone.celeste:
        return const _ChipSpec(
            text: SyvColors.celeste300, border: Color(0x808FB8D6));
      case SyvChipTone.bad:
        return const _ChipSpec(text: SyvColors.bad, border: Color(0x80D9694E));
      case SyvChipTone.solid:
        return const _ChipSpec(
          text: SyvColors.ink1000,
          border: SyvColors.green500,
          fill: SyvColors.green500,
        );
      case SyvChipTone.neutral:
        return const _ChipSpec(
            text: SyvColors.cream100, border: SyvColors.ink600);
    }
  }
}

class _ChipSpec {
  const _ChipSpec({required this.text, required this.border, this.fill});
  final Color text;
  final Color border;
  final Color? fill;
}
