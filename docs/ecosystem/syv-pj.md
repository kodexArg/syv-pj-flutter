# `syv-pj` — el dominio del personaje

> **Repo hermano:** [`../../../syv-pj/`](../../../syv-pj/) · Markdown puro (Obsidian
> Flavored Markdown) · git submódulo de `syv-pj-api` (montado en `vendor/syv-pj/`).
> **Foto tomada:** 2026-06-27. La verdad viva está en el repo.

---

## Qué es

`syv-pj` define **qué ES un personaje** en *Subordinación y Valor*: sus campos,
sus atributos, cómo se clasifica, cómo se genera y cómo muta en el tiempo. **No
es una aplicación ni código de producción** — es un conjunto de **contratos,
catálogos y reglas** en Markdown. Es autónomo y agnóstico: sirve igual a la
diégesis, a un juego de rol, a un simulador o a nuestro visualizador, sin
favorecer a ninguno.

No es dueño del lore (ese vive en `syv-docs`); es dueño de la **mecánica y la
forma** del personaje.

---

## La ficha, campo a campo

Seis bloques persistidos + una válvula de escape. Fuente: `../../../syv-pj/docs/hoja-personaje.md`
y `../../../syv-pj/MODEL.md`.

```yaml
personaje:
  identidad:  { slug, nombre, sobrenombre, especialidad, genero, edad }
  atributos:  { cuerpo, mente, alma }   # únicas magnitudes numéricas persistidas
  tags:       [ "<categoria>/<slug>", ... ]   # lista plana, last-wins
  historia:   str                       # prosa biográfica (120–200 palabras), se congela al canonizar
  historial:  [ hito, ... ]             # hitos de SOLO AÑADIR
  metadatos:  { creado_en, canonizado_en, ultima_actualizacion }
  extras:     object | null             # válvula de escape para clientes
```

### Identidad

| Campo | Tipo | Notas |
|---|---|---|
| `slug` | `^[A-Z0-9]{8}$` \| `null` | Patente opaca. `null` mientras es efímero. |
| `nombre` | `str` | Legible, inmutable, no único. |
| `sobrenombre` | `str \| null` | Apodo. |
| `especialidad` | `str \| null` | Rol narrativo legible (Fusilero, Médico…). |
| `genero` | `str` | `masculino \| femenino \| no_binario \| otro` (catálogo abierto). |
| `edad` | `int` | — |

### Atributos — la triada `cuerpo · mente · alma`

Escala entera **2..7** (más es mejor). Son las **únicas magnitudes numéricas
persistidas**. Fuente: `../../../syv-pj/docs/atributos.md`.

| Clave | Semántica canónica |
|---|---|
| `cuerpo` | fuerza, resistencia orgánica, potencia física |
| `mente` | puntería, reflejos, lectura táctica |
| `alma` | aura, liderazgo, voluntad, temple ante el miedo |

> **Esto es la fuente canónica de nuestra mini-manual** del frontpage. Las
> etiquetas que mostramos (`cuerpo` = fuerza · resistencia, `mente` = puntería ·
> reflejos, `alma` = aura · liderazgo · voluntad) salen de acá. Los nombres
> legacy `fis`/`tac`/`men` están **retirados**.

### Estadísticas derivadas (no persistidas; se calculan al servir)

`INICIATIVA`, `MORAL`, `FATIGA_max`, `MOVIMIENTO`, `ESTRESS_max`, `SANAR`,
`PERCEPCION`, y los que sirve el motor: `es_canon`, `fatiga_max` (= cuerpo+alma),
`moral_max` (= alma), `fza_aportada`, `filiacion`. Se computan a partir de los
atributos base y los modificadores de los tags activos.

---

## El sistema de tags

Todo lo discreto que no es identidad, atributo, prosa o auditoría **es un tag**.
Lista plana de strings, notación `«categoria/slug»` (o
`«categoria/subcategoria/slug»`). No es multiconjunto: ante repetidos, gana el
último (last-wins). Incluso los vínculos personales son tags.

Categorías de referencia (abiertas):

| Categoría | Significado |
|---|---|
| `faccion` / `subfaccion` | Pertenencia al bando / grupo subordinado. |
| `rango` / `mando` | Jerarquía operativa / capacidad de mando. |
| `estado` | Disponibilidad operativa (exactamente uno; `disponible` al nacer). |
| `salud` / `moral` / `mental` | Estados acumulables (campaña, no creación). |
| `rasgo` | Físico observable, **sin** efecto mecánico (cicatriz, tatuaje). |
| `aspecto` | Identidad mecánicamente **activa** (efecto pasivo/reactivo). |
| `habilidad` | Habilita tiradas contra un `atributo_dominante`. |
| `entrenamiento` | Adiestramiento recibido. |
| `equipo` | Ítem cargado (`arma` · `utilitario` · `vestidura`). |
| `especialidad` | Especialidad táctica (`combate` · `oficio` · `jerarquia` · `narrativo` · `paranormal` · `investigacion`). |
| `lealtad` / `aliado` / `nemesis` | Vínculos relacionales (planos). |

---

## Los catálogos (lo que da nombres y efectos)

Viven en `../../../syv-pj/resources/`. Son la SSOT de datos que el motor sortea y
que nosotros usamos para mostrar **nombres legibles** y **efectos**:

| Catálogo | Tamaño | Para qué lo usamos |
|---|---|---|
| `facciones/` | ~20 | Nombre legible + descripción de cada bando. |
| `subfacciones/` | 11 | Grupos bajo `iglesia` y `fuerzas_armadas`. |
| `rangos/` | 20 archivos (uno por facción) | Nombre + `atributos_base` + escalera jerárquica. |
| `especialidades/` | 30 pools / 184 roles | Rol narrativo del personaje. |
| `catalogos/aspecto/` | 23 | Nombre + efectos mecánicos (`mod`/`pct`/`condicion`). |
| `catalogos/habilidad/` | 5 | Nombre + `atributo_dominante`. |
| `catalogos/entrenamiento/` | 9 | Nombre legible. |
| `catalogos/equipo/` | ~65 | Nombre, subcategoría, peso, tipo de arma, alcance. |
| `catalogos/rasgo/` | 4 | Nombre legible (cosmético). |
| `reglas/` | 8 | Pesos y cuotas de generación. |
| `personajes/` | 34 fichas | Datos de ejemplo canónicos (útiles como mock/fixtures). |

Las **20 facciones**: `arpistas`, `canales_ocultos`, `fuerzas_armadas`,
`gremio_de_comercio`, `gremio_de_pescadores`, `guardianes_de_la_memoria`,
`iglesia`, `iluminati`, `kuna_mbarete`, `los_criptografos`, `los_hackers`,
`los_remanentes`, `los_umbanda`, `masones`, `punteros`, `refugiados_y_parias`,
`resistencia_subterranea`, `saqueadores_y_traficantes`, `shipibo_conibo`,
`traficantes_de_almas`.

---

## El hito (`historial[]`)

El historial es de **solo añadir**. Cada hito:

```yaml
fecha: "2024-05-01"          # ISO-8601
tipo: "combate"              # catálogo sugerido y abierto
actores: ["K9F2H3M4"]        # patentes de personajes
descripcion: "Defiende la Zanja…"   # obligatorio
encuentro: "NMC8H5P9" | null # patente de encuentro
metadata: {}                 # objeto libre
```

---

## Reglas y azar portable

- **Atributos en creación = determinísticos**: salen de la tabla
  `rango → atributos_base`, cero azar.
- **Azar portable**: probabilidades en **porcentaje**; modificadores de
  atributos como **delta entero** (`+1 ALMA`); modificadores sobre magnitudes
  continuas como **porcentaje** (`-100% MOVIMIENTO`). Nunca expresiones atadas a
  dados.
- **Reproducibilidad**: `(semilla, faccion, rango)` reproduce el mismo personaje
  efímero (fases 1–7). La prosa (LLM) no es reproducible.
- `requires` / `excluye` en catálogos son **documentación ejecutable**, no
  constraints duros: el motor los consulta, la API no los impone.

---

## Convenciones que nos obligan (de su AGENTS.md)

- **Los nombres de campo del frontmatter son contrato programático** y **nunca
  se renombran**: quedan en inglés/minúscula. (Esta regla manda incluso sobre
  "traducir a castellano".)
- Slug de personaje: patente `^[A-Z0-9]{8}$`. Slug de catálogo:
  `lowercase_con_underscore`, sin acentos. Campos YAML: `snake_case_castellano`.
- `syv-pj` **no inventa lore**: antes de introducir geografía/facciones/
  vocabulario, se verifica contra `syv-docs`.
- La prosa de `historia` y `historial[].descripcion` es **irreemplazable**;
  cambios destructivos solo con autorización explícita.

---

## Qué se consigue de este repo

Para nosotros (la interfaz), `syv-pj` es **la base conceptual**: nos dice qué
renderizar y cómo nombrarlo.

1. **El esquema completo de la ficha** — los 6 bloques + derivados — para saber
   qué campos mostrar y cuáles son mutables.
2. **Los catálogos** — para traducir cada tag (`aspecto/veterano`,
   `equipo/arma/fusil`, `faccion/iglesia`…) a su **nombre legible** y, en
   aspectos, a sus **efectos**.
3. **La tabla `rango → atributos_base`** — para contextualizar los atributos de
   un personaje según su rango.
4. **Las fórmulas de derivadas y efectos** — para calcular y mostrar
   INICIATIVA/MORAL/FATIGA/etc. a partir de atributos + tags.
5. **34 fichas de ejemplo** — como datos de prueba y referencia visual mientras
   no consumimos la API en vivo.

> En la práctica, casi nunca leemos `syv-pj` directo: lo consumimos **a través
> de `syv-pj-api`**, que ya lee estos catálogos y nos sirve la ficha lista. Ver
> [syv-pj-api.md](./syv-pj-api.md).

---

## Su propia documentación (en el repo hermano)

`syv-pj` tiene un `docs/` técnico bien desarrollado (no editar desde acá):
`hoja-personaje.md` (la ficha), `atributos.md` (atributos + derivadas),
`sistema-tags.md`, `contratos.md` (aspecto/habilidad/efecto),
`generacion-procedural.md` (las 8 fases), `historial.md`, `casos-de-uso.md`,
`diegesis.md` (puntero a `syv-docs`). Más los contratos raíz: `API.md`,
`MODEL.md`, `PRD.md`.
