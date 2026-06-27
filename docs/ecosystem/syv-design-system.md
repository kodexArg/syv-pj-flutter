# `syv-design-system` — el lenguaje visual (upstream de `syv_ui`)

> **Repo hermano:** `../../../syv-design-system/` · tokens DTCG → targets Flutter/CSS.
> **Ya lo tenemos integrado** como [`packages/syv_ui/`](../../packages/syv_ui/)
> ("Diseño Verde"). Este repo es **el upstream**; nuestro `syv_ui` es su encarnación
> en esta app.
> **Foto tomada:** 2026-06-27.

---

## Qué es

El **SSOT visual** del ecosistema: un único archivo de tokens en formato **DTCG**
(`tokens/syv.tokens.json`) del que salen dos *targets* — un archivo **Dart** para
Flutter y un **CSS** para web — más una biblioteca de **componentes de
referencia** (Astro + Svelte). Es un repo de **consulta y referencia**, no una
app corriendo. El resultado es **"Diseño Verde"**: verde olivo mate militar,
negro-cálido, y un único glow neón como excepción de luz.

Es la **otra cara** de `syv-docs`: el lore dice cómo *suena* el mundo; el design
system dice cómo se *ve*. Misma voz, distinto canal.

---

## El flujo de tokens (cómo llega hasta nosotros)

```
tokens/syv.tokens.json     ← SSOT (DTCG, agnóstico). Todo valor nace acá.
        │  (regeneración manual / asistida — no hay pipeline automático en repo)
        ▼
flutter/syv_tokens.dart    ← target Flutter canónico del upstream
        │  (copia manual + adaptaciones)
        ▼
packages/syv_ui/lib/src/tokens/syv_tokens.dart   ← NUESTRA copia (en esta app)
```

> **Importante:** `syv_ui` **no** es una salida auto-generada ni un submódulo: es
> un **port manual / copia vendorizada** del target Flutter, con extensiones
> propias. El header dice `// GENERATED from tokens/syv.tokens.json`, pero la
> sincronización es a mano. Si cambia un valor de diseño, cambia **primero en el
> JSON del upstream** y después se re-porta acá. Nunca hardcodear valores sueltos.

---

## Los tokens (el vocabulario que ya usamos)

Definidos en `tokens/syv.tokens.json`, portados a `SyvColors / SyvSpace /
SyvRadius / SyvBorders / SyvMotion / SyvType / syvGlow / syvTheme()`.

- **Colores** — ink (negro-cálido `#0C0B09`…), cream/warm (texto), **green** (lead
  olivo `green500 #7B8A4E`, hover/press/soft, `greenNeon #34E867` *solo glow*),
  celeste (institucional), moss (superficies militares), amber/teal (segundas
  voces), semánticos good/warn/bad.
- **Tipografía** — `Nunito` (UI/display/body), `DM Mono` (código/kicker), `Saira
  Stencil One` (**solo** wordmark del logo), `Bitter` (rol `prose`, lectura larga).
  Escala: display 35 · headline 26 · title 19 · body 17 · prose 17 · mono 16 ·
  kicker 12 (único UPPERCASE).
- **Espaciado** — base 4px: xs..7xl (4·8·12·16·20·24·28·32·48·56·64).
- **Radio** — sm 4 (chips) · md 6 (botones/inputs) · lg 12 (cards) · pill 999 (dots).
- **Borde** — hairline 1.5px (ink600). **Sin sombras.**
- **Motion** — slow 760 · medium 320 · fast 160ms; easing `settle`
  cubic-bezier(0.16,1,0.3,1).
- **Glow** — `greenNeon` al 16%, un halo radial descentrado por superficie.

---

## Componentes de referencia (lo que `syv_ui` portea)

El upstream define 8 componentes canónicos en Astro y Svelte 5 — son el
**contrato visual** que nuestros widgets Flutter espejan:
`SyvButton`, `SyvCard`, `SyvChip`, `SyvInput`, `SyvKicker`, `SyvLogo`, `SyvStat`,
`SyvSwitch`. Más el `assets/logo/syv-mark.svg` (96×96), fuente de la geometría del
logo (la cruz de la Iglesia + dos chevrones de rango militar).

Nuestro `syv_ui` agrega **extensiones Flutter-only** sin equivalente web:
`SyvStatBtn`, `SyvSection`, `SyvTextarea`, `SyvHeader`, y los iconos de stat.

---

## "Diseño Verde" — reglas no negociables

1. **Paleta cerrada.** Lead `green500` (olivo mate, nunca luminoso). No se
   inventan colores fuera del SSOT.
2. **`greenNeon` es SOLO glow de fondo.** Nunca fill, texto ni borde.
3. **Sin sombras de elevación.** Profundidad = glow radial único + hairline
   1.5px + radios chicos.
4. **Todo en minúscula**, salvo el kicker (UPPERCASE mono) y el wordmark del
   logo (Saira Stencil One).
5. **Split UI ↔ lectura:** Nunito = interfaz; Bitter = prosa larga; DM Mono =
   terminal/kicker.
6. **Mobile-first. Sin emoji.** Castellano rioplatense, voz de archivista.
7. **Agnóstico al framework:** el token nace en el JSON; Flutter es el cómo.

---

## Qué se consigue de este repo

1. **El token SSOT** — todo color/espacio/radio/tipo/motion/glow. La verdad de
   los valores vive acá; nosotros la portamos.
2. **El lenguaje visual escrito** — `CLAUDE.md`, `INDEX.md`, `TYPOGRAPHY.md`,
   `LOGO.md`: las reglas verificables del Diseño Verde.
3. **La referencia de componentes** (Astro/Svelte) — el contrato de qué hace y
   cómo se ve cada `Syv*`.
4. **El mark SVG canónico** del logo.

---

## Estado de sincronización (reconciliado 2026-06-27)

El drift que había entre el upstream y nuestra copia quedó **cerrado en ambas
direcciones**:

- **`prose` bajó a `syv_ui`.** Sumamos `SyvColors.cream200` (`#E4DAC8`),
  `SyvType.serif = 'Bitter'` y `SyvType.prose` — el estilo de lectura larga para
  la `historia` del personaje y los relatos. La fuente Bitter ya estaba declarada
  en el `pubspec.yaml` de la app.
- **`amethyst500` subió al upstream.** `SyvColors.amethyst500` (`#B082C4`, el
  acento de "mente") se registró en el SSOT `tokens/syv.tokens.json` y se propagó
  a los dos targets (`flutter/syv_tokens.dart`, `astro+svelte/syv.tokens.css`).

> No hay pipeline automático: cada sync es manual y deliberado, y se documenta en
> ambos lados. La triada de acentos de atributo queda completa en el SSOT:
> **cuerpo → ámbar · mente → amatista · alma → celeste.**

---

## Docs propio

`syv-design-system` no tiene `docs/` separado ni `AGENTS.md` (usa `CLAUDE.md`).
Su documentación raíz: `CLAUDE.md` (reglas para agentes), `INDEX.md` (front-door
con todas las tablas de tokens y componentes), `TYPOGRAPHY.md`, `LOGO.md`,
`README.md`. En esta app, la guía de uso del DS vive en
[../DESIGN-SYSTEM.md](../DESIGN-SYSTEM.md).
