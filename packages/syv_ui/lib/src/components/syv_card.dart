import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// Surface variant of a [SyvCard]. Each carries its own off-center light:
///  * [SyvCardVariant.standard] — phosphor-green house glow
///  * [SyvCardVariant.alt]      — petróleo (teal) cool second voice
///  * [SyvCardVariant.emphasis] — brighter olive→neon + green-deep hairline
///  * [SyvCardVariant.military] — celeste + blanco institutional light + moss hairline
enum SyvCardVariant { standard, alt, emphasis, military }

/// A pure warm-black surface ([SyvColors.ink1000]) whose depth comes from a
/// single off-center light layer plus a hairline border and [SyvRadius.lg] —
/// never an elevation shadow. [glow] adds a second centered internal bloom.
class SyvCard extends StatelessWidget {
  /// Creates a card wrapping [child].
  const SyvCard({
    super.key,
    required this.child,
    this.variant = SyvCardVariant.standard,
    this.glow = false,
  });

  /// Card contents.
  final Widget child;

  /// Light + hairline variant.
  final SyvCardVariant variant;

  /// Adds a centered internal bloom on top of the variant light.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(variant);
    return ClipRRect(
      borderRadius: const BorderRadius.all(SyvRadius.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: SyvColors.ink1000,
          border:
              Border.all(color: spec.border, width: SyvBorders.hairlineWidth),
          borderRadius: const BorderRadius.all(SyvRadius.lg),
        ),
        child: Stack(
          children: <Widget>[
            // off-center variant light — a layer, not a shadow
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: spec.light),
              ),
            ),
            if (glow)
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: _bloom),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(SyvSpace.xxl),
              child: DefaultTextStyle.merge(
                style: SyvType.body,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // centered internal bloom when glow == true
  static const RadialGradient _bloom = RadialGradient(
    center: Alignment.center,
    radius: 0.6,
    colors: <Color>[Color(0x1A34E867), Color(0x0034E867)],
    stops: <double>[0.0, 0.7],
  );

  static _CardSpec _spec(SyvCardVariant variant) {
    switch (variant) {
      case SyvCardVariant.standard:
        return const _CardSpec(
          border: SyvColors.ink600,
          light: RadialGradient(
            center: Alignment(0.64, -1.0),
            radius: 0.85,
            colors: <Color>[Color(0x2934E867), Color(0x0D34E867), Color(0x0034E867)],
            stops: <double>[0.0, 0.4, 0.72],
          ),
        );
      case SyvCardVariant.alt:
        return const _CardSpec(
          border: Color(0x734FA6AB),
          light: RadialGradient(
            center: Alignment(0.6, -1.0),
            radius: 0.88,
            colors: <Color>[Color(0x334FA6AB), Color(0x0F4FA6AB), Color(0x004FA6AB)],
            stops: <double>[0.0, 0.42, 0.74],
          ),
        );
      case SyvCardVariant.emphasis:
        return const _CardSpec(
          border: SyvColors.greenDeep,
          light: RadialGradient(
            center: Alignment(0.7, -1.08),
            radius: 0.62,
            colors: <Color>[Color(0x4234E867), Color(0x0034E867)],
            stops: <double>[0.0, 0.6],
          ),
        );
      case SyvCardVariant.military:
        return const _CardSpec(
          border: SyvColors.moss500,
          light: RadialGradient(
            center: Alignment(-0.64, -1.0),
            radius: 0.6,
            colors: <Color>[Color(0x338FB8D6), Color(0x008FB8D6)],
            stops: <double>[0.0, 0.6],
          ),
        );
    }
  }
}

class _CardSpec {
  const _CardSpec({required this.border, required this.light});
  final Color border;
  final RadialGradient light;
}
