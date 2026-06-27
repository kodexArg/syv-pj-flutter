# ADR-001 — Glosario: cómo nombramos cada cosa

**Fecha:** 2026-06-21
**Estado:** aceptado

---

## Contexto

Este proyecto (`syv-pj-flutter`) construye un visualizador alrededor del universo
*Subordinación y Valor*. Conviven dos vocabularios: el **dominio** (personajes,
fichas, facciones, conceptos — cuya SSOT vive en el vault `syv-docs/`) y el
**código** (identificadores Dart, tokens del design system). Sin un diccionario
único, cada agente o desarrollador inventa su propio nombre para lo mismo y el
puente dominio↔código se erosiona.

## Decisión

Este ADR es la **SSOT de nomenclatura** del repo: registra, como regla
permanente, cómo se llama cada cosa — tanto el término de dominio SyV como el
identificador con que lo nombramos en código — y enlaza cada término a su ficha
canónica en el vault.

Postura **agnóstica** (heredada de la raíz del ecosistema): pensamos en
**entidades, fichas, vistas y contratos**, no en *modelos*, *tablas* o *widgets*.
El framework (Flutter, hoy) es el cómo final, nunca el qué. Un término de dominio
se nombra por lo que **es**, no por la clase que lo implementa.

Los enlaces al vault son **links markdown relativos** al checkout hermano
`syv-docs/` (desde `docs/adrs/` el prefijo es `../../../syv-docs/`). Todos los
targets fueron verificados en disco al escribir este ADR.

---

## Términos de dominio (SyV)

El dominio es **agnóstico al framework**. Estos términos provienen del corpus; su
forma canónica vive en el vault, no en el código.

| Término de dominio | Cómo lo nombramos en código | Enlace canónico al vault | Notas |
|---|---|---|---|
| **personaje** | `personaje` (no `character`) — campo/entidad de dominio | [Guía de Personajes](../../../syv-docs/0_proyecto/guias-para-colaboradores/guia-de-personajes.md) | Persona del universo. Una de las entidades centrales del creador de personajes. |
| **ficha** | `ficha` — la representación portable de un personaje | [Manual del Colaborador](../../../syv-docs/0_proyecto/guias-para-colaboradores/manual-del-colaborador.md) | El registro de un personaje (identidad + atributos + metadatos). No decir *row* ni *record* de framework. |
| **atributo** | `atributo` / `SyvStatKind` (vista del DS) | [Guía de Metadatos](../../../syv-docs/0_proyecto/guias-para-colaboradores/guia-de-metadatos.md) | Valor cuantificable de una ficha. Hoy el DS expone `SyvStatKind` como su catálogo de atributos visualizables (ver cuerpo/mente/alma abajo). |
| **facción** | `faccion` (sin tilde, ASCII, en código) | [Facciones](../../../syv-docs/1_trasfondo/facciones/facciones.md) · [Inquisición](../../../syv-docs/1_trasfondo/facciones/iglesia-de-darsena/inquisicion.md) | Grupo de poder/pertenencia. En vault se relaciona por wikilink (`[[inquisicion]]`); en código, `faccion`. |
| **ubicación** | `ubicacion` (sin tilde en código) | [Dársena](../../../syv-docs/2_atlas/ciudades/darsena/darsena.md) | Lugar del atlas. Dársena es la ubicación de referencia del showcase. |
| **concepto** | `concepto` | [Sinopsis](../../../syv-docs/1_trasfondo/sinopsis.md) | Idea/noción del trasfondo (no personaje ni lugar). La sinopsis es el concepto central del universo. |
| **relato** | `relato` (no `story`) | [Subordinación y Valor (índice)](../../../syv-docs/inicio.md) | Pieza narrativa de la diégesis. |
| **entidad** | `entidad` — tipo-padre de las anteriores | [Guía de Metadatos](../../../syv-docs/0_proyecto/guias-para-colaboradores/guia-de-metadatos.md) | Toda ficha del corpus declara **exactamente un** valor de `entidad`. Es la dimensión controlada raíz. |

### Taxonomía de `entidad`

Catálogo cerrado del campo `entidad` en el vault. En código se nombra con el
mismo átomo en minúsculas/ASCII/guiones; **nunca** como ruta (`personaje`, no
`entidad/personaje`):

`personaje` · `faccion` · `ubicacion` · `concepto` · `credo` · `hito` ·
`relato` · `guia` · `objeto` · `vehiculo`

Autoridad sobre qué campos/valores existen: la [Guía de
Metadatos](../../../syv-docs/0_proyecto/guias-para-colaboradores/guia-de-metadatos.md)
(SSOT). No se inventan valores sin registrarlos ahí.

---

## Atributos del personaje y términos de muestra

La triada de atributos **ya está canonizada** — no en `syv-docs` (el lore no
tiene una entidad de atributo dedicada) sino en **`syv-pj`**, el módulo de
dominio, en [docs/atributos.md](../../../syv-pj/docs/atributos.md): escala entera
**2..7**, son las únicas magnitudes numéricas persistidas de la ficha. Los
nombres legacy `fis`/`tac`/`men` están retirados.

| Término | Cómo lo nombramos en código | Estado | Notas |
|---|---|---|---|
| **cuerpo** | `SyvStatKind.cuerpo`, `_cuerpo` | **canónico — dominio `syv-pj`** | Fuerza, resistencia, potencia física. Fuente: [syv-pj/docs/atributos.md](../../../syv-pj/docs/atributos.md). Acento DS: ámbar (`amber500`). |
| **mente** | `SyvStatKind.mente`, `_mente` | **canónico — dominio `syv-pj`** | Puntería, reflejos, lectura táctica. Fuente: [syv-pj/docs/atributos.md](../../../syv-pj/docs/atributos.md). Acento DS: amatista (`amethyst500`). |
| **alma** | `SyvStatKind.alma`, `_alma` | **canónico — dominio `syv-pj`** | Aura, liderazgo, voluntad, temple ante el miedo. Fuente: [syv-pj/docs/atributos.md](../../../syv-pj/docs/atributos.md). Acento DS: celeste (`celeste500`). |
| **damián diconte** | texto de ejemplo en `_inputCtrl` del showcase | Personaje canónico, uso de muestra | El término ES canónico ([Damián DiConte](../../../syv-docs/3_personajes/principales/damian-diconte.md)); su aparición en el showcase es solo dato de ejemplo del campo de texto. |

---

## Términos de código y design system

El paquete `syv_ui` (design system "Diseño Verde") usa el prefijo **`Syv`** en
todo identificador público. El código y los nombres de clase son en inglés
(convención de la industria; ver
[ADR-004 de syv-pj-api](../../../syv-pj-api/.claude/rules/adr-004-english-code-spanish-contract.md)),
mientras que el contenido visible y los términos de dominio siguen al castellano.

| Término | Identificador / convención | Significado | Dónde vive |
|---|---|---|---|
| **prefijo `Syv`** | `Syv*` en toda clase/enum pública | Marca de pertenencia al design system; evita colisión con widgets de Flutter. | `packages/syv_ui/lib/` |
| **token** | `SyvColors`, `SyvSpace`, `SyvType`, `SyvRadius`, `SyvBorders`, `SyvMotion` | Valor de diseño primitivo (color, espacio, tipografía, radio, borde, animación). Origen DTCG en `syv-design-system`. | `packages/syv_ui/lib/src/tokens/syv_tokens.dart` |
| **accent** | `SyvAccent` (`olive`, `celeste`, `amber`, `teal`, `neon`, `white`, `bad`) + `SyvAccentRamp` | Color de acento aplicable a componentes; la rampa deriva sus variantes. | `packages/syv_ui/lib/src/foundations/syv_accent.dart` |
| **glow** | `SyvGlow` | Profundidad por luz, no por sombra: el rasgo visual central de "Diseño Verde". | `packages/syv_ui/lib/src/theme/syv_glow.dart` |
| **kicker** | `SyvKicker` | Pequeño rótulo numerado/etiqueta que antecede a un bloque. | `packages/syv_ui/lib/src/components/syv_kicker.dart` |
| **"Diseño Verde"** | string visible (`'diseño verde'`) | Nombre propio del design system: verde mate militar de *Subordinación y Valor*. | `packages/syv_ui/` (concepto del paquete) |
| **showcase** | `ShowcaseView` | Vista-espécimen que recorre cada componente del DS de arriba a abajo. | `lib/features/showcase/showcase_view.dart` |
| **visualizador** | (término de proyecto) | El cliente Flutter que muestra el universo SyV; es lo que construye este repo. | `syv-pj-flutter` (ver [AGENTS.md raíz](../../../CLAUDE.md)) |

---

## Consecuencias

- Cualquier agente o dev consulta **este archivo** antes de nombrar algo nuevo;
  si el término no está, se agrega acá por la misma regla agnóstica.
- Los atributos (`cuerpo`/`mente`/`alma`) son **canónicos del dominio `syv-pj`**
  (no del lore `syv-docs`): su fuente es
  [syv-pj/docs/atributos.md](../../../syv-pj/docs/atributos.md) (escala 2..7). El
  vault de lore no tiene entidad de atributo dedicada y no se espera que la tenga.
- Cambios de nombre en el corpus se propagan acá; los enlaces relativos asumen el
  layout hermano `syv-pj-flutter/` ↔ `syv-docs/` bajo `~/Dev/SyV/`.

## Referencias

- [Subordinación y Valor — índice del universo](../../../syv-docs/inicio.md)
- [ADR-004 (syv-pj-api): inglés en el código, castellano en el contrato](../../../syv-pj-api/.claude/rules/adr-004-english-code-spanish-contract.md)
- Plantilla y formato: [0000-template.md](0000-template.md) · [README de ADRs](README.md)
