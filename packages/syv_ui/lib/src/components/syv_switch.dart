import 'package:flutter/material.dart';

import '../foundations/syv_accent.dart';
import '../tokens/syv_tokens.dart';

/// A 44×26 toggle whose ON state recolors the track border and thumb with the
/// chosen [color] accent (the color, not a green wall). Optional [label] is the
/// trailing text.
class SyvSwitch extends StatelessWidget {
  /// Creates a switch.
  const SyvSwitch({
    super.key,
    required this.checked,
    this.onChanged,
    this.color = SyvAccent.olive,
    this.disabled = false,
    this.label,
  });

  /// Whether the switch is on.
  final bool checked;

  /// Called with the requested new value on tap. Null (or [disabled]) = inert.
  final ValueChanged<bool>? onChanged;

  /// Accent ramp for the ON state.
  final SyvAccent color;

  /// Forces the disabled look and ignores taps.
  final bool disabled;

  /// Optional trailing label.
  final String? label;

  bool get _enabled => !disabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final accent = syvAccentRamp(color).base;

    final track = AnimatedContainer(
      duration: SyvMotion.medium,
      curve: SyvMotion.settle,
      width: 44,
      height: 26,
      decoration: BoxDecoration(
        color: checked ? SyvColors.ink900 : SyvColors.ink1000,
        border: Border.all(
          color: checked ? accent : SyvColors.ink600,
          width: SyvBorders.hairlineWidth,
        ),
        borderRadius: const BorderRadius.all(SyvRadius.md),
      ),
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: SyvMotion.medium,
            curve: SyvMotion.settle,
            top: 3,
            left: checked ? 21 : 3,
            child: Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                color: checked ? accent : SyvColors.warm200,
                borderRadius: const BorderRadius.all(SyvRadius.sm),
              ),
            ),
          ),
        ],
      ),
    );

    Widget row = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        track,
        if (label != null) ...<Widget>[
          const SizedBox(width: 11),
          Text(
            label!,
            style: SyvType.body.copyWith(fontSize: 15, color: SyvColors.warm200),
          ),
        ],
      ],
    );

    row = Opacity(opacity: _enabled ? 1 : 0.45, child: row);

    if (!_enabled) return row;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged!(!checked),
        child: row,
      ),
    );
  }
}
