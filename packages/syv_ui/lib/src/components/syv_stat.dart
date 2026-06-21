import 'package:flutter/material.dart';

import '../icons/syv_stat_icons.dart';
import '../tokens/syv_tokens.dart';

/// The three persisted character attributes of *Subordinación y Valor*. Each
/// carries its own glyph and palette voice:
///  * [SyvStatKind.cuerpo] — biceps · ámbar
///  * [SyvStatKind.mente]  — optical reticle · petróleo (teal)
///  * [SyvStatKind.alma]   — laurels · celeste
enum SyvStatKind { cuerpo, mente, alma }

/// Character-sheet power control on the 2–7 scale. A card surface with an
/// off-center accent light, the stat glyph, name + sub-line, the big value, a
/// six-segment power gauge and, when [editable], clickable pips plus −/+
/// steppers. Emits the new value through [onChanged].
class SyvStat extends StatelessWidget {
  /// Creates a stat control.
  const SyvStat({
    super.key,
    required this.stat,
    this.value = 2,
    this.editable = false,
    this.onChanged,
  });

  /// Lowest allowed value.
  static const int min = 2;

  /// Highest allowed value.
  static const int max = 7;

  /// Which attribute this control governs.
  final SyvStatKind stat;

  /// Current value, clamped to [min]..[max].
  final int value;

  /// Whether pips/steppers are interactive.
  final bool editable;

  /// Called with the requested new value.
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(stat);
    final v = value.clamp(min, max);

    void emit(int next) {
      if (!editable) return;
      final clamped = next.clamp(min, max);
      if (clamped != v) onChanged?.call(clamped);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(SyvRadius.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: SyvColors.ink1000,
          border: Border.all(
              color: SyvColors.ink600, width: SyvBorders.hairlineWidth),
          borderRadius: const BorderRadius.all(SyvRadius.lg),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.68, -1.0),
                    radius: 0.7,
                    colors: <Color>[
                      spec.accent.withValues(alpha: 0.20),
                      spec.accent.withValues(alpha: 0.0),
                    ],
                    stops: const <double>[0.0, 0.7],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  SyvSpace.lg, SyvSpace.lg, SyvSpace.lg, SyvSpace.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _head(spec, v),
                  const SizedBox(height: SyvSpace.md),
                  _gauge(spec.accent, v, emit),
                  if (editable) ...<Widget>[
                    const SizedBox(height: SyvSpace.md),
                    _steppers(spec.accent, v, emit),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _head(_StatSpec spec, int v) {
    return Row(
      children: <Widget>[
        SyvStatIcon(glyph: spec.glyph, size: 30, color: spec.accent),
        const SizedBox(width: SyvSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                spec.label,
                style: SyvType.title.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  height: 1.1,
                  letterSpacing: -0.13,
                ),
              ),
              Text(
                spec.sub.toUpperCase(),
                style: SyvType.mono_.copyWith(
                  fontSize: 9.5,
                  letterSpacing: 1.0,
                  color: SyvColors.ink500,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: SyvSpace.sm),
        Text(
          '$v',
          style: SyvType.display.copyWith(
            fontSize: 34,
            height: 1,
            color: spec.accent,
          ),
        ),
      ],
    );
  }

  Widget _gauge(Color accent, int v, void Function(int) emit) {
    final segs = <Widget>[];
    for (var s = min; s <= max; s++) {
      final on = s <= v;
      final pip = AnimatedContainer(
        duration: SyvMotion.fast,
        curve: SyvMotion.settle,
        height: 8,
        decoration: BoxDecoration(
          color: on ? accent : Colors.transparent,
          border: Border.all(
              color: on ? accent : SyvColors.ink600,
              width: SyvBorders.hairlineWidth),
          borderRadius: const BorderRadius.all(SyvRadius.sm),
        ),
      );
      segs.add(Expanded(
        child: editable
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => emit(s),
                  child: pip,
                ),
              )
            : pip,
      ));
      if (s < max) segs.add(const SizedBox(width: 5));
    }
    return Row(children: segs);
  }

  Widget _steppers(Color accent, int v, void Function(int) emit) {
    return Row(
      children: <Widget>[
        Expanded(child: _StepButton(label: '−', accent: accent, onTap: () => emit(v - 1))),
        const SizedBox(width: SyvSpace.sm),
        Expanded(child: _StepButton(label: '+', accent: accent, onTap: () => emit(v + 1))),
      ],
    );
  }

  static _StatSpec _spec(SyvStatKind stat) {
    switch (stat) {
      case SyvStatKind.cuerpo:
        return const _StatSpec(
          label: 'cuerpo',
          sub: 'físico',
          accent: SyvColors.amber500,
          glyph: SyvStatGlyph.cuerpo,
        );
      case SyvStatKind.mente:
        return const _StatSpec(
          label: 'mente',
          sub: 'reflejo · táctica',
          accent: SyvColors.teal500,
          glyph: SyvStatGlyph.mente,
        );
      case SyvStatKind.alma:
        return const _StatSpec(
          label: 'alma',
          sub: 'espíritu · voluntad',
          accent: SyvColors.celeste500,
          glyph: SyvStatGlyph.alma,
        );
    }
  }
}

class _StatSpec {
  const _StatSpec({
    required this.label,
    required this.sub,
    required this.accent,
    required this.glyph,
  });
  final String label;
  final String sub;
  final Color accent;
  final SyvStatGlyph glyph;
}

class _StepButton extends StatefulWidget {
  const _StepButton({
    required this.label,
    required this.accent,
    required this.onTap,
  });
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = _hover ? widget.accent : SyvColors.warm200;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: SyvBorders.hairlineWidth),
            borderRadius: const BorderRadius.all(SyvRadius.md),
          ),
          child: Text(
            widget.label,
            style: SyvType.mono_.copyWith(fontSize: 16, height: 1, color: color),
          ),
        ),
      ),
    );
  }
}
