# AGENTS.md — `syv-pj-flutter`

> Parte del ecosistema *Subordinación y Valor* (SyV). Antes de tocar nada,
> leé el [`AGENTS.md` de la raíz](../CLAUDE.md) y el de `../syv-pj/`.
>
> **Este archivo es el SSOT del repo.** `CLAUDE.md` es un alias que apunta aquí.

---

## Qué es esto

`syv-pj-flutter` es **la interfaz del universo SyV**: la cara que muestra los
personajes y cuenta sus historias. Empezó como un visualizador de fichas y crece
hacia algo más grande — **el front-end común de todos los proyectos que se
generan alrededor de la SSOT** (hoy el creador de personajes; mañana, el
simulador de batallas, y lo que venga).

- **Es la capa de presentación del ecosistema.** No tiene backend propio: la
  lógica de dominio (qué es un personaje) y el motor (generar / validar / servir)
  viven afuera, en `syv-pj` y `syv-pj-api`. Nosotros los **consumimos** y los
  **mostramos**.
- **Construimos con el lore en la cabeza.** Cada feature nace pensando en el
  universo (`syv-docs`), no en el framework. El nombre completo lo dice:
  **subordinación y valor → personajes → flutter** (lore → dominio → interfaz).

> El mapa de los proyectos hermanos y qué se consigue de cada uno vive en
> [`docs/ecosystem/`](docs/ecosystem/README.md). Entender `syv-pj` y `syv-pj-api`
> es **tan importante como** entender el universo `syv-docs`.

---

## De dónde sale lo que muestra

| Fuente | Rol | Relación |
|---|---|---|
| [`../syv-pj/`](../syv-pj/) | Define **qué es** un personaje (contratos, catálogos, reglas). | Base conceptual — este visualizador refleja esas entidades. |
| [`../syv-pj-api/`](../syv-pj-api/) | El **motor**: clasifica, genera, valida y entrega personajes vía API. | **Esta app consume esa API.** No reimplementa nada de su lógica. |
| [`../syv-design-system/`](../syv-design-system/) | El **sistema de diseño**: tokens, tipografía, componentes. | Esta app **usa** ese design system para renderizar. |

---

## Principio

Agnóstico al dominio en la cabeza, Flutter en las manos. Pensamos en
**entidades**, **vistas** y **contratos** — no en "modelos" ni "widgets" como
sustantivos de negocio. El framework es el cómo final; la idea nace agnóstica.

> Ver glosario del agnosticismo en el [`AGENTS.md` raíz](../CLAUDE.md).

---

## Stack técnico (Etapa 1 — estado actual)

| Componente | Versión | Notas |
|---|---|---|
| Flutter | **3.44.2** (stable) | Pinned vía FVM en `.fvmrc` |
| Dart | **3.12.2** | Incluido en el SDK de Flutter |
| FVM | **4.1.1** | Gestiona el SDK; `fvm flutter` en lugar de `flutter` suelto |
| Target | **Linux desktop** (GNOME/Wayland) | Única plataforma activa ahora |
| Ventana | `window_manager` 0.5.1 | 390×844, phone-portrait, borderless, no-resizable |
| Identidad | `com.kodexarg` / `com.kodexarg.syvPjFlutter` | `syv_pj_flutter` como nombre de paquete Dart |

`uv` **no** se usa para Flutter. Está reservado para el harness Python de Etapa 2.

---

## Layout de `lib/`

```
lib/
  main.dart                        # Punto de entrada; inicializa ventana y corre la app
  app/
    app.dart                       # MaterialApp raíz
    window_config.dart             # Configuración de window_manager (tamaño, decoración)
  features/
    home/
      home_view.dart               # Vista "Hola, mundo!" + botón Cerrar
```

Tests en `test/widget_test.dart`. Integración en `integration_test/`.

---

## Cómo correr

```bash
cd /home/kodex/SyV/syv-pj-flutter
fvm flutter run -d linux
```

---

## Etapas del proyecto

### Etapa 1 — Entorno base (COMPLETA)

Instalación del entorno mínimo de desarrollo, común a cualquier app Flutter,
antes de decisiones de estilo o integración. Incluye:

- FVM + Flutter 3.44.2 pinned
- Target Linux desktop + `window_manager`
- Layout de `lib/` con separación de features
- Suite de tests mínima (widget + integration)
- Skills Flutter lockeados en `skills-lock.json`

### Etapa 2 — Harness AI (TBD)

Crear un harness para la IA con loops y herramientas. Probablemente incluye
un servidor Python (uv) que alimenta la app con datos de `syv-pj-api`.

### Etapa 3 — Iterar y mejorar (TBD)

Ejecutar el ciclo completo de iteración: UI real de visualizador de personajes,
integración con `syv-design-system`, consumo real de la API.

---

## Reglas para agentes

1. **No modificar** `lib/`, `linux/`, `pubspec.yaml`, `.fvmrc`, `test/`,
   `.gitignore`, `.agents/`, `skills-lock.json` salvo instrucción explícita
   del usuario en la conversación actual.
2. **Documentación** vive en `docs/`. Las decisiones de arquitectura van en
   `docs/adrs/` con formato `YYYYMMDD-slug.md`. Primero consultá los ADRs
   existentes antes de proponer cambios estructurales.
3. **Plain GitHub Markdown** para todo lo de este repo — no es un vault de
   Obsidian; sin wikilinks ni frontmatter.
4. Para tareas de dominio consultá siempre `../syv-pj/` antes de inventar
   contratos o catálogos.
5. Seguís las reglas del [`AGENTS.md` raíz](../CLAUDE.md) en todo lo que no
   esté sobreescrito aquí.
