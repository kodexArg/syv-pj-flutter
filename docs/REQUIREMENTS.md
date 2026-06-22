# Requisitos — syv-pj-flutter

Reglas-motor del proyecto. Aplican hacia adelante en toda sesión de trabajo.

---

## Funcionales

| # | Requisito |
|---|---|
| F-1 | La app **visualiza fichas de personaje** del universo *Subordinación y Valor*. Muestra datos; no los genera ni los valida. |
| F-2 | Los datos de personaje provienen de `../syv-pj-api` vía HTTP. La app no reimplementa lógica de dominio; para saber qué es un personaje se consulta `../syv-pj/`. |
| F-3 | La app es **solo lectura** desde la perspectiva del dominio: no crea, no edita, no persiste personajes. |
| F-4 | El target de ejecución es **mobile-first**: Android como plataforma primaria, iOS como secundaria. La carpeta `linux/` existe en el scaffold pero no es target activo. |
| F-5 | La interfaz se construye íntegramente con componentes del paquete `packages/syv_ui` ("Diseño Verde"). Ningún widget de presentación se inventa fuera del design system sin incorporarlo primero al paquete. |

---

## No funcionales

| # | Requisito |
|---|---|
| NF-1 | **SDK contenido y reproducible.** La versión de Flutter (3.44.2) está pinneada en `.fvmrc` y gestionada por FVM 4.1.1. Todo agente y entorno usa `fvm flutter`; `flutter` suelto no se usa. |
| NF-2 | **Paleta cerrada — "Diseño Verde".** Color, tipografía, espaciado y efectos de glow provienen exclusivamente de los tokens DTCG del paquete `syv_ui`. No se hardcodean valores visuales en `lib/`. |
| NF-3 | **Cobertura de tests.** Toda widget nueva tiene su test en `test/` (widget tests). Flujos críticos de navegación tienen cobertura en `integration_test/` (e2e en device/emulador). |
| NF-4 | **Documentación en plain GitHub Markdown.** Este repo no es un vault de Obsidian; sin wikilinks ni frontmatter YAML. Decisiones de arquitectura van en `docs/adrs/` con formato `YYYYMMDD-slug.md`. |
| NF-5 | **Dependencias mínimas.** Solo se añaden dependencias cuando resuelven un problema concreto y probado. Preferir el SDK de Flutter sobre paquetes de terceros cuando la funcionalidad está disponible. |
| NF-6 | **Python + uv para scripts de harness.** Cualquier automatización externa a la app (seed de datos, generación, pipelines de IA) usa Python 3.13+ con `uv`. No se incluyen scripts Bash de más de una línea para lógica de negocio. |

---

## Reglas para agentes

1. **No modificar** `lib/`, `linux/`, `pubspec.yaml`, `.fvmrc`, `test/`, `integration_test/`, `.gitignore` sin instrucción explícita del usuario en la conversación actual.
2. **No reimplementar dominio.** Para saber qué campos tiene una ficha, qué catálogos existen o qué reglas rigen un personaje, consultar `../syv-pj/` primero.
3. **No añadir dependencias de red, estado global ni UI libraries** fuera de `syv_ui` sin una decisión documentada en `docs/adrs/`.
4. El paquete `packages/syv_ui` es de alcance del mismo repo; se modifica como cualquier otro archivo del proyecto, con la misma regla de instrucción explícita.
5. `linux/` no es target: no compilar ni ajustar código específico de desktop sin orden expresa.
