import 'package:flutter/material.dart';
import 'package:syv_ui/syv_ui.dart';

import '../ficha/ficha_view.dart';
import '../showcase/showcase_view.dart';

/// The front door of the visualizer. Brand up top, a one-paragraph hero, the
/// primary navigation grouped low (so the center breathes), and a project
/// footer pinned at the bottom.
///
/// Two of the three actions are inert until their features land; only "diseño
/// verde" is live and opens the design-system showcase. More actions slot into
/// the same low group as the app grows.
class HomeView extends StatelessWidget {
  /// Creates the home screen.
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SyvScreen(
      scrollable: true,
      children: <Widget>[
        // (center) mini-manual: what the universe is, and the three character
        // attributes at a glance.
        const Spacer(),
        Text(
          'un mundo que ardió y se rearmó con cruces y '
          'fusiles. una argentina del siglo xxii donde la '
          'fe católica rige con ley marcial, la tecnología '
          'es herejía y la humedad lo pudre todo.',
          style: SyvType.body,
        ),
        const SizedBox(height: SyvSpace.xl),
        const SyvKicker(child: Text('ATRIBUTOS')),
        const SizedBox(height: SyvSpace.md),
        const _StatLine(
          glyph: SyvStatGlyph.cuerpo,
          name: 'cuerpo',
          blurb: 'fuerza · resistencia',
          color: SyvColors.amber500,
        ),
        const SizedBox(height: SyvSpace.md),
        const _StatLine(
          glyph: SyvStatGlyph.mente,
          name: 'mente',
          blurb: 'puntería · reflejos',
          color: SyvColors.amethyst500,
        ),
        const SizedBox(height: SyvSpace.md),
        const _StatLine(
          glyph: SyvStatGlyph.alma,
          name: 'alma',
          blurb: 'aura · liderazgo · voluntad',
          color: SyvColors.celeste500,
        ),
        const Spacer(),

        // (low) primary navigation, grouped at the bottom
        SyvNavButton(
          icon: Icons.person_add_alt_1,
          label: 'generar personaje',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const FichaView(),
            ),
          ),
        ),
        const SizedBox(height: SyvSpace.md),
        const SyvNavButton(
          icon: Icons.format_list_bulleted,
          label: 'listado de personajes',
        ),
        const SizedBox(height: SyvSpace.md),
        SyvNavButton(
          icon: Icons.palette_outlined,
          label: 'diseño verde',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ShowcaseView(),
            ),
          ),
        ),

        // (bottom) project info
        const SizedBox(height: SyvSpace.s5),
        const _ProjectFooter(),
      ],
    );
  }
}

/// One row of the attribute mini-manual: the stat glyph, its name, and a terse
/// blurb of what it governs. Small by design — this is a legend, not a control.
class _StatLine extends StatelessWidget {
  const _StatLine({
    required this.glyph,
    required this.name,
    required this.blurb,
    required this.color,
  });

  final SyvStatGlyph glyph;
  final String name;
  final String blurb;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SyvStatIcon(glyph: glyph, size: 22, color: color),
        const SizedBox(width: SyvSpace.md),
        Text(
          name,
          style: SyvType.body.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            height: 1,
            color: SyvColors.cream100,
          ),
        ),
        const SizedBox(width: SyvSpace.sm),
        Expanded(
          child: Text(
            blurb,
            style: SyvType.mono_.copyWith(
              fontSize: 11.5,
              height: 1,
              color: SyvColors.warm200,
            ),
          ),
        ),
      ],
    );
  }
}

/// Project info pinned at the very bottom: a hairline rule, the eyebrow, and a
/// one-paragraph description of what this app is.
class _ProjectFooter extends StatelessWidget {
  const _ProjectFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: SyvSpace.lg),
      decoration: const BoxDecoration(
        border: Border(top: SyvBorders.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SyvKicker(child: Text('EL PROYECTO')),
          const SizedBox(height: SyvSpace.sm),
          Text(
            'cliente flutter del universo subordinación y valor. crece alrededor '
            'del corpus —la única fuente de verdad— sumando herramientas a medida '
            'que la historia las pide. en construcción.',
            style: SyvType.body.copyWith(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
