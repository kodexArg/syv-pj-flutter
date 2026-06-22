# Arquitectura — syv-pj-flutter

## Qué es (y qué NO es)

`syv-pj-flutter` es el **visualizador de personajes** del universo *Subordinación y Valor*. Su único rol es recibir datos de una ficha de personaje y presentarlos. No genera personajes, no valida reglas de dominio, no tiene base de datos propia.

- **Sí:** capa de presentación, navegación de fichas, render del design system.
- **No:** lógica de dominio, backend, validación de reglas, persistencia.

---

## Relación con el ecosistema SyV

| Repo externo | Rol | Relación con esta app |
|---|---|---|
| `../syv-pj/` | Define **qué es** un personaje: contratos, catálogos, reglas. | Fuente conceptual. Esta app refleja esas entidades; no las reimplementa. |
| `../syv-pj-api/` | Motor backend: clasifica, genera y entrega personajes vía HTTP. | **Esta app consume esa API.** Aún no hay cliente HTTP activo; la costura está preparada. |
| `../syv-design-system/` | Tokens DTCG → targets Flutter / CSS. | Materializado como el paquete local `packages/syv_ui`. |

---

## Gestión del SDK — FVM

El SDK está **contenido y pinneado** vía FVM 4.1.1. La versión exacta (`3.44.2 stable`) vive en `.fvmrc`.

Regla permanente: siempre `fvm flutter <comando>`, nunca `flutter` suelto. Esto garantiza reproducibilidad entre agentes y entornos sin depender del Flutter instalado globalmente.

---

## Target: mobile-first

| Plataforma | Estado |
|---|---|
| Android | **Target primario activo** |
| iOS | Target secundario activo |
| Linux (`linux/`) | Carpeta presente (scaffold generado por Flutter), **no es target** — `window_manager` fue removido |

La carpeta `linux/` existe en el árbol pero no se compila ni se mantiene. El target de referencia es Android; iOS sigue en paralelo.

---

## Layout de `lib/`

```
lib/
  main.dart                          # Entrada: runApp(SyvPjApp())
  app/
    app.dart                         # SyvPjApp — MaterialApp con syvTheme()
                                     # home: ShowcaseView (estado actual)
  features/
    showcase/
      showcase_view.dart             # Specimen vivo del design system
                                     # Costura: se reemplaza por la vista de ficha
                                     # de personaje en la próxima feature
```

Cada feature futura crece en su propia carpeta bajo `features/` sin tocar las demás. `app/app.dart` es el único punto que las ensambla mediante routing.

---

## Paquete `packages/syv_ui` — capa de presentación

El design system "Diseño Verde" vive como paquete Flutter local. La app lo consume por path (`syv_ui: path: packages/syv_ui`).

Estructura interna del paquete:

```
packages/syv_ui/lib/
  syv_ui.dart                # Barrel export
  src/
    tokens/syv_tokens.dart   # Tokens DTCG generados
    theme/syv_theme.dart     # MaterialTheme construido desde tokens
    theme/syv_glow.dart      # BoxShadow/glow helpers
    foundations/syv_accent.dart
    components/              # SyvButton, SyvCard, SyvChip, SyvInput,
                             # SyvKicker, SyvLogo, SyvSection,
                             # SyvStat, SyvStatBtn, SyvSwitch
    icons/syv_stat_icons.dart
```

Para el catálogo completo de componentes ver `docs/DESIGN-SYSTEM.md`.

---

## Costuras para el futuro

| Costura | Dónde | Cuándo |
|---|---|---|
| Cliente HTTP hacia `syv-pj-api` | `lib/core/` nuevo o `lib/app/` | Al incorporar fichas reales |
| Router / navegación entre vistas | `lib/app/app.dart` | Al añadir la segunda feature |
| Harness Python (uv) | Script fuera de `lib/`, en raíz del repo | Al automatizar generación / seed de datos |

---

## Dependencias activas

### App (`pubspec.yaml`)

| Paquete | Versión | Propósito |
|---|---|---|
| `cupertino_icons` | ^1.0.8 | Íconos (soporte multiplataforma) |
| `syv_ui` | path local | Design system "Diseño Verde" |
| `flutter_lints` | ^6.0.0 (dev) | Lint recomendado |
| `integration_test` | SDK (dev) | Tests e2e en device/emulador |

### Paquete `syv_ui`

| Paquete | Versión | Propósito |
|---|---|---|
| `flutter_svg` | ^2.0.0 | SVG para el logo y assets del design system |

### Fuentes (bundleadas a nivel app)

| Familia | Archivos | Uso |
|---|---|---|
| Nunito | Variable (400/500/800) | Tipografía base |
| DM Mono | Regular + Medium 500 | Monospace / datos de ficha |
| Saira Stencil One | Regular | Display / títulos de impacto |
