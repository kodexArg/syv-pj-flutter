# PRD — Visualizador de Personajes SyV (Flutter)

**Proyecto:** `syv-pj-flutter`
**Ecosistema:** Subordinación y Valor (SyV)
**Estado actual:** Etapa 1 completada · **Norte actualizado 2026-06-27**

---

## Norte / Steering (2026-06-27)

Este proyecto dejó de ser "solo un visualizador". El norte es más grande:

**`syv-pj-flutter` es la interfaz del universo — la cara que muestra los
personajes y cuenta las historias de *Subordinación y Valor*.** A medida que el
ecosistema genera nuevas piezas *a nuestras espaldas* (el motor `syv-pj-api`, el
simulador de batallas que viene, un futuro juego), esta app se convierte en su
**front-end común**: el lugar donde todo eso se ve y se toca.

Una sola disciplina lo gobierna: **cada vez que creamos algo, lo hacemos con el
lore en la cabeza.** No diseñamos features framework-first; partimos del universo
(`syv-docs`) y del dominio (`syv-pj`), y recién entonces elegimos el cómo en
Flutter. El nombre completo del proyecto es el mapa de la misión:

> **SUBORDINACIÓN Y VALOR → PERSONAJES → FLUTTER**
> (el lore · `syv-docs`) → (el dominio · `syv-pj`) → (la interfaz · esta app)

Qué implica este norte:

- **Seguimos sin backend propio.** No reimplementamos lógica: la consumimos.
  `syv-pj` define qué es un personaje; `syv-pj-api` lo genera/valida/sirve; el
  design system lo viste; nosotros lo mostramos. Mapa completo, endpoints y
  contratos en [`docs/ecosystem/`](docs/ecosystem/README.md) — lectura previa a
  cualquier integración o nombre de campo nuevo.
- **Cada superficie nueva entra con el lore puesto.** Una pantalla no es "una
  lista" o "un form": es una vista del universo (una ficha, un encuentro, una
  facción).
- **Crecemos por features, no por etapas cerradas.** El frontpage ya agrupa las
  acciones (generar personaje, listado, design system) y sumará más a medida que
  los proyectos hermanos maduren.

> Las **Etapas** de más abajo son el registro histórico del arranque. El norte de
> arriba es la dirección vigente; ante conflicto, manda el norte.

---

## Objetivo

Construir un **visualizador de personajes** para el universo SyV como aplicación
Flutter de escritorio Linux. La app es una capa de presentación pura: toma
entidades de personaje provistas por `syv-pj-api` y las muestra al usuario.
No implementa lógica de dominio ni genera personajes por sí misma.

La arquitectura está pensada para que el visualizador sea, más adelante,
un **módulo independiente e interconectable** dentro de una app mayor — por
ejemplo, integrado junto a un creador de personajes o un simulador de batallas.

---

## Posición en el ecosistema

| Dependencia | Qué aporta |
|---|---|
| `../syv-pj/` | Contratos y catálogos: define **qué es** un personaje. |
| `../syv-pj-api/` | Motor backend: clasifica, genera, valida y entrega personajes vía HTTP. |
| `../syv-design-system/` | Tokens de diseño, tipografía y guía visual que esta app adopta. |

Esta app **consume** esas fuentes. No reimplementa nada de su lógica.

---

## Etapas

### ETAPA 1 — Entorno base (COMPLETA)

> Estado actual del repositorio.

Instalación del entorno mínimo de desarrollo, común a cualquier app Flutter,
**antes** de decisiones de estilo, integración con la API o diseño visual.

Entregables completados:

- Flutter 3.44.2 (stable) gestionado vía FVM 4.1.1, pinned en `.fvmrc`.
- Target: Linux desktop (GNOME/Wayland). Ventana flotante 390×844, phone-portrait,
  borderless, no-resizable — vía `window_manager` 0.5.1.
- Layout de `lib/` con separación por features (`app/`, `features/home/`).
- App identitaria: `com.kodexarg` / `com.kodexarg.syvPjFlutter`.
- Suite de tests mínima: widget test + integration test scaffold.
- Skills Flutter bloqueados en `skills-lock.json`.
- Documentación inicial: AGENTS.md (SSOT), PRD.md, README.md, `docs/`.

Lo que **no** hace la Etapa 1: UI real, consumo de API, design system, lógica
de dominio, navegación entre fichas.

---

### ETAPA 2 — Harness AI (TBD)

Crear la infraestructura que permita a la IA iterar sobre la app con loops
y herramientas. Probablemente incluye:

- Servidor Python (uv) como intermediario o simulador de `syv-pj-api` local.
- Herramientas de inspección/testing automatizado de la UI Flutter.
- Definición de los contratos de entrada que la app espera del backend.

El detalle se define cuando el usuario da la orden de arrancar esta etapa.

---

### ETAPA 3 — Iterar y mejorar (TBD)

Ejecutar el ciclo completo de desarrollo del visualizador:

- UI real de fichas de personaje consumiendo `syv-pj-api`.
- Adopción de tokens y componentes de `syv-design-system`.
- Navegación entre vistas (lista, detalle, atributos).
- Pulido visual y de experiencia.

El alcance exacto se refinará al cerrar la Etapa 2.

---

## Restricciones permanentes

- **Sin backend propio.** Todo dato viene de `syv-pj-api`. Nunca reimplementar
  lógica de dominio en este repo.
- **Agnóstico al dominio.** Las decisiones de qué es un personaje viven en
  `syv-pj/`. Este repo solo presenta.
- **Un solo target activo por etapa.** Linux desktop en Etapas 1-2. Otros
  targets (móvil, web) se evalúan solo si el usuario los pide explícitamente.
- **FVM es el único gestor de SDK.** No usar `flutter` suelto del PATH del
  sistema; siempre `fvm flutter`.
