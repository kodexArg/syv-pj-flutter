import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// Recolor variant of the [SyvLogo]:
///  * [SyvLogoVariant.militar]   — olivo + neón (default)
///  * [SyvLogoVariant.argentina] — celeste institutional
///  * [SyvLogoVariant.clerical]  — blanco
enum SyvLogoVariant { militar, argentina, clerical }

/// Logo size scale.
enum SyvLogoSize { sm, md, lg }

/// The brand lockup: a CROSS (the Church) crowning two sergeant CHEVRONS
/// (military rank) drawn on a 96×96 canvas, plus the wordmark
/// "SUBORDINACIÓN y VALOR" in Saira Stencil One (the one type exception) and a
/// mono sub-line. Variants recolor only.
class SyvLogo extends StatelessWidget {
  /// Creates the logo lockup.
  const SyvLogo({
    super.key,
    this.variant = SyvLogoVariant.militar,
    this.size = SyvLogoSize.md,
    this.sub = 'diseño verde · clandestino',
    this.wordmark = true,
  });

  /// Recolor variant.
  final SyvLogoVariant variant;

  /// Size scale.
  final SyvLogoSize size;

  /// Sub-line text under the wordmark, or null to omit it.
  final String? sub;

  /// Whether to render the wordmark + sub-line beside the mark.
  final bool wordmark;

  @override
  Widget build(BuildContext context) {
    final s = _spec(size);
    final c = _colors(variant);

    final mark = SizedBox(
      width: s.mark,
      height: s.mark,
      child: CustomPaint(painter: _MarkPainter(c)),
    );

    if (!wordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        mark,
        SizedBox(width: s.gap),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: (s.mark * 0.06).roundToDouble()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // The wordmark must never overflow; it scales down to fit the
                // available width while keeping its single-line lockup.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SUBORDINACIÓN y VALOR',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: SyvType.logo,
                      fontSize: s.word,
                      height: 1,
                      letterSpacing: 0.1,
                      color: SyvColors.white,
                    ),
                  ),
                ),
                if (sub != null) ...<Widget>[
                  const SizedBox(height: 1),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sub!.toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: SyvType.mono,
                        fontSize: s.subSize,
                        height: 1.2,
                        letterSpacing: 1.8,
                        color: c.sub,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  static _LogoSizeSpec _spec(SyvLogoSize size) {
    switch (size) {
      // All sizes reduced ~10% from original, rounded to whole logical-px values.
      // Before → after: sm(30,18,9,11)→(27,16,8,10) md(42,25,11,14)→(38,23,10,13) lg(62,35,13,18)→(56,32,12,16)
      case SyvLogoSize.sm:
        return const _LogoSizeSpec(mark: 27, word: 16, subSize: 8, gap: 10);
      case SyvLogoSize.md:
        return const _LogoSizeSpec(mark: 38, word: 23, subSize: 10, gap: 13);
      case SyvLogoSize.lg:
        return const _LogoSizeSpec(mark: 56, word: 32, subSize: 12, gap: 16);
    }
  }

  static _MarkColors _colors(SyvLogoVariant variant) {
    switch (variant) {
      case SyvLogoVariant.militar:
        return const _MarkColors(
          cross: SyvColors.cream100,
          c1: SyvColors.green400,
          c2: SyvColors.greenNeon,
          c2opacity: 0.55,
          sub: SyvColors.green500,
        );
      case SyvLogoVariant.argentina:
        return const _MarkColors(
          cross: SyvColors.celeste500,
          c1: Color(0xFFEEE8DC),
          c2: SyvColors.celeste500,
          c2opacity: 1,
          sub: SyvColors.celeste500,
        );
      case SyvLogoVariant.clerical:
        return const _MarkColors(
          cross: SyvColors.cream100,
          c1: SyvColors.cream100,
          c2: SyvColors.warm200,
          c2opacity: 1,
          sub: SyvColors.warm200,
        );
    }
  }
}

class _LogoSizeSpec {
  const _LogoSizeSpec({
    required this.mark,
    required this.word,
    required this.subSize,
    required this.gap,
  });
  final double mark;
  final double word;
  final double subSize;
  final double gap;
}

class _MarkColors {
  const _MarkColors({
    required this.cross,
    required this.c1,
    required this.c2,
    required this.c2opacity,
    required this.sub,
  });
  final Color cross;
  final Color c1;
  final Color c2;
  final double c2opacity;
  final Color sub;
}

/// Paints the cross + two chevrons on a 96×96 grid (verbatim coords from the
/// reference SVG, with the cross shifted down 5px as in the source transform).
class _MarkPainter extends CustomPainter {
  _MarkPainter(this.c);

  final _MarkColors c;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 96.0;
    canvas.save();
    canvas.scale(scale, scale);

    // cross — stroke-width 7, butt caps, translated +5px down.
    const dy = 5.0;
    final cross = Paint()
      ..style = PaintingStyle.stroke
      ..color = c.cross
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(const Offset(48, 11 + dy), const Offset(48, 41 + dy), cross);
    canvas.drawLine(const Offset(34, 23 + dy), const Offset(62, 23 + dy), cross);

    // chevron 1
    final ch1 = Paint()
      ..style = PaintingStyle.stroke
      ..color = c.c1
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(28, 51)
        ..lineTo(48, 65)
        ..lineTo(68, 51),
      ch1,
    );

    // chevron 2 (with per-variant opacity)
    final ch2 = Paint()
      ..style = PaintingStyle.stroke
      ..color = c.c2.withValues(alpha: c.c2opacity)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(28, 63)
        ..lineTo(48, 77)
        ..lineTo(68, 63),
      ch2,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.c.cross != c.cross ||
      old.c.c1 != c.c1 ||
      old.c.c2 != c.c2 ||
      old.c.c2opacity != c.c2opacity;
}
