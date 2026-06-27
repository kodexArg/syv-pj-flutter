# `syv-pj-api` — el motor que sirve las fichas

> **Repo hermano:** [`../../../syv-pj-api/`](../../../syv-pj-api/) · FastAPI +
> Pydantic v2 · Python 3.13 · `uv` · Cloudflare Workers + D1.
> **Esta es la fuente que esta app va a CONSUMIR.**
> **Foto tomada:** 2026-06-27. La verdad viva está en el repo.

---

## Qué es

El **motor de backend** del creador de personajes. Un servidor HTTP que:

- **genera** personajes proceduralmente (pipeline de 8 fases, azar reproducible),
- **clasifica** vía el sistema de tags,
- **valida** contra contratos Pydantic,
- **canoniza** (persiste) un efímero como personaje durable, y
- **entrega** la ficha completa, con los campos derivados calculados en cada
  lectura.

Es **agnóstico al frontend**: no renderiza nada, solo produce y sirve la data.
Nosotros somos uno de sus clientes.

---

## Dónde vive

| | |
|---|---|
| **URL de producción** | `https://syv-pj-api.gcavedal.workers.dev` |
| Runtime | Cloudflare Python Worker (Pyodide/workerd), sin Docker |
| Persistencia prod | Cloudflare **D1** (SQLite-compatible), binding `env.DB` |
| Persistencia local | SQLite (`aiosqlite`), archivo `./var/kdx_pj.db` |
| Dev local | `uv run uvicorn personajes.api.app:app --reload` |
| Deploy | `uvx --from workers-py pywrangler deploy` (desde `worker/`) |
| Datos de dominio | submódulo `vendor/syv-pj/` (ver [syv-pj.md](./syv-pj.md)) |

> **CORS / Auth:** ⚠ no verificado. La app FastAPI no configura `CORSMiddleware`
> y no hay auth en el repo. Antes de pegarle desde Flutter web hay que confirmar
> si el Worker agrega headers CORS; desde Flutter mobile/desktop no aplica.

---

## La API — endpoints

Español rioplatense en la superficie HTTP (rutas y campos); inglés en el código
interno (su **ADR-004**). Esto es lo que llamamos:

### Personajes

| Método · Ruta | Qué hace | Entrada | Salida |
|---|---|---|---|
| `GET /personaje` | Genera un personaje **efímero** (no persiste). | query: `faccion?`, `rango?`, `semilla?`, `campos?` (CSV dot-paths), `tag?` (repetible, AND) | `PersonajeOut` (`slug=null`, `historial=[]`) |
| `GET /generar` | Igual que `/personaje` (pipeline completo de 8 fases). | mismos params | `PersonajeOut` efímero |
| `GET /personaje/{slug}` | Ficha vigente de un **canonizado**. | path `slug`; query `campos?` | `PersonajeOut` (`es_canon=true`) |
| `GET /personaje/{slug}/historial` | Solo el `historial[]`. | path `slug` | `list[HitoModel]` |
| `POST /personaje/{slug}/evento` | Registra un hito y aplica su efecto. | body `HitoIn` | `PersonajeOut` actualizado |
| `POST /canonizar` | Persiste un efímero; le asigna `slug`, congela `historia`. | body `PersonajeIn` (el efímero completo) | `PersonajeOut` canonizado |

Errores: `409` si la combinación de tags es inviable (dos facciones, tags de
campaña en creación, personaje `estado/ejemplo` inmutable). `404` si el slug no
existe. `POST /canonizar` es **idempotente** por `(semilla, faccion, rango)`.

### Meta / catálogos

| Método · Ruta | Qué hace | Salida |
|---|---|---|
| `GET /meta/facciones` | Facciones con lore. | `list[FaccionOut]` |
| `GET /meta/rangos` | Rangos con su `atributos_base`. | `list[RangoOut]` |
| `GET /meta/tipos_hito` | Tipos de hito sugeridos (lista abierta). | `list[str]` |
| `GET /meta/encuentro/nuevo` | Patente opaca de encuentro. | `EncuentroOut` `{patente}` |
| `GET /meta/{categoria}` | Catálogo de una categoría de tag. | `list[dict]` |
| `GET /meta/{categoria}/{subcategoria}` | Catálogo filtrado (ej. `/meta/equipo/arma`). | `list[dict]` |

Categorías curadas: `aspecto`, `habilidad`, `entrenamiento`, `equipo`, `rasgo`
(+ `faccion`/`subfaccion`). Cualquier otra devuelve `[]`.

---

## El JSON que recibimos — `PersonajeOut`

Esta es la forma que la app va a renderizar. Campos persistidos + **derivados
calculados en cada lectura** (marcados ▸).

```json
{
  "identidad": {
    "slug": null,                       // "A3BX7K2Z" si canonizado
    "nombre": "Marcos Páez",
    "sobrenombre": "El Turco",
    "especialidad": "Fusilero",         // nombre legible, no slug
    "genero": "masculino",
    "edad": 27
  },
  "atributos": { "cuerpo": 5, "mente": 4, "alma": 5 },   // escala 2..7
  "tags": [
    "faccion/fuerzas_armadas", "rango/sargento", "estado/disponible",
    "entrenamiento/infanteria", "aspecto/veterano", "equipo/arma/fusil_asalto",
    "habilidad/combate"
  ],
  "historia": "…(120–200 palabras; hoy es lorem ipsum, ver abajo)…",
  "historial": [],
  "metadatos": {
    "creado_en": "2026-06-27T12:00:00+00:00",
    "canonizado_en": null,
    "ultima_actualizacion": "2026-06-27T12:00:00+00:00"
  },
  "extras": { "semilla": "mi-seed-unico" },

  "es_canon": false,                    // ▸ canonizado_en != null
  "fatiga_max": 10,                     // ▸ cuerpo + alma
  "moral_max": 5,                       // ▸ alma
  "fza_aportada": 1,                    // ▸ 3=heroe, 2=lider, 1=default (desde especialidad/combate/*)
  "filiacion": { "faccion": "fuerzas_armadas", "rango": "sargento" }  // ▸ o null
}
```

Modelos auxiliares: `HitoModel` (`fecha`, `tipo`, `descripcion`, `actores[]`,
`encuentro`, `metadata`), `FaccionOut` (`slug`, `nombre`, `descripcion`),
`RangoOut` (`slug`, `nombre`, `faccion`, `atributos_base`, `mando_default`),
`EncuentroOut` (`patente`).

> **`historia` hoy es un stub** (lorem ipsum de 120–200 palabras): el
> `ProseProvider` real (LLM) está pendiente. La estructura es definitiva; el
> texto no. No diseñar la vista asumiendo prosa final aún.

---

## Cómo lo consume esta app (flujo típico)

```
1. Arranque        GET /meta/facciones  +  GET /meta/rangos     → poblar selección
2. Generar         GET /generar?faccion=…&rango=…[&semilla=…]   → ficha efímera
3. Canonizar       POST /canonizar  (body = el efímero)         → recibís el slug
4. Ver ficha       GET /personaje/{slug}                        → ficha vigente
5. Campaña         POST /personaje/{slug}/evento (HitoIn)       → ficha actualizada
6. Historial       GET /personaje/{slug}/historial
7. Catálogos tag   GET /meta/aspecto · /meta/equipo/arma · …    → nombres/efectos
```

**Poda con `campos=`** — pedimos solo lo que mostramos:

```
GET /personaje?campos=identidad.nombre,atributos,filiacion
```

---

## Cómo funciona por dentro (para entenderlo, no para reimplementarlo)

Pipeline de **8 fases** (`generation/planner.py`), handoff funcional fase a fase:

| Fase | Produce | Mecanismo |
|---|---|---|
| 1 · afiliación | faccion, subfaccion, rango, mando, especialidad | sorteo ponderado por `probabilidad`; override por param |
| 2 · identidad | genero, edad, nombre, sobrenombre | edad por gaussiana truncada; nombres de depósito YAML |
| 3 · atributos | cuerpo, mente, alma | **determinístico** desde `atributos_base` del rango |
| 4 · entrenamiento | entrenamiento, habilidad | base por rango + extra por subfacción; habilidad por especialidad |
| 5 · aspectos | aspecto, rasgo, estado | sorteo con cuota, honra `requires`/`excluye` |
| 6 · vínculos | lealtad | tags `lealtad/*` |
| 7 · equipo | arma + kit + vestidura | sorteo con compuertas temáticas |
| 8 · prosa | historia | `await prose.write(...)` — hoy stub |

**Azar portable y reproducible**: `PortableRng` = `SHA-256(semilla) → random`. La
misma `(semilla, faccion, rango)` produce el mismo personaje en cualquier
proceso. **Ports & adapters** (su ADR-006): el dominio no importa FastAPI ni la
DB; cambiar D1↔KV o stub↔LLM solo toca adapters.

---

## Convenciones clave (sus ADRs)

- **ADR-004 — inglés en código, español en contrato.** El código usa
  `Character`, `generate_ephemeral()`; la superficie HTTP usa `/personaje`,
  `identidad.slug`. El mapeo vive en `api/serializers.py`. *Nosotros consumimos
  el lado español.*
- **ADR-002 — TDD contract-first** contra `API.md` (261 tests verdes).
- **ADR-003 — `API.md` es read-only** (symlink al submódulo): el contrato no se
  edita desde la API, se respeta.
- **ADR-008 — recursos vía submódulo `syv-pj`**: los catálogos no se duplican.

---

## Su documentación (en el repo hermano)

`syv-pj-api` **no tiene** `docs/` propio. Su documentación son: `AGENTS.md`,
`README.md`, `FUTURE.md`, `CHANGELOG.md`, los 9 ADRs en `.claude/rules/`, y el
contrato heredado del submódulo (`vendor/syv-pj/API.md`, `MODEL.md`).
