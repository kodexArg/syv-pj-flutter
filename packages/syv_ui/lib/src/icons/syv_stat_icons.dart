import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The three character-sheet stat glyphs, rendered as Lucide-style stroke icons.
///
/// Each glyph is available as:
///  * A raw SVG string constant (used by [SyvStatSvg] for faithful rendering).
///  * A [CustomPainter] fallback (used by [SyvStatIcon] for legacy compat).
///
/// Glyphs:
///  * [SyvStatGlyph.cuerpo] — biceps-flexed (fuerza · resistencia)
///  * [SyvStatGlyph.mente]  — optical reticle (puntería · reflejos)
///  * [SyvStatGlyph.alma]   — laurels (aura · liderazgo · voluntad)
enum SyvStatGlyph { cuerpo, mente, alma }

// ---------------------------------------------------------------------------
// SVG source strings — single source of truth for path data.
// All viewBox="0 0 24 24", stroke-width 1.7, round caps/joins.
// ---------------------------------------------------------------------------

/// Cuerpo — biceps-flexed (Lucide).
const String kSvgCuerpo =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">'
    '<path d="M12.409 13.017A5 5 0 0 1 22 15c0 3.866-4 7-9 7-4.077 0-8.153-.82'
    '-10.371-2.462-.426-.316-.631-.832-.62-1.362C2.118 12.723 2.627 2 10 2a3 3 '
    '0 0 1 3 3 2 2 0 0 1-2 2c-1.105 0-1.64-.444-2-1"/>'
    '<path d="M15 14a5 5 0 0 0-7.584 2"/>'
    '<path d="M9.964 6.825C8.019 7.977 9.5 13 8 15"/>'
    '</svg>';

/// Mente — optical reticle.
const String kSvgMente =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">'
    '<circle cx="12" cy="12" r="8.5"/>'
    '<circle cx="12" cy="12" r="3.2"/>'
    '<path d="M12 1.5V4M12 20v2.5M1.5 12H4M20 12h2.5"/>'
    '</svg>';

/// Alma — laurels.
const String kSvgAlma =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">'
    '<path d="M12 21c-5-1.4-8-5.6-6.6-12"/>'
    '<path d="M7 6.4c1.5.3 2.5 1.4 2.7 3M5.7 10.3c1.6.1 2.8 1 3.3 2.6'
    'M6.2 14.6c1.5-.2 2.9.4 3.7 1.9"/>'
    '<path d="M12 21c5-1.4 8-5.6 6.6-12"/>'
    '<path d="M17 6.4c-1.5.3-2.5 1.4-2.7 3M18.3 10.3c-1.6.1-2.8 1-3.3 2.6'
    'M17.8 14.6c-1.5-.2-2.9.4-3.7 1.9"/>'
    '<path d="M12 2.6v3"/>'
    '</svg>';

// ---------------------------------------------------------------------------
// SyvStatSvg — faithful SVG render via flutter_svg with ColorFilter tinting.
// ---------------------------------------------------------------------------

/// Renders a stat glyph from its SVG source string, tinted to [color].
///
/// Preferred over [SyvStatIcon] when fidelity to the design-system reference
/// is required (e.g. the [SyvStatBtn] tile background sigil).
class SyvStatSvg extends StatelessWidget {
  /// Creates a tinted SVG stat glyph.
  const SyvStatSvg({
    super.key,
    required this.glyph,
    this.size = 30,
    this.color,
  });

  /// Which stat glyph to draw.
  final SyvStatGlyph glyph;

  /// Edge length in logical pixels (square).
  final double size;

  /// Stroke color (applied via [ColorFilter.mode] / [BlendMode.srcIn]).
  /// Defaults to ambient [IconTheme] color falling back to cream100.
  final Color? color;

  static String _svgFor(SyvStatGlyph g) {
    switch (g) {
      case SyvStatGlyph.cuerpo:
        return kSvgCuerpo;
      case SyvStatGlyph.mente:
        return kSvgMente;
      case SyvStatGlyph.alma:
        return kSvgAlma;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFFF3EEE4);

    return SvgPicture.string(
      _svgFor(glyph),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(resolved, BlendMode.srcIn),
    );
  }
}

// ---------------------------------------------------------------------------
// SyvStatIcon — stroke icon (CustomPainter). Kept for backward compatibility.
// ---------------------------------------------------------------------------

/// A stroke icon for a character stat. Ported verbatim from the design-system
/// SVG path data (24×24 viewBox, 1.7 stroke, round caps/joins).
class SyvStatIcon extends StatelessWidget {
  /// Creates a stat icon for [glyph].
  const SyvStatIcon({
    super.key,
    required this.glyph,
    this.size = 30,
    this.color,
  });

  /// Biceps-flexed (cuerpo).
  const SyvStatIcon.cuerpo({super.key, this.size = 30, this.color})
      : glyph = SyvStatGlyph.cuerpo;

  /// Optical reticle (mente).
  const SyvStatIcon.mente({super.key, this.size = 30, this.color})
      : glyph = SyvStatGlyph.mente;

  /// Laurels (alma).
  const SyvStatIcon.alma({super.key, this.size = 30, this.color})
      : glyph = SyvStatGlyph.alma;

  /// Which stat glyph to draw.
  final SyvStatGlyph glyph;

  /// Edge length in logical pixels (square).
  final double size;

  /// Stroke color. Defaults to the ambient [IconTheme] / [DefaultTextStyle]
  /// color, falling back to the current text color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFFF3EEE4);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StatIconPainter(glyph: glyph, color: resolved),
      ),
    );
  }
}

class _StatIconPainter extends CustomPainter {
  _StatIconPainter({required this.glyph, required this.color});

  final SyvStatGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);
    for (final path in _paths(glyph)) {
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  static List<Path> _paths(SyvStatGlyph glyph) {
    switch (glyph) {
      case SyvStatGlyph.cuerpo:
        return _cuerpo;
      case SyvStatGlyph.mente:
        return _mente;
      case SyvStatGlyph.alma:
        return _alma;
    }
  }

  // cuerpo — biceps-flexed (Lucide). Three sub-paths.
  static final List<Path> _cuerpo = <Path>[
    Path()
      ..moveTo(12.409, 13.017)
      ..cubicTo(13.5, 11.5, 16.5, 11.2, 18.5, 12.5)
      ..cubicTo(20.8, 14.0, 22, 14.3, 22, 15)
      ..cubicTo(22, 18.866, 18, 22, 13, 22)
      ..cubicTo(8.923, 22, 4.847, 21.18, 2.629, 19.538)
      ..cubicTo(2.203, 19.222, 1.998, 18.706, 2.009, 18.176)
      ..cubicTo(2.118, 12.723, 2.627, 2, 10, 2)
      ..cubicTo(11.657, 2, 13, 3.343, 13, 5)
      ..cubicTo(13, 6.105, 12.105, 7, 11, 7)
      ..cubicTo(9.895, 7, 9.36, 6.556, 9, 6),
    Path()
      ..moveTo(15, 14)
      ..cubicTo(13.5, 12.0, 9.4, 12.4, 7.416, 16),
    Path()
      ..moveTo(9.964, 6.825)
      ..cubicTo(8.019, 7.977, 9.5, 13.0, 8, 15),
  ];

  // mente — optical reticle: two circles + four tick marks.
  static final List<Path> _mente = <Path>[
    Path()..addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 8.5)),
    Path()..addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 3.2)),
    Path()
      ..moveTo(12, 1.5)
      ..lineTo(12, 4)
      ..moveTo(12, 20)
      ..lineTo(12, 22.5)
      ..moveTo(1.5, 12)
      ..lineTo(4, 12)
      ..moveTo(20, 12)
      ..lineTo(22.5, 12),
  ];

  // alma — laurels (mirrored fronds + stem).
  static final List<Path> _alma = <Path>[
    Path()
      ..moveTo(12, 21)
      ..cubicTo(7, 19.6, 4, 15.4, 5.4, 9),
    Path()
      ..moveTo(7, 6.4)
      ..cubicTo(8.5, 6.7, 9.5, 7.8, 9.7, 9.4)
      ..moveTo(5.7, 10.3)
      ..cubicTo(7.3, 10.4, 8.5, 11.3, 9.0, 12.9)
      ..moveTo(6.2, 14.6)
      ..cubicTo(7.7, 14.4, 9.1, 15.0, 9.9, 16.5),
    Path()
      ..moveTo(12, 21)
      ..cubicTo(17, 19.6, 20, 15.4, 18.6, 9),
    Path()
      ..moveTo(17, 6.4)
      ..cubicTo(15.5, 6.7, 14.5, 7.8, 14.3, 9.4)
      ..moveTo(18.3, 10.3)
      ..cubicTo(16.7, 10.4, 15.5, 11.3, 15.0, 12.9)
      ..moveTo(17.8, 14.6)
      ..cubicTo(16.3, 14.4, 14.9, 15.0, 14.1, 16.5),
    Path()
      ..moveTo(12, 2.6)
      ..lineTo(12, 5.6),
  ];

  @override
  bool shouldRepaint(_StatIconPainter old) =>
      old.glyph != glyph || old.color != color;
}
