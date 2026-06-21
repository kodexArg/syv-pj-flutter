// GENERATED from tokens/syv.tokens.json — Subordinación y Valor design system.
// "Diseño Verde" / Green Matte-Military — green evolution of the Naranja system.
// Do not hand-edit colors/values here; edit the JSON SSOT and regenerate.
// Mobile-first, warm near-black, military olive-drab lead, neon glow exception,
// Nunito + DM Mono + Saira Stencil One (logo wordmark only).
//
// Fonts: declare 'Nunito', 'DM Mono', and 'Saira Stencil One' in pubspec.yaml
// (or use google_fonts). Saira Stencil One is for the brand wordmark only.

import 'package:flutter/material.dart';

/// Raw palette. Lead with [green500] (matte military olive-drab 1978) as the
/// default interactive/heading color. [greenNeon] is the NEON EXCEPTION:
/// used only as the background glow radial — never a UI fill, text, or border.
abstract final class SyvColors {
  // ink / surface (warm near-black)
  static const ink1000 = Color(0xFF0C0B09); // deepest backdrop
  static const ink900  = Color(0xFF141210); // body / card surface
  static const ink850  = Color(0xFF1A1714); // raised card surface
  static const ink600  = Color(0xFF3A352F); // hairline borders
  static const ink500  = Color(0xFF6B6358); // muted / disabled

  // text
  static const cream100 = Color(0xFFF3EEE4); // primary text
  static const warm200  = Color(0xFFCDBFA8); // secondary text

  // green (lead accent — matte military olive-drab 1978)
  static const green500 = Color(0xFF7B8A4E); // DEFAULT interactive / heading
  static const green400 = Color(0xFF97A267); // hover / shimmer
  static const green600 = Color(0xFF5E6B3A); // press / deepen
  static const green300 = Color(0xFFB4BE8E); // soft / chips / tags
  static const greenDeep = Color(0xFF4A5530); // emphasis hairline
  // NEON EXCEPTION — background glow spot only, never UI fill/text/border
  static const greenNeon = Color(0xFF34E867);

  // celeste (institutional Argentina 1978)
  static const celeste500 = Color(0xFF8FB8D6);
  static const celeste300 = Color(0xFFBCD6E8);

  // moss (military surfaces)
  static const moss900 = Color(0xFF1A201A); // green-black band
  static const moss700 = Color(0xFF373D35); // slate-green panel
  static const moss500 = Color(0xFF4E564A); // military border / divider

  // warm white (= cream100, semantic alias for white-surface contexts)
  static const white = Color(0xFFF3EEE4); // = cream100

  // second voices
  static const amber500 = Color(0xFFE0A23C); // SyV tool accent (was Naranja lead)
  static const amber300 = Color(0xFFEFC074); // lighter amber wash
  static const teal500  = Color(0xFF4FA6AB); // petróleo
  static const teal300  = Color(0xFF7CC4C8);

  // semantic
  static const good = green500;
  static const warn = amber500;
  static const bad  = Color(0xFFD9694E); // warm red, never pure red
}

/// 4px-base spacing scale.
abstract final class SyvSpace {
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 20;
  static const double xxl = 24, xxxl = 28, xxxxl = 32;
  static const double s5 = 48, s6 = 56, s7 = 64;
}

/// Squared/austere military radii.
/// Cards → lg; buttons/inputs/switch → md; chips/badges → sm; pill → dots/avatars only.
abstract final class SyvRadius {
  static const Radius sm   = Radius.circular(4);   // chips / badges
  static const Radius md   = Radius.circular(6);   // buttons / inputs / switch
  static const Radius lg   = Radius.circular(12);  // cards
  static const Radius pill = Radius.circular(999); // dots / avatars only
}

abstract final class SyvBorders {
  static const double hairlineWidth = 1.5;
  static const BorderSide hairline =
      BorderSide(color: SyvColors.ink600, width: hairlineWidth);
}

abstract final class SyvMotion {
  static const Duration slow   = Duration(milliseconds: 760);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration fast   = Duration(milliseconds: 160);
  // cubic-bezier(0.16, 1, 0.3, 1) — overshoot settle
  static const Cubic settle = Cubic(0.16, 1, 0.3, 1);
}

/// Type scale (mobile-first base sizes, lowercase by convention).
/// 'kicker' is the only UPPERCASE style, colored green.500.
/// 'logo' (Saira Stencil One) is for the brand wordmark ONLY.
abstract final class SyvType {
  static const String sans = 'Nunito';
  static const String mono = 'DM Mono';
  static const String logo = 'Saira Stencil One'; // brand wordmark only

  static const TextStyle display = TextStyle(
      fontFamily: sans, fontWeight: FontWeight.w800, fontSize: 35,
      height: 1.08, letterSpacing: -0.7, color: SyvColors.cream100);
  static const TextStyle headline = TextStyle(
      fontFamily: sans, fontWeight: FontWeight.w800, fontSize: 26,
      height: 1.08, letterSpacing: -0.52, color: SyvColors.cream100);
  static const TextStyle title = TextStyle(
      fontFamily: sans, fontWeight: FontWeight.w500, fontSize: 19,
      height: 1.2, color: SyvColors.cream100);
  static const TextStyle body = TextStyle(
      fontFamily: sans, fontWeight: FontWeight.w400, fontSize: 17,
      height: 1.55, letterSpacing: 0.17, color: SyvColors.warm200);
  static const TextStyle mono_ = TextStyle(
      fontFamily: mono, fontWeight: FontWeight.w400, fontSize: 16,
      height: 1.6, color: SyvColors.cream100);
  static const TextStyle kicker = TextStyle(
      fontFamily: mono, fontWeight: FontWeight.w400, fontSize: 12,
      height: 1.2, letterSpacing: 2.16, color: SyvColors.green500);
}

/// The single off-center neon-green radial halo (the neon exception in
/// controlled form). Paint behind content; it is a layer, not an elevation
/// shadow (this system uses no shadows). greenNeon at opacity 0.16.
const RadialGradient syvGlow = RadialGradient(
  center: Alignment(0.56, -0.76), // ~78% x, 12% y
  radius: 0.9,
  colors: [Color(0x2934E867), Color(0x0D34E867), Color(0x0034E867)],
  stops: [0.0, 0.38, 0.7],
);

/// Assembled dark theme. Use as the app's single ThemeData.
ThemeData syvTheme() {
  const scheme = ColorScheme.dark(
    primary: SyvColors.green500,
    onPrimary: SyvColors.ink1000,
    secondary: SyvColors.teal500,
    surface: SyvColors.ink900,
    onSurface: SyvColors.cream100,
    error: SyvColors.bad,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: SyvColors.ink1000,
    fontFamily: SyvType.sans,
    textTheme: const TextTheme(
      displayLarge: SyvType.display,
      headlineLarge: SyvType.headline,
      titleLarge: SyvType.title,
      bodyLarge: SyvType.body,
      labelSmall: SyvType.kicker,
    ),
  );
}
