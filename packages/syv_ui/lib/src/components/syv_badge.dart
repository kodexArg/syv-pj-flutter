import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';
import 'syv_logo.dart';

/// Size of a [SyvBadge] outer frame. Independent of [SyvLogoSize] so the
/// insignia can sit at icon scale without the lockup wordmark metrics.
enum SyvBadgeSize { sm, md, lg }

/// The brand insignia: the canonical mark (cross + two sergeant chevrons)
/// inside a squared hairline frame. No wordmark — that is [SyvLogo].
///
/// Geometry is the baked 96×96 SVG coords from `assets/logo/syv-mark.svg`.
/// Variants recolor only.
class SyvBadge extends StatelessWidget {
  /// Creates the brand badge.
  const SyvBadge({
    super.key,
    this.variant = SyvLogoVariant.militar,
    this.size = SyvBadgeSize.md,
    this.glow = false,
  });

  /// Recolor variant. Same three voices as [SyvLogo].
  final SyvLogoVariant variant;

  /// Outer frame size.
  final SyvBadgeSize size;

  /// Off-center neon radial inside the frame. Permitted glow exception only;
  /// never a fill, text, or border.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(size);
    final border = _border(variant);

    return SizedBox(
      width: spec.box,
      height: spec.box,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(SyvRadius.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: SyvColors.ink850,
            border: Border.all(color: border, width: SyvBorders.hairlineWidth),
            borderRadius: const BorderRadius.all(SyvRadius.sm),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (glow)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: _glow),
                  ),
                ),
              SizedBox(
                width: spec.mark,
                height: spec.mark,
                child: CustomPaint(painter: _BadgeMarkPainter(_colors(variant))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const RadialGradient _glow = RadialGradient(
    center: Alignment(0.56, -0.76),
    radius: 0.7,
    colors: <Color>[Color(0x2934E867), Color(0x0034E867)],
    stops: <double>[0.0, 1.0],
  );

  static _BadgeSizeSpec _spec(SyvBadgeSize size) {
    switch (size) {
      case SyvBadgeSize.sm:
        return const _BadgeSizeSpec(box: 36, mark: 28);
      case SyvBadgeSize.md:
        return const _BadgeSizeSpec(box: 48, mark: 38);
      case SyvBadgeSize.lg:
        return const _BadgeSizeSpec(box: 64, mark: 50);
    }
  }

  static Color _border(SyvLogoVariant variant) {
    switch (variant) {
      case SyvLogoVariant.militar:
        return SyvColors.ink600;
      case SyvLogoVariant.argentina:
        return SyvColors.celeste500.withValues(alpha: 0.55);
      case SyvLogoVariant.clerical:
        return SyvColors.cream100.withValues(alpha: 0.28);
    }
  }

  static _BadgeMarkColors _colors(SyvLogoVariant variant) {
    switch (variant) {
      case SyvLogoVariant.militar:
        return const _BadgeMarkColors(
          cross: SyvColors.cream100,
          c1: SyvColors.green400,
          c2: SyvColors.greenNeon,
          c2opacity: 0.55,
        );
      case SyvLogoVariant.argentina:
        return const _BadgeMarkColors(
          cross: SyvColors.celeste500,
          c1: Color(0xFFEEE8DC),
          c2: SyvColors.celeste500,
          c2opacity: 1,
        );
      case SyvLogoVariant.clerical:
        return const _BadgeMarkColors(
          cross: SyvColors.cream100,
          c1: SyvColors.cream100,
          c2: SyvColors.warm200,
          c2opacity: 1,
        );
    }
  }
}

class _BadgeSizeSpec {
  const _BadgeSizeSpec({required this.box, required this.mark});
  final double box;
  final double mark;
}

class _BadgeMarkColors {
  const _BadgeMarkColors({
    required this.cross,
    required this.c1,
    required this.c2,
    required this.c2opacity,
  });
  final Color cross;
  final Color c1;
  final Color c2;
  final double c2opacity;
}

/// Paints the canonical mark on a 96×96 grid (baked SVG coords, no extra
/// translateY — the +5 px shift is already in y=16/46/28).
class _BadgeMarkPainter extends CustomPainter {
  _BadgeMarkPainter(this.c);

  final _BadgeMarkColors c;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 96.0;
    canvas.save();
    canvas.scale(scale, scale);

    final cross = Paint()
      ..style = PaintingStyle.stroke
      ..color = c.cross
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(const Offset(48, 16), const Offset(48, 46), cross);
    canvas.drawLine(const Offset(34, 28), const Offset(62, 28), cross);

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
  bool shouldRepaint(_BadgeMarkPainter old) =>
      old.c.cross != c.cross ||
      old.c.c1 != c.c1 ||
      old.c.c2 != c.c2 ||
      old.c.c2opacity != c.c2opacity;
}
