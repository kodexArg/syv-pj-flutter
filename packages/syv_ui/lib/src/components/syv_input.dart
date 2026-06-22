import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// A borderless "typewriter" text field. At rest only the platen baseline rule
/// shows; on focus the rule greens. [invalid] turns the rule red. The interior
/// is monospace (DM Mono). Label is mono uppercase with a green `›` marker.
class SyvInput extends StatefulWidget {
  /// Creates an input field.
  const SyvInput({
    super.key,
    this.label,
    this.hint,
    this.invalid = false,
    this.value,
    this.placeholder,
    this.disabled = false,
    this.onChanged,
    this.controller,
  });

  /// Mono uppercase label rendered above the field, prefixed with `›`.
  final String? label;

  /// Mono helper text below the field; reddens when [invalid].
  final String? hint;

  /// Error state — reddens the baseline rule and the hint.
  final bool invalid;

  /// Initial text (ignored when a [controller] is supplied).
  final String? value;

  /// Placeholder shown when empty.
  final String? placeholder;

  /// Disables interaction and dims the field.
  final bool disabled;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Optional external controller; created internally when null.
  final TextEditingController? controller;

  @override
  State<SyvInput> createState() => _SyvInputState();
}

class _SyvInputState extends State<SyvInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController(text: widget.value);
  final FocusNode _focus = FocusNode();
  bool _focused = false;

  /// Advance width of one DM Mono glyph at the field's 15px size — the width of
  /// a single typewriter cell. Measured once; drives the focus cell grid.
  static final double _cell = _measureCell();

  static double _measureCell() {
    final TextPainter tp = TextPainter(
      text: const TextSpan(
        text: '0',
        style: TextStyle(
          fontFamily: SyvType.mono,
          fontSize: 15,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
    // Repaint the painted underscore caret as text/selection moves.
    _controller.addListener(_sync);
  }

  void _sync() => setState(() {});

  /// Horizontal offset (from the field's left edge) of the caret, in logical
  /// pixels — the start of the field padding plus the rendered width of the
  /// text before the caret. Null when nothing is focused.
  double _caretX() {
    final TextSelection sel = _controller.selection;
    final String text = _controller.text;
    final int idx = sel.isValid
        ? sel.baseOffset.clamp(0, text.length)
        : text.length;
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text.substring(0, idx),
        style: const TextStyle(
          fontFamily: SyvType.mono,
          fontSize: 15,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return _PlatenPainter._inset + tp.width;
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.removeListener(_sync);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accent drives the focus grid + glow; rule is the platen baseline.
    final Color accent = widget.invalid ? SyvColors.bad : SyvColors.green500;
    final Color rule = widget.invalid
        ? SyvColors.bad
        : _focused
        ? SyvColors.green500
        : SyvColors.ink600;
    final bool lit = _focused && !widget.disabled;

    final field = Opacity(
      opacity: widget.disabled ? 0.42 : 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(SyvRadius.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: lit
                ? (widget.invalid
                      ? const Color(0x0FD9694E)
                      : const Color(0x0F7B8A4E))
                : const Color(0x05FFFFFF),
          ),
          child: CustomPaint(
            painter: _PlatenPainter(
              rule: rule,
              accent: accent,
              focused: lit,
              cell: _cell,
              caretX: lit ? _caretX() : null,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 12, 8),
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                enabled: !widget.disabled,
                onChanged: widget.onChanged,
                // Native caret is hidden; the platen paints a flat underscore
                // caret at the baseline, aligned to the monospace cell.
                cursorColor: const Color(0x00000000),
                cursorWidth: 0,
                style: SyvType.mono_.copyWith(
                  fontSize: 15,
                  height: 1.5,
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: widget.placeholder,
                  hintStyle: SyvType.mono_.copyWith(
                    fontSize: 15,
                    color: SyvColors.ink500,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.label != null) ...<Widget>[
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: '› ',
                  style: TextStyle(color: SyvColors.green500),
                ),
                TextSpan(text: widget.label!.toUpperCase()),
              ],
              style: SyvType.mono_.copyWith(
                fontSize: 11,
                letterSpacing: 1.2,
                color: SyvColors.warm200,
              ),
            ),
          ),
          const SizedBox(height: 7),
        ],
        field,
        if (widget.hint != null) ...<Widget>[
          const SizedBox(height: 7),
          Text(
            widget.hint!,
            style: SyvType.mono_.copyWith(
              fontSize: 11,
              color: widget.invalid ? SyvColors.bad : SyvColors.ink500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Paints the typewriter "platen": at rest only the inset baseline rule shows.
/// On focus the monospace cell grid types in (one hairline per character cell),
/// the baseline greens, and a soft inner glow rises from the bottom — mirroring
/// the web design-system `:focus` state (cell grid + baseline + bottom glow).
class _PlatenPainter extends CustomPainter {
  const _PlatenPainter({
    required this.rule,
    required this.accent,
    required this.focused,
    required this.cell,
    required this.caretX,
  });

  /// Baseline rule color (ink at rest, greened on focus, red when invalid).
  final Color rule;

  /// Accent driving the focus cell grid and the bottom glow.
  final Color accent;

  /// Whether the field is focused (and enabled).
  final bool focused;

  /// Width of one monospace cell, in logical pixels.
  final double cell;

  /// Caret x-offset from the field's left edge, or null when unfocused.
  final double? caretX;

  // Field horizontal padding (12) — baseline and grid inset from the edges.
  static const double _inset = 12;

  // Baseline sits 8px above the bottom, matching the field's content padding.
  static const double _baselineUp = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final double baseY = size.height - _baselineUp;

    if (focused) {
      // Monospace cell grid: one accent hairline at every cell boundary, so the
      // lines fall exactly in the gaps between the monospace glyphs.
      final Paint grid = Paint()
        ..color = accent.withValues(alpha: 0.10)
        ..strokeWidth = 1;
      for (double x = _inset + cell; x <= size.width - _inset; x += cell) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      }

      // Inner glow rising from the bottom edge.
      final Rect glowRect = Rect.fromLTWH(0, size.height - 18, size.width, 18);
      final Paint glow = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            accent.withValues(alpha: 0),
            accent.withValues(alpha: 0.22),
          ],
        ).createShader(glowRect);
      canvas.drawRect(glowRect, glow);

      // Flat underscore caret, one cell wide, riding the baseline rule.
      if (caretX != null) {
        final double cx = caretX!.clamp(_inset, size.width - _inset - cell);
        final Paint caret = Paint()
          ..color = accent
          ..strokeWidth = 2;
        canvas.drawLine(
          Offset(cx, baseY - 1),
          Offset(cx + cell, baseY - 1),
          caret,
        );
      }
    }

    // Baseline platen rule, inset from the sides.
    final Paint base = Paint()
      ..color = rule
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(_inset, baseY),
      Offset(size.width - _inset, baseY),
      base,
    );
  }

  @override
  bool shouldRepaint(_PlatenPainter old) =>
      old.focused != focused ||
      old.rule != rule ||
      old.accent != accent ||
      old.cell != cell ||
      old.caretX != caretX;
}
