import 'package:flutter/material.dart';

import '../foundations/syv_accent.dart';
import '../tokens/syv_tokens.dart';

/// Visual variant of a [SyvButton].
///  * [SyvButtonVariant.primary]   — filled accent on warm black
///  * [SyvButtonVariant.secondary] — hairline box, accent text
///  * [SyvButtonVariant.ghost]     — text only
enum SyvButtonVariant { primary, secondary, ghost }

/// Button size.
enum SyvButtonSize { md, sm }

/// A lowercase 800-weight action (or uppercase mono with [mono]). Depth from
/// fill / hairline / radius — no elevation shadow. Hover and press recolor via
/// the [color] ramp resolved through [syvAccentRamp].
class SyvButton extends StatefulWidget {
  /// Creates a button labelled [label].
  const SyvButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SyvButtonVariant.primary,
    this.color = SyvAccent.olive,
    this.size = SyvButtonSize.md,
    this.mono = false,
    this.disabled = false,
  });

  /// Button text.
  final String label;

  /// Tap callback. When null (or [disabled]), the button is inert.
  final VoidCallback? onPressed;

  /// Fill / hairline / text strategy.
  final SyvButtonVariant variant;

  /// Accent ramp.
  final SyvAccent color;

  /// Size scale.
  final SyvButtonSize size;

  /// Mono uppercase styling (DM Mono, wider tracking).
  final bool mono;

  /// Forces the disabled look and ignores [onPressed].
  final bool disabled;

  @override
  State<SyvButton> createState() => _SyvButtonState();
}

class _SyvButtonState extends State<SyvButton> {
  bool _hover = false;
  bool _pressed = false;

  bool get _enabled => !widget.disabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final ramp = syvAccentRamp(widget.color);
    final accent = !_enabled
        ? ramp.base
        : _pressed
            ? ramp.press
            : _hover
                ? ramp.hover
                : ramp.base;

    final Color bg;
    final Color border;
    final Color fg;
    switch (widget.variant) {
      case SyvButtonVariant.primary:
        bg = accent;
        border = accent;
        fg = ramp.on;
      case SyvButtonVariant.secondary:
        bg = Colors.transparent;
        border = (_hover && _enabled) ? accent : SyvColors.ink600;
        fg = accent;
      case SyvButtonVariant.ghost:
        bg = Colors.transparent;
        border = Colors.transparent;
        fg = (_hover && _enabled) ? accent : SyvColors.warm200;
    }

    final isSm = widget.size == SyvButtonSize.sm;
    final padding = isSm
        ? const EdgeInsets.symmetric(horizontal: 11, vertical: 5)
        : const EdgeInsets.symmetric(horizontal: 14, vertical: 7);

    final TextStyle textStyle = widget.mono
        ? SyvType.mono_.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: isSm ? 11 : 12.5,
            letterSpacing: 0.5,
            color: fg,
          )
        : SyvType.body.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isSm ? 11.5 : 13,
            letterSpacing: -0.13,
            height: 1,
            color: fg,
          );

    final label = widget.mono
        ? widget.label.toUpperCase()
        : widget.label.toLowerCase();

    Widget core = Opacity(
      opacity: _enabled ? 1 : 0.42,
      child: AnimatedContainer(
        duration: SyvMotion.fast,
        curve: SyvMotion.settle,
        padding: padding,
        transform: Matrix4.translationValues(0, _pressed && _enabled ? 1 : 0, 0),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: SyvBorders.hairlineWidth),
          borderRadius: const BorderRadius.all(SyvRadius.sm),
        ),
        child: Text(label, style: textStyle),
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
