import 'package:flutter/material.dart';

import '../icons/syv_stat_icons.dart';
import '../tokens/syv_tokens.dart';
import 'syv_stat.dart' show SyvStatKind;

/// A square stat tile rendered as a tappable button; three sit in a row.
///
/// Port of the design-system "tres botones en línea" showcase tile:
/// dark ink surface, per-stat accent glow, engraved sigil, name+value header
/// and a six-pip gauge. Accent changes on hover/focus/press via border color.
///
/// ```dart
/// Row(
///   children: [
///     Expanded(child: SyvStatBtn(stat: SyvStatKind.cuerpo, value: 5, onPressed: () {})),
///     SizedBox(width: SyvSpace.md),
///     Expanded(child: SyvStatBtn(stat: SyvStatKind.mente, value: 4, onPressed: () {})),
///     SizedBox(width: SyvSpace.md),
///     Expanded(child: SyvStatBtn(stat: SyvStatKind.alma, value: 6, onPressed: () {})),
///   ],
/// )
/// ```
///
/// For a pre-built three-tile row use [SyvStatBtnRow].
class SyvStatBtn extends StatefulWidget {
  /// Creates a square stat button tile.
  const SyvStatBtn({
    super.key,
    required this.stat,
    required this.value,
    this.onPressed,
  });

  /// Which attribute this tile represents.
  final SyvStatKind stat;

  /// Current value, clamped to 2–7.
  final int value;

  /// Callback when the tile is tapped. If null the tile is inert but still
  /// renders (useful for read-only rows).
  final VoidCallback? onPressed;

  @override
  State<SyvStatBtn> createState() => _SyvStatBtnState();
}

class _SyvStatBtnState extends State<SyvStatBtn> {
  bool _hover = false;
  bool _pressed = false;

  static const int _min = 2;
  static const int _max = 7;

  Color _accent(SyvStatKind stat) {
    switch (stat) {
      case SyvStatKind.cuerpo:
        return SyvColors.amber500;
      case SyvStatKind.mente:
        return SyvColors.amethyst500;
      case SyvStatKind.alma:
        return SyvColors.celeste500;
    }
  }

  String _label(SyvStatKind stat) {
    switch (stat) {
      case SyvStatKind.cuerpo:
        return 'cuerpo';
      case SyvStatKind.mente:
        return 'mente';
      case SyvStatKind.alma:
        return 'alma';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent(widget.stat);
    final v = widget.value.clamp(_min, _max);
    final active = _hover || _pressed;
    final borderColor = active ? accent : SyvColors.ink600;

    // Engraved sigil color: accent at 22% over near-black ink1000.
    final sigilColor = Color.lerp(SyvColors.ink1000, accent, 0.22)!;

    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: SyvMotion.fast,
            curve: SyvMotion.settle,
            decoration: BoxDecoration(
              color: SyvColors.ink1000,
              border: Border.all(color: borderColor, width: SyvBorders.hairlineWidth),
              borderRadius: const BorderRadius.all(SyvRadius.lg),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(SyvRadius.lg),
              child: Stack(
                children: <Widget>[
                  // Layer 1: radial glow — accent@20% anchored top-right.
                  // CSS was: radial-gradient(64% 52% at 84% 0%, accent20%, transparent 70%)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.68, -1.0),
                          radius: 0.72,
                          colors: <Color>[
                            accent.withValues(alpha: 0.20),
                            accent.withValues(alpha: 0.0),
                          ],
                          stops: const <double>[0.0, 0.70],
                        ),
                      ),
                    ),
                  ),

                  // Layer 2: engraved sigil centered, ~78% of tile, dark-tint.
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final iconSize = constraints.maxWidth * 0.78;
                        return Center(
                          child: SyvStatSvg(
                            glyph: _glyphFor(widget.stat),
                            size: iconSize,
                            color: sigilColor,
                          ),
                        );
                      },
                    ),
                  ),

                  // Layer 3: content (above sigil).
                  Padding(
                    padding: const EdgeInsets.all(SyvSpace.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Header row: name (left) + value (right).
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _label(widget.stat),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: SyvType.title.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                    height: 1,
                                    color: SyvColors.cream100,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '$v',
                              style: SyvType.display.copyWith(
                                fontSize: 26,
                                height: 1,
                                color: accent,
                                fontFeatures: const <FontFeature>[
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Spacer pushes gauge to bottom.
                        const Spacer(),

                        // Gauge: 6 pips, ON = filled + accent border, OFF = transparent + ink600.
                        _gauge(accent, v),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SyvStatGlyph _glyphFor(SyvStatKind stat) {
    switch (stat) {
      case SyvStatKind.cuerpo:
        return SyvStatGlyph.cuerpo;
      case SyvStatKind.mente:
        return SyvStatGlyph.mente;
      case SyvStatKind.alma:
        return SyvStatGlyph.alma;
    }
  }

  Widget _gauge(Color accent, int v) {
    final segs = <Widget>[];
    for (var s = _min; s <= _max; s++) {
      final on = s <= v;
      segs.add(Expanded(
        child: AnimatedContainer(
          duration: SyvMotion.fast,
          curve: SyvMotion.settle,
          height: 7,
          decoration: BoxDecoration(
            color: on ? accent : Colors.transparent,
            border: Border.all(
              color: on ? accent : SyvColors.ink600,
              width: SyvBorders.hairlineWidth,
            ),
            borderRadius: const BorderRadius.all(SyvRadius.sm),
          ),
        ),
      ));
      if (s < _max) segs.add(const SizedBox(width: 4));
    }
    return Row(children: segs);
  }
}

// ---------------------------------------------------------------------------
// SyvStatBtnRow — convenience widget: three tiles in a constrained row.
// ---------------------------------------------------------------------------

/// Pre-built row of three [SyvStatBtn] tiles (cuerpo · mente · alma), gap
/// [SyvSpace.md], max-width 440. Values and callbacks are per-stat.
class SyvStatBtnRow extends StatelessWidget {
  /// Creates a three-tile stat-button row.
  const SyvStatBtnRow({
    super.key,
    this.cuerpo = 2,
    this.mente = 2,
    this.alma = 2,
    this.onCuerpo,
    this.onMente,
    this.onAlma,
  });

  /// Value for the cuerpo tile (2–7).
  final int cuerpo;

  /// Value for the mente tile (2–7).
  final int mente;

  /// Value for the alma tile (2–7).
  final int alma;

  /// Callback when the cuerpo tile is tapped.
  final VoidCallback? onCuerpo;

  /// Callback when the mente tile is tapped.
  final VoidCallback? onMente;

  /// Callback when the alma tile is tapped.
  final VoidCallback? onAlma;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Row(
          children: <Widget>[
            Expanded(
              child: SyvStatBtn(
                stat: SyvStatKind.cuerpo,
                value: cuerpo,
                onPressed: onCuerpo,
              ),
            ),
            const SizedBox(width: SyvSpace.md),
            Expanded(
              child: SyvStatBtn(
                stat: SyvStatKind.mente,
                value: mente,
                onPressed: onMente,
              ),
            ),
            const SizedBox(width: SyvSpace.md),
            Expanded(
              child: SyvStatBtn(
                stat: SyvStatKind.alma,
                value: alma,
                onPressed: onAlma,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
