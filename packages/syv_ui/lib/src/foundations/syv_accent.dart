import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// The shared palette voice used by interactive components (button, switch).
///
/// Mirrors the CSS color options `olive·celeste·amber·teal·neon·white·bad`.
/// `neon` is the controlled neon exception (allowed as a button/switch accent,
/// never as a page fill).
enum SyvAccent { olive, celeste, amber, teal, neon, white, bad }

/// A resolved accent ramp: base, hover, press and the on-accent ink used for
/// text/icons that sit on top of a filled accent.
@immutable
class SyvAccentRamp {
  /// Creates a ramp from explicit colors.
  const SyvAccentRamp({
    required this.base,
    required this.hover,
    required this.press,
    required this.on,
  });

  /// Default / resting accent color.
  final Color base;

  /// Hover / shimmer color.
  final Color hover;

  /// Pressed / deepened color.
  final Color press;

  /// Ink that reads on top of [base] when the accent is a fill.
  final Color on;
}

/// Maps a [SyvAccent] to its token-driven [SyvAccentRamp]. Single source of the
/// accent ramps shared across components so colors stay consistent.
SyvAccentRamp syvAccentRamp(SyvAccent accent) {
  switch (accent) {
    case SyvAccent.olive:
      return const SyvAccentRamp(
        base: SyvColors.green500,
        hover: SyvColors.green400,
        press: SyvColors.green600,
        on: SyvColors.ink1000,
      );
    case SyvAccent.celeste:
      return const SyvAccentRamp(
        base: SyvColors.celeste500,
        hover: SyvColors.celeste300,
        press: Color(0xFF6F9CBF),
        on: SyvColors.ink1000,
      );
    case SyvAccent.amber:
      return const SyvAccentRamp(
        base: SyvColors.amber500,
        hover: SyvColors.amber300,
        press: Color(0xFFB97F28),
        on: SyvColors.ink1000,
      );
    case SyvAccent.teal:
      return const SyvAccentRamp(
        base: SyvColors.teal500,
        hover: SyvColors.teal300,
        press: Color(0xFF3C7E82),
        on: SyvColors.ink1000,
      );
    case SyvAccent.neon:
      return const SyvAccentRamp(
        base: SyvColors.greenNeon,
        hover: Color(0xFF5BF085),
        press: Color(0xFF22C13F),
        on: SyvColors.ink1000,
      );
    case SyvAccent.white:
      return const SyvAccentRamp(
        base: SyvColors.cream100,
        hover: Color(0xFFFFFFFF),
        press: SyvColors.warm200,
        on: SyvColors.ink1000,
      );
    case SyvAccent.bad:
      return const SyvAccentRamp(
        base: SyvColors.bad,
        hover: Color(0xFFE27C63),
        press: Color(0xFFB85540),
        on: SyvColors.ink1000,
      );
  }
}
