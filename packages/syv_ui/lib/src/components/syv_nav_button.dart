import 'package:flutter/material.dart';

import '../foundations/syv_accent.dart';
import '../tokens/syv_tokens.dart';

/// A full-width navigation action: leading icon + lowercase label inside a
/// hairline box. Faithful to [SyvButton]'s interaction recipe (glow-free depth,
/// fast settle, press nudge, 0.42 opacity when inert). Inert when [onPressed]
/// is null — used for features that have not landed yet.
class SyvNavButton extends StatefulWidget {
  /// Creates a navigation action with a leading [icon] and a [label].
  const SyvNavButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  /// Leading glyph.
  final IconData icon;

  /// Action label. Rendered lowercase.
  final String label;

  /// Tap callback. When null, the button is inert (disabled look).
  final VoidCallback? onPressed;

  @override
  State<SyvNavButton> createState() => _SyvNavButtonState();
}

class _SyvNavButtonState extends State<SyvNavButton> {
  bool _hover = false;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final ramp = syvAccentRamp(SyvAccent.olive);
    final accent = _pressed
        ? ramp.press
        : _hover
            ? ramp.hover
            : ramp.base;

    final Color border = (_hover && _enabled) ? accent : SyvColors.ink600;
    final Color fg = _enabled ? SyvColors.cream100 : SyvColors.warm200;
    final Color iconColor = _enabled ? accent : SyvColors.ink500;

    final Widget core = Opacity(
      opacity: _enabled ? 1 : 0.42,
      child: AnimatedContainer(
        duration: SyvMotion.fast,
        curve: SyvMotion.settle,
        padding: const EdgeInsets.symmetric(
          horizontal: SyvSpace.lg,
          vertical: SyvSpace.md,
        ),
        transform:
            Matrix4.translationValues(0, _pressed && _enabled ? 1 : 0, 0),
        decoration: BoxDecoration(
          color: SyvColors.ink900,
          border: Border.all(color: border, width: SyvBorders.hairlineWidth),
          borderRadius: const BorderRadius.all(SyvRadius.md),
        ),
        child: Row(
          children: <Widget>[
            Icon(widget.icon, size: 20, color: iconColor),
            const SizedBox(width: SyvSpace.md),
            Text(
              widget.label.toLowerCase(),
              style: SyvType.body.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: -0.13,
                height: 1,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );

    if (!_enabled) {
      return MouseRegion(cursor: SystemMouseCursors.basic, child: core);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: core,
      ),
    );
  }
}
