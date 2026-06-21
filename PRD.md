# PRD — Visualizador de Personajes SyV (Flutter)

**Proyecto:** `syv-pj-flutter`
**Ecosistema:** Subordinación y Valor (SyV)
**Estado actual:** Etapa 1 completada

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
