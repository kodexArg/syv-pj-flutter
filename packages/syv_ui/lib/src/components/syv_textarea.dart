import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// A borderless multiline "typewriter" field for long-form writing — the
/// multiline sibling of [SyvInput]. Same platen language (monospace cells,
/// accent hairline, RANGO color), full-width, with **no enclosing frame**:
/// at rest only the bottom platen rule shows. On focus the monospace cell grid
/// types in across the full height, the rule greens and a soft glow rises from
/// the bottom. Auto-grows from [minLines] up to [maxLines], then scrolls.
class SyvTextarea extends StatefulWidget {
  /// Creates a multiline text field.
  const SyvTextarea({
    super.key,
    this.label,
    this.hint,
    this.invalid = false,
    this.value,
    this.placeholder,
    this.disabled = false,
    this.minLines = 4,
    this.maxLines = 12,
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

  /// Minimum visible lines (initial height).
  final int minLines;

  /// Maximum lines before the field stops growing and scrolls internally.
  final int maxLines;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Optional external controller; created internally when null.
  final TextEditingController? controller;

  @override
  State<SyvTextarea> createState() => _SyvTextareaState();
}

class _SyvTextareaState extends State<SyvTextarea> {
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
  }

  @override
  void dispose() {
    _focus.dispose();
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
            painter: _TextareaPlatenPainter(
              rule: rule,
              accent: accent,
              focused: lit,
              cell: _cell,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 12, 8),
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                enabled: !widget.disabled,
                onChanged: widget.onChanged,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                cursorColor: accent,
                cursorWidth: 2,
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

/// Paints the multiline platen: at rest only the inset bottom rule shows. On
/// focus the monospace cell grid types in across the **full height** (one
/// hairline per character cell), the bottom rule greens, and a soft inner glow
/// rises from the bottom — the long-form translation of [SyvInput]'s platen.
class _TextareaPlatenPainter extends CustomPainter {
  const _TextareaPlatenPainter({
    required this.rule,
    required this.accent,
    required this.focused,
    required this.cell,
  });

  /// Bottom rule color (ink at rest, greened on focus, red when invalid).
  final Color rule;

  /// Accent driving the focus cell grid and the bottom glow.
  final Color accent;

  /// Whether the field is focused (and enabled).
  final bool focused;

  /// Width of one monospace cell, in logical pixels.
  final double cell;

  // Field horizontal padding (12) — rule and grid inset from the edges.
  static const double _inset = 12;

  // Bottom rule sits 8px above the bottom, matching the content padding.
  static const double _baselineUp = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final double baseY = size.height - _baselineUp;

    if (focused) {
      // Monospace cell grid: one accent hairline at every cell boundary,
      // running the full height so it backs every line of long-form text.
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
    }

    // Bottom platen rule, inset from the sides.
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
  bool shouldRepaint(_TextareaPlatenPainter old) =>
      old.focused != focused ||
      old.rule != rule ||
      old.accent != accent ||
      old.cell != cell;
}
