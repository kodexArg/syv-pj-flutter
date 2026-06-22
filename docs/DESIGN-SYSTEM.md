# Diseño Verde — Sistema de Diseño

Sistema de diseño Flutter del universo *Subordinación y Valor*. Viste el visualizador de fichas de personaje: el lector no define el estilo — lo consume desde el paquete `syv_ui`.

## Propósito y SSOT

La fuente de verdad de todos los tokens es el repo `../syv-design-system` (DTCG JSON). A partir de ese JSON se genera [`packages/syv_ui/lib/src/tokens/syv_tokens.dart`](../packages/syv_ui/lib/src/tokens/syv_tokens.dart) mediante el pipeline de transformación del design system. **Nunca editar ese archivo a mano** — cualquier cambio de valor va al JSON y se regenera.

La app declara la dependencia por path en su `pubspec.yaml`:

```yaml
dependencies:
  syv_ui:
    path: packages/syv_ui
```

Dependencia externa del paquete: `flutter_svg ^2.0.0` (iconos stat).

## Reglas no negociables del Diseño Verde

- **Sin sombras de elevación.** La profundidad se construye con glow radial neón descentrado + hairline 1.5 px + radios pequeños.
- **`greenNeon` es solo glow de fondo.** Nunca se usa como fill, color de texto ni borde.
- **Mobile-first, todo minúscula** salvo el kicker (uppercase en mono) y el wordmark del logo (Saira Stencil One).
- **Paleta cerrada.** El olivo `green500` lidera los interactivos. Celeste/cream son los colores institucionales. Ámbar y petróleo son segundas voces. No se inventan colores fuera del SSOT generado.
- **Fuentes declaradas en el `pubspec.yaml` de la app** (no del paquete): Nunito (body/display), DM Mono (código/kicker), Saira Stencil One (wordmark del logo únicamente).

## Estructura del paquete

```
packages/syv_ui/lib/
├── syv_ui.dart                  ← barrel público
└── src/
    ├── tokens/
    │   └── syv_tokens.dart      ← GENERADO (paleta, espaciado, radios, tipografía, theme)
    ├── theme/
    │   ├── syv_theme.dart       ← re-exporta syvTheme() y syvGlow desde tokens
    │   └── syv_glow.dart        ← widget SyvGlow (fondo canónico de pantalla)
    ├── foundations/
    │   └── syv_accent.dart      ← enum SyvAccent + SyvAccentRamp
    ├── icons/
    │   └── syv_stat_icons.dart  ← glyphs stat (SVG strings + SyvStatSvg + SyvStatIcon)
    └── components/
        ├── syv_button.dart
        ├── syv_card.dart
        ├── syv_chip.dart
        ├── syv_input.dart
        ├── syv_kicker.dart
        ├── syv_logo.dart
        ├── syv_section.dart
        ├── syv_stat.dart
        ├── syv_statbtn.dart
        └── syv_switch.dart
```

Capas en orden de dependencia: **tokens → theme/glow → foundations → icons → components**.

## Consumo

```dart
import 'package:syv_ui/syv_ui.dart';

// 1. Registrar el tema en la app
MaterialApp(
  theme: syvTheme(),
  home: ...,
);

// 2. Envolver cada pantalla con el fondo canónico
SyvGlow(
  child: Scaffold(...),
)
```

El showcase completo con todos los componentes vive en
[`lib/features/showcase/showcase_view.dart`](../lib/features/showcase/showcase_view.dart).

---

## Tokens y fundamentos

### Tokens generados — [`syv_tokens.dart`](../packages/syv_ui/lib/src/tokens/syv_tokens.dart)

| Clase | Qué expone |
|---|---|
| `SyvColors` | Paleta completa: `ink*`, `cream100`, `warm200`, `green*`, `greenNeon`, `celeste*`, `moss*`, `amber*`, `teal*`, `amethyst500`, semánticos `good/warn/bad` |
| `SyvSpace` | Escala 4 px: `xs(4)` `sm(8)` `md(12)` `lg(16)` `xl(20)` `xxl(24)` `xxxl(28)` `xxxxl(32)` `s5(48)` `s6(56)` `s7(64)` |
| `SyvRadius` | `sm(4)` chips/badges · `md(6)` botones/inputs/switch · `lg(12)` tarjetas · `pill(999)` avatares |
| `SyvBorders` | `hairlineWidth = 1.5` · `hairline` (BorderSide ink600) |
| `SyvMotion` | `slow(760ms)` `medium(320ms)` `fast(160ms)` · curva `settle` (cubic-bezier overshoot) |
| `SyvType` | Estilos de texto: `display` `headline` `title` `body` `mono_` `kicker` · constantes `sans/mono/logo` |
| `syvGlow` | `RadialGradient` del halo neón descentrado (el "glow" de pantalla) |
| `syvTheme()` | `ThemeData` ensamblado con `ColorScheme.dark` + tipografía |

### Fondo canónico — [`syv_glow.dart`](../packages/syv_ui/lib/src/theme/syv_glow.dart)

`SyvGlow` es el widget que envuelve cada pantalla: pinta `ink1000` como superficie y superpone `syvGlow` (el halo radial neón descentrado al 16 %). Reemplaza cualquier uso de `Scaffold(backgroundColor:...)` cuando se quiere el look completo.

### Accent — [`syv_accent.dart`](../packages/syv_ui/lib/src/foundations/syv_accent.dart)

`enum SyvAccent { olive, celeste, amber, teal, neon, white, bad }`

Función `syvAccentRamp(SyvAccent)` → `SyvAccentRamp { base, hover, press, on }`. Usada internamente por `SyvButton` y `SyvSwitch` para calcular el color en cada estado de interacción.

### Iconos stat — [`syv_stat_icons.dart`](../packages/syv_ui/lib/src/icons/syv_stat_icons.dart)

Tres glifos de la hoja de personaje de *SyV*:

| `SyvStatGlyph` | Icono | Uso semántico |
|---|---|---|
| `cuerpo` | bíceps | fuerza · resistencia |
| `mente` | retícula óptica | puntería · reflejos |
| `alma` | laureles | aura · liderazgo · voluntad |

Dos clases de render disponibles:

- **`SyvStatSvg`** — render fiel vía `flutter_svg` con `ColorFilter` (preferido para el sigilo engraved del tile).
- **`SyvStatIcon`** — `CustomPainter` de respaldo; constructores nombrados `.cuerpo()` `.mente()` `.alma()`.

Ambas aceptan `glyph`, `size` (edge en px lógicos) y `color` opcional.

---

## Catálogo de componentes

### SyvButton — [`syv_button.dart`](../packages/syv_ui/lib/src/components/syv_button.dart)

Acción primaria o secundaria. Sin sombra: profundidad por fill / hairline / radio.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `label` | `String` | — | Texto del botón (forzado a minúscula, o uppercase si `mono: true`) |
| `variant` | `SyvButtonVariant` | `primary` | `primary` (fill) · `secondary` (hairline) · `ghost` (solo texto) |
| `color` | `SyvAccent` | `olive` | Ramp de color activa |
| `size` | `SyvButtonSize` | `md` | `md` · `sm` |
| `mono` | `bool` | `false` | Usa DM Mono uppercase en lugar de Nunito lowercase |
| `disabled` | `bool` | `false` | Aspecto deshabilitado, sin respuesta a toques |
| `onPressed` | `VoidCallback?` | `null` | Callback de tap |

---

### SyvCard — [`syv_card.dart`](../packages/syv_ui/lib/src/components/syv_card.dart)

Superficie oscura con luz off-center. Profundidad por glow radial + hairline + radio `lg`.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `child` | `Widget` | — | Contenido |
| `variant` | `SyvCardVariant` | `standard` | `standard` (verde) · `alt` (teal) · `emphasis` (olivo+neón brillante) · `military` (celeste+musgo) |
| `glow` | `bool` | `false` | Agrega un bloom centrado interno sobre la luz de variante |

---

### SyvChip — [`syv_chip.dart`](../packages/syv_ui/lib/src/components/syv_chip.dart)

Píldora de estado pequeña en mono. Hairline + radio `sm`, sin sombra.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `label` | `String` | — | Texto |
| `tone` | `SyvChipTone` | `neutral` | `ok` (verde) · `work` (ámbar) · `stop` (teal) · `celeste` · `bad` (rojo cálido) · `solid` (fill olivo) · `neutral` (cream/ink) |
| `dot` | `bool` | `false` | Punto de estado líder |

---

### SyvInput — [`syv_input.dart`](../packages/syv_ui/lib/src/components/syv_input.dart)

Campo de texto "máquina de escribir". Sin borde perimetral: la profundidad viene del platen (regla basal). DM Mono en el interior; la regla verdea al foco y enrojece en estado inválido.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `label` | `String?` | — | Etiqueta mono uppercase con prefijo `›` |
| `hint` | `String?` | — | Texto de ayuda bajo el campo; enrojece con `invalid` |
| `invalid` | `bool` | `false` | Estado de error |
| `placeholder` | `String?` | — | Placeholder cuando el campo está vacío |
| `disabled` | `bool` | `false` | Deshabilita la interacción y aplica opacidad 42 % |
| `value` | `String?` | — | Texto inicial (ignorado si se provee `controller`) |
| `controller` | `TextEditingController?` | — | Controlador externo opcional |
| `onChanged` | `ValueChanged<String>?` | — | Callback de cambio |

Al foco activa la grilla de celdas monoespaciadas (hairline por celda) + glow interno + caret underscore plano alineado a la celda.

---

### SyvKicker — [`syv_kicker.dart`](../packages/syv_ui/lib/src/components/syv_kicker.dart)

Eyebrow mono UPPERCASE — el único elemento en mayúsculas del sistema. Verde `green500`, tracking amplio. Usado como cabecera de sección en todo el DS.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `child` | `Widget` | — | Label (se aplicará el estilo kicker) |
| `num` | `String?` | — | Índice líder opcional, p. ej. `"01"` |

---

### SyvLogo — [`syv_logo.dart`](../packages/syv_ui/lib/src/components/syv_logo.dart)

Lockup de marca: cruz (la Iglesia) sobre dos chevrones de sargento (rango militar), en un canvas 96×96, más wordmark "SUBORDINACIÓN y VALOR" en Saira Stencil One y sub-línea mono. Las variantes solo recolorean.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `variant` | `SyvLogoVariant` | `militar` | `militar` (olivo+neón) · `argentina` (celeste institucional) · `clerical` (blanco) |
| `size` | `SyvLogoSize` | `md` | `sm(27px)` · `md(38px)` · `lg(56px)` |
| `wordmark` | `bool` | `true` | Muestra el wordmark y sub-línea junto al mark |
| `sub` | `String?` | `'diseño verde · clandestino'` | Texto bajo el wordmark; `null` para omitirlo |

---

### SyvSection — [`syv_section.dart`](../packages/syv_ui/lib/src/components/syv_section.dart)

Cabecera de sección: eyebrow kicker promovido a heading. Sin subrayado; el tracking amplio y el color `green400` actúan de divisor. Padding superior `s7(64)`, inferior `lg(16)`.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `title` | `String` | — | Texto de la sección (se fuerza uppercase) |
| `num` | `String?` | — | Índice líder opcional, p. ej. `"06"` |

---

### SyvStat — [`syv_stat.dart`](../packages/syv_ui/lib/src/components/syv_stat.dart)

Control de atributo de hoja de personaje. Escala 2–7. Superficie de tarjeta con luz off-center, glifo del stat, nombre + sub-línea, valor grande, gauge de 6 segmentos, y opcionalmente steppers −/+ y pips cliqueables.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `stat` | `SyvStatKind` | — | `cuerpo` (ámbar) · `mente` (amatista) · `alma` (celeste) |
| `value` | `int` | `2` | Valor actual, recortado a 2–7 |
| `editable` | `bool` | `false` | Habilita pips y steppers interactivos |
| `onChanged` | `ValueChanged<int>?` | — | Callback con el nuevo valor |

---

### SyvStatBtn — [`syv_statbtn.dart`](../packages/syv_ui/lib/src/components/syv_statbtn.dart)

Tile cuadrado tappable (aspect ratio 1:1). Tres en fila representan la triada cuerpo·mente·alma. Superficie `ink1000` con glow radial top-right, sigilo engraved al 22 % de acento, cabecera nombre+valor y gauge de 6 pips. El borde acenta en hover/press.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `stat` | `SyvStatKind` | — | Atributo representado |
| `value` | `int` | — | Valor actual (2–7) |
| `onPressed` | `VoidCallback?` | `null` | Callback de tap; `null` = inerte (útil para filas de solo lectura) |

Convenience: **`SyvStatBtnRow`** arma la fila de tres tiles preconfigurada (max-width 440, gap `md`) con parámetros `cuerpo/mente/alma` y sus callbacks.

---

### SyvSwitch — [`syv_switch.dart`](../packages/syv_ui/lib/src/components/syv_switch.dart)

Toggle 44×26 px. El estado ON acenta el borde del track y el thumb con el ramp elegido. Sin sombra; profundidad por hairline + radio `md`.

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `checked` | `bool` | — | Estado del toggle |
| `onChanged` | `ValueChanged<bool>?` | — | Callback con el nuevo estado; `null` = inerte |
| `color` | `SyvAccent` | `olive` | Ramp de color en estado ON |
| `disabled` | `bool` | `false` | Aspecto deshabilitado, sin respuesta |
| `label` | `String?` | — | Texto opcional a la derecha del track |
