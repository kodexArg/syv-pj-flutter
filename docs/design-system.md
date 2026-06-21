# Design System en Flutter — investigación y preparación

> **Estado:** investigación / steering. **No se implementa todavía.** Este
> documento reúne *findings* sobre cómo se componen los design systems en
> Flutter y cómo, llegado el momento, incorporaremos
> [`../syv-design-system`](../../syv-design-system/) a esta app. Las decisiones
> que se tomen a partir de acá se registran como ADRs en
> [`docs/adrs/`](adrs/).

Investigación reunida por un fan-out de agentes (web + docs canónicas), 2026-06.
Las fuentes están al final, agrupadas por tema.

---

## 1. Propósito

`syv-pj-flutter` **no define estilo**: lo consume. Toda decisión visual vive en
[`../syv-design-system`](../../syv-design-system/) (el *"Diseño Verde"*). Este
doc prepara el terreno para que, cuando se dé la orden, la incorporación sea una
decisión informada y no improvisada.

El objetivo de la investigación: entender **las capas con que se arma un design
system en Flutter**, qué herramientas existen, qué hacen los proyectos reales, y
cómo eso encaja con lo que `syv-design-system` ya tiene.

---

## 2. Qué vamos a incorporar (estado real del DS)

`syv-design-system` ya resolvió el modelo **un SSOT → varios targets**:

| Pieza | Archivo | Rol |
|---|---|---|
| **SSOT** | `tokens/syv.tokens.json` | Tokens en formato **W3C/DTCG** (`$type`, `$value`, referencias `{color.green.500}`). La verdad. |
| **Target Flutter** | `flutter/syv_tokens.dart` | Dart **generado** desde el JSON. Cabecera `GENERATED from …`. |
| **Target web** | `astro+svelte/syv.tokens.css` | Custom properties `--syv-*`. |
| **Componentes** | `astro+svelte/{astro,svelte}/Syv*` | 7 componentes (`Button, Card, Chip, Input, Switch, Stat, Logo, Kicker`) replicados en Astro y Svelte. **Aún no existen en Flutter.** |

### 2.1. El target Dart que ya existe

`flutter/syv_tokens.dart` expone clases `abstract final` con `static const`
(no instancias, no `ThemeExtension` — todavía):

```dart
abstract final class SyvColors {
  static const ink900   = Color(0xFF141210); // body / card surface
  static const green500 = Color(0xFF7B8A4E); // LEAD interactive / heading
  static const greenNeon= Color(0xFF34E867); // NEON: solo glow de fondo
  static const amber500 = Color(0xFFE0A23C); // segunda voz
  static const teal500  = Color(0xFF4FA6AB); // petróleo
  // … ink/cream/warm/celeste/moss/semantic
}
abstract final class SyvSpace  { static const md = 12.0, lg = 16.0, /* base 4px */ }
abstract final class SyvRadius { static const md = Radius.circular(6); /* austero */ }
abstract final class SyvBorders{ static const hairlineWidth = 1.5; static const hairline = BorderSide(color: SyvColors.ink600, width: 1.5); }
abstract final class SyvMotion { static const settle = Cubic(0.16, 1, 0.3, 1); /* + durations */ }
abstract final class SyvType   { static const sans='Nunito', mono='DM Mono', logo='Saira Stencil One'; /* + TextStyles */ }
```

### 2.2. Reglas no negociables del Diseño Verde (impactan la arquitectura)

- **Sin sombras de elevación.** Profundidad = glow radial neón descentrado +
  hairline 1.5px + radios chicos. → en Flutter esto es `elevation: 0` por
  defecto y `BoxDecoration` custom, **no** `Material` elevation.
- **`greenNeon` es excepción:** solo glow de fondo, nunca fill/texto/borde.
- **Mobile-first, todo minúscula** salvo el *kicker* (único uppercase).
- **Paleta cerrada:** olivo lidera; celeste/blanco institucional; ámbar y
  petróleo como segundas voces. No se inventan colores fuera del SSOT.
- **3 familias tipográficas:** Nunito (body/display), DM Mono (código/kicker),
  Saira Stencil One (**solo** wordmark del logo).

---

## 3. Anatomía de un design system en Flutter

Un DS en Flutter se compone en capas. De abajo (datos) hacia arriba (UI):

```
┌─ Capa 5 · Catálogo + testing visual (Widgetbook, golden tests)
├─ Capa 4 · Componentes (Syv* widgets, atoms→molecules, barrel exports)
├─ Capa 3 · Estética no-Material (glow/hairline/no-elevation, ButtonStyle)
├─ Capa 2 · Tipografía (TextTheme + fuentes bundled)
├─ Capa 1 · Theming runtime (ThemeData + ColorScheme + ThemeExtension)
└─ Capa 0 · SSOT de tokens (DTCG json) → codegen → tokens.dart
```

### Capa 0 — SSOT de tokens (DTCG) → Dart

El estándar es **W3C Design Tokens Community Group (DTCG)**: cada token tiene
`$type` + `$value`, con referencias (`{color.green.500}`). Es exactamente lo que
`syv.tokens.json` ya usa. De ahí se **generan** los targets; nunca se hardcodea.

Pipeline típico **JSON → Dart**:

```
syv.tokens.json (SSOT, DTCG)
   │  herramienta de transform
   ▼
syv_tokens.dart (constantes Dart)   ── o ──   app_theme.tailor.dart (ThemeExtension)
```

Herramientas reales (ver §6):
- **Style Dictionary** — el transformador clásico; soporta salida Dart/Flutter.
- **`design_tokens_builder` (simpleclub)** — JSON → `ThemeData` + `ColorScheme`
  M3 + extensiones, vía `build_runner`.
- **`figma2flutter`** — exports de Tokens Studio (Figma) → Dart, incluso tokens
  de composición.
- **`theme_tailor`** — *no* parte de JSON: genera el *boilerplate* de
  `ThemeExtension` (`copyWith`/`lerp`/`==`) desde una clase Dart anotada.

### Capa 1 — Theming runtime

Dos mecanismos nativos, complementarios:

1. **`ThemeData` + `ColorScheme` (Material 3)** — la fundación. `ColorScheme`
   tiene ~45 roles (`primary/onPrimary`, `surface`, `outline`, …). Se puede
   generar con `ColorScheme.fromSeed(seed)` **o** escribir a mano (lo que
   necesita una paleta cerrada como la nuestra). Se accede con
   `Theme.of(context).colorScheme`.

2. **`ThemeExtension<T>`** — el mecanismo canónico para meter **tokens custom**
   que Material no contempla (glow, hairline 1.5px, ámbar, moss, motion). Se
   define una clase inmutable con `copyWith` + `lerp`, se registra en
   `ThemeData.extensions`, y se lee con `Theme.of(context).extension<T>()`.
   Interpola suave en transiciones de tema.

> **Decisión central de la incorporación** (→ ADR): el target Dart actual usa
> **constantes estáticas** (`SyvColors.green500`), que se consumen sin
> `context`. La alternativa idiomática es envolver esos tokens en un
> `ThemeExtension` para acceso theme-aware. Trade-off en §7.

### Capa 2 — Tipografía

- **Bundlear fuentes** en `pubspec.yaml` (`flutter: fonts:`) es lo
  recomendado para un DS: determinista y offline. `google_fonts` sirve como
  conveniencia (y usa los assets bundleados si están, evitando fetch HTTP).
- **`TextTheme`** es el contenedor semántico (displayLarge, bodyMedium, …). Para
  3 familias + escala propia, lo limpio es una escala en `SyvType` (ya existe) y
  opcionalmente un `ThemeExtension` tipográfico para acceso por `context`.

### Capa 3 — Estética no-Material

Flutter Material es **base, no jaula**. Para el look austero/olivo sin sombras:

- Profundidad por **`BoxDecoration`**: `RadialGradient`/`boxShadow` de baja
  opacidad descentrado para el glow + `Border` hairline.
- Botones sin Material feel: `elevation: 0` + `splashFactory: NoSplash.splashFactory`.
- Formas con `RoundedRectangleBorder` y radios chicos (`SyvRadius`).
- Para glow fino, `CustomPainter`.

### Capa 4 — Componentes

- Estructura de paquete: implementación en `lib/src/` (privada),
  API pública por **barrel export** (`lib/syv_ui.dart`).
- Organización **atoms → molecules** (Button/Chip/Input → Card/Stat) o por
  feature.
- Widgets **stateless, sin lógica de negocio**, que leen tokens (nunca
  hardcodean), con `enum` para variantes (no booleans). Prefijo `Syv*`.

### Capa 5 — Catálogo + testing visual

- **Widgetbook** o **storybook_flutter**: catálogo navegable de componentes
  aislados (use-cases/stories), con knobs y preview en vivo.
- **Golden tests** con **Alchemist** (o `golden_toolkit`): snapshots
  pixel-comparados en CI para evitar regresiones visuales.

---

## 4. Patrones de código clave (curados)

**ThemeExtension para tokens custom del Diseño Verde:**
```dart
@immutable
class SyvTheme extends ThemeExtension<SyvTheme> {
  final Color glow;          // greenNeon, solo fondo
  final Color lead;          // green500
  final double hairlineWidth;// 1.5
  const SyvTheme({required this.glow, required this.lead, required this.hairlineWidth});

  @override SyvTheme copyWith({Color? glow, Color? lead, double? hairlineWidth}) =>
      SyvTheme(glow: glow ?? this.glow, lead: lead ?? this.lead,
               hairlineWidth: hairlineWidth ?? this.hairlineWidth);

  @override SyvTheme lerp(ThemeExtension<SyvTheme>? o, double t) {
    if (o is! SyvTheme) return this;
    return SyvTheme(
      glow: Color.lerp(glow, o.glow, t)!,
      lead: Color.lerp(lead, o.lead, t)!,
      hairlineWidth: lerpDouble(hairlineWidth, o.hairlineWidth, t)!,
    );
  }
}
// registro: ThemeData(extensions: [SyvTheme(glow: SyvColors.greenNeon, lead: SyvColors.green500, hairlineWidth: 1.5)])
// uso:      Theme.of(context).extension<SyvTheme>()!.lead
```

**Profundidad sin elevación (glow + hairline):**
```dart
Container(
  decoration: BoxDecoration(
    color: SyvColors.ink900,
    border: Border.fromBorderSide(SyvBorders.hairline), // 1.5px ink600
    borderRadius: const BorderRadius.all(SyvRadius.lg),
    boxShadow: [BoxShadow(                               // glow, NO sombra dura
      color: SyvColors.greenNeon.withValues(alpha: 0.12),
      blurRadius: 24, spreadRadius: -6, offset: const Offset(8, -6), // descentrado
    )],
  ),
);
```

**Botón austero (sin elevación, sin ripple):**
```dart
FilledButton(
  style: FilledButton.styleFrom(
    elevation: 0,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: SyvColors.green500,
    foregroundColor: SyvColors.ink1000,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(SyvRadius.md)),
    side: BorderSide.none,
  ),
  onPressed: () {},
  child: const Text('aceptar'), // minúscula por convención
);
```

**Fuentes bundleadas (pubspec):**
```yaml
flutter:
  fonts:
    - family: Nunito
      fonts: [{ asset: assets/fonts/Nunito-Regular.ttf },
              { asset: assets/fonts/Nunito-ExtraBold.ttf, weight: 800 }]
    - family: DM Mono
      fonts: [{ asset: assets/fonts/DMMono-Regular.ttf }]
    - family: Saira Stencil One   # solo wordmark
      fonts: [{ asset: assets/fonts/SairaStencilOne-Regular.ttf }]
```

---

## 5. Catálogo de design systems open-source (referencia)

Repos reales para robarles patrones (token handling, `ThemeExtension`,
estructura de componentes, codegen):

- [Forui](https://github.com/forus-labs/forui) — minimalista estilo shadcn; CLI
  de codegen de tokens, 40+ widgets componibles. Muy activo.
- [SBB Design System](https://github.com/SchweizerischeBundesbahnen/design_system_flutter)
  — enterprise; `ColorScheme` propio + `ThemeExtension`, `WidgetStateProperty`
  para estilo semántico. Override theme-wide o por widget.
- [Orange OUDS Flutter](https://github.com/Orange-OpenSource/ouds-flutter) —
  arquitectura de tokens en capas (raw → contract → themed), multi-marca,
  `OudsTheme` para acceso tree-wide. **El más cercano a nuestro modelo SSOT.**
- [flutter-shadcn-ui](https://github.com/nank1ro/flutter-shadcn-ui) /
  [shadcn_flutter](https://github.com/sunarya-thito/shadcn_flutter) — port de
  shadcn; paridad de catálogo con la web (útil: replicamos componentes web).
- [Mix](https://github.com/conceptadev/mix) — sistema de estilos desacoplado del
  widget; tokens como átomos Dart, API fluida (`color($primary).onDark()`).
- [Wolt Modal Sheet](https://github.com/woltapp/wolt_modal_sheet) — patrón
  decorator + layout responsive de producción.
- [NES UI](https://github.com/erickzanardo/nes_ui) — identidad visual fuerte
  *encima* de Material sin pelearlo (caso análogo a nuestro look no-Material).
- [flutter_gen](https://github.com/FlutterGen/flutter_gen) — codegen type-safe de
  assets/fonts/colores (`Assets.fonts.…`).
- [Material 3 / Gallery](https://github.com/flutter/gallery) — referencia
  canónica de APIs de theming.

**Patrón común a todos:** `token → theme contract → ThemeExtension +
WidgetStateProperty → componentes componibles`, con codegen para reducir
boilerplate.

---

## 6. Herramientas del pipeline DTCG → Dart

| Etapa | Herramienta | Entrada → Salida |
|---|---|---|
| Spec | [W3C DTCG](https://www.designtokens.org/tr/drafts/format/) | define `$type`/`$value` (ya lo usamos) |
| Transform | [Style Dictionary](https://styledictionary.com/) | tokens.json → Dart/CSS/… |
| Transform | [`design_tokens_builder`](https://github.com/simpleclub/design_tokens_builder) | tokens.json → `ThemeData`+`ColorScheme` M3 |
| Transform | [`figma2flutter`](https://pub.dev/packages/figma2flutter) | Tokens Studio (Figma) → Dart |
| Theme codegen | [`theme_tailor`](https://pub.dev/packages/theme_tailor) | clase anotada → `ThemeExtension` (copyWith/lerp/==) |
| Catálogo | [Widgetbook](https://docs.widgetbook.io/) · [storybook_flutter](https://pub.dev/packages/storybook_flutter) | use-cases → catálogo navegable |
| Golden | [Alchemist](https://github.com/Betterment/alchemist) | widgets → snapshots CI |

> Hoy `syv_tokens.dart` se genera con el tooling propio del repo
> `syv-design-system`. Si en el futuro queremos `ThemeExtension` generado,
> `theme_tailor` o `design_tokens_builder` son los candidatos.

---

## 7. La decisión central para SyV (futuro ADR)

**¿Cómo consume Flutter los tokens de `syv-design-system`?**

| Opción | Cómo | A favor | En contra |
|---|---|---|---|
| **A. Constantes estáticas** (lo que ya hay) | `SyvColors.green500` directo | Cero ceremonia, sin `context`, simple, ya generado | No theme-aware; sin light/dark runtime; difícil multi-tema |
| **B. `ThemeData` + `ThemeExtension`** | tokens → `ThemeData.extensions`, leídos por `context` | Idiomático, theme-aware, interpola, integra con widgets Material | Más boilerplate (mitigable con `theme_tailor`); requiere generar otra capa |
| **C. Híbrido** | constantes como *raw layer* + un `ThemeExtension` fino que las referencia | Lo mejor de ambos; raw para casos simples, theme-aware donde importa | Dos formas de acceder; hay que disciplinar cuándo cada una |

**Inclinación de la investigación:** dado que el Diseño Verde es **una paleta
cerrada, dark-first, un solo tema**, la Opción A alcanza para arrancar y es la
que el target ya entrega. La Opción C es el destino natural cuando aparezcan
componentes (`Syv*`) que se beneficien de acceso por `context`. **Decisión real
cuando se dé la orden de incorporar — se registra como ADR.**

---

## 8. Mapa de incorporación (cuando se dé la orden — NO ahora)

A alto nivel, sin ejecutar:

1. Traer `syv_tokens.dart` a la app (dependencia de path al repo, submódulo, o
   copia generada — decisión de ADR).
2. Bundlear las 3 fuentes en `pubspec.yaml` + assets.
3. Definir el `ThemeData` base (dark-first, `elevation: 0`, `useMaterial3`,
   `ColorScheme` a mano desde la paleta, `splashFactory` neutro).
4. Elegir A/B/C (§7) y, si corresponde, generar el `ThemeExtension`.
5. Portar los 7 componentes `Syv*` web → widgets Flutter (atoms→molecules).
6. Montar catálogo (Widgetbook) + golden tests.

Cada paso con su decisión documentada en [`docs/adrs/`](adrs/).

---

## 9. Fuentes

**Fundación / ThemeData / ColorScheme**
- https://docs.flutter.dev/cookbook/design/themes
- https://api.flutter.dev/flutter/material/ColorScheme-class.html
- https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html
- https://m3.material.io/foundations/design-tokens
- https://docs.flutter.dev/release/breaking-changes/material-design-3-token-update

**ThemeExtension**
- https://api.flutter.dev/flutter/material/ThemeExtension-class.html
- https://vibe-studio.ai/insights/creating-reusable-design-system-tokens-in-flutter-with-theme-extensions
- https://medium.com/@alexandersnotes/flutter-custom-theme-with-themeextension-templates-792034106abc

**Pipeline DTCG → Dart**
- https://www.designtokens.org/tr/drafts/format/
- https://styledictionary.com/getting-started/examples/
- https://pub.dev/packages/figma2flutter
- https://github.com/simpleclub/design_tokens_builder
- https://pub.dev/packages/theme_tailor

**Tipografía / fuentes**
- https://docs.flutter.dev/ui/design/text/typography
- https://docs.flutter.dev/cookbook/design/fonts
- https://pub.dev/packages/google_fonts
- https://m3.material.io/styles/typography/type-scale-tokens

**Estética no-Material**
- https://api.flutter.dev/flutter/painting/BoxDecoration-class.html
- https://api.flutter.dev/flutter/material/ButtonStyle-class.html

**Componentes / estructura de paquete**
- https://dart.dev/tools/pub/package-layout
- https://github.com/VeryGoodOpenSource/very_good_templates
- https://www.fluttermix.com/documentation/mix/guides/design-token

**Catálogo de design systems** — ver §5 (links inline).

**Catálogo + testing visual**
- https://docs.widgetbook.io/quick-start
- https://pub.dev/packages/storybook_flutter
- https://github.com/Betterment/alchemist
- https://www.widgetbook.io/blog/1komma5%C2%BA-custom-flutter-design-system-with-widgetbook
