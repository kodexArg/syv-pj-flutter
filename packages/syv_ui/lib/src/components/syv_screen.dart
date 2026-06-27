import 'package:flutter/material.dart';

import '../theme/syv_glow.dart';
import '../tokens/syv_tokens.dart';
import 'syv_header.dart';

/// The canonical page shell: the standard chrome every screen shares, plus the
/// permanent [SyvHeader] pinned at the top of the content column.
///
/// Owns, from the outside in: a black [Scaffold], the [SyvGlow] backdrop, a
/// [SafeArea], a centred [ConstrainedBox] capped at [maxWidth], and the standard
/// page padding. Inside that frame it lays out a stretch [Column] whose first
/// child is always the brand header; pages supply only the below-header content
/// via [child].
///
/// [children] are spliced into the same stretch [Column] as the header, as its
/// siblings — so a [Spacer] among them shares the column's flex with the header,
/// which the sticky-footer recipe depends on.
///
/// Two layout modes:
///  * Default ([scrollable] = false) — the header sits at the top and [children]
///    flow beneath it. Use for short, static pages (a blank canvas passes no
///    children at all).
///  * [scrollable] = true — the padded column is wrapped in a sticky-footer
///    scroll recipe (a [SingleChildScrollView] whose content is at least as tall
///    as the viewport, via [IntrinsicHeight] + a min-height [ConstrainedBox]).
///    [Spacer]s among [children] then pin a tail to the bottom when there is
///    room, and the whole page scrolls instead of overflowing on short
///    viewports. The header stays in the same on-screen position either way.
class SyvScreen extends StatelessWidget {
  /// Creates the page shell. [children] are rendered below the header, as the
  /// header's siblings in one stretch column.
  const SyvScreen({
    super.key,
    this.children = const <Widget>[],
    this.scrollable = false,
    this.maxWidth = 720,
  });

  /// Content placed in the column directly beneath the permanent header, as its
  /// siblings. Empty for a header-only canvas.
  final List<Widget> children;

  /// When true, wraps the page in the sticky-footer scroll recipe so [Spacer]s
  /// among [children] push content to the bottom and the page scrolls when
  /// cramped.
  final bool scrollable;

  /// The maximum content width. The established value is 720.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SyvColors.ink1000,
      body: SyvGlow(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: scrollable
                  // Sticky-footer recipe: a scroll view whose content is at
                  // least as tall as the viewport, so any Spacer in [child]
                  // pushes its tail to the bottom (center stays empty) when
                  // there is room, and the whole thing scrolls instead of
                  // overflowing on short viewports.
                  ? LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: SizedBox(
                              width: double.infinity,
                              child: _column(),
                            ),
                          ),
                        ),
                      ),
                    )
                  : _column(),
            ),
          ),
        ),
      ),
    );
  }

  /// The padded stretch column: the permanent header, then [children] as its
  /// siblings.
  Widget _column() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SyvSpace.xxl,
        SyvSpace.s5,
        SyvSpace.xxl,
        SyvSpace.s7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SyvHeader(),
          ...children,
        ],
      ),
    );
  }
}
