# `syv-docs` — el universo (la cabecera de todo)

> **Repo hermano:** `../../../syv-docs/` · Vault de Obsidian · **la SSOT del lore.**
> **Acceso:** por la MCP `markdown-vault-syv` (lectura/búsqueda primero). **Para
> nosotros es de SOLO LECTURA** — no editamos el canon.
> **Foto tomada:** 2026-06-27 (211 documentos, 33 carpetas, 944 enlaces).

---

## Por qué es el más importante

`syv-docs` es **el universo**: de acá sale **la estética y el entendimiento del
lore**. Todo lo demás —el dominio (`syv-pj`), el motor (`syv-pj-api`), el design
system, esta interfaz— orbita alrededor de este corpus. Cuando necesitamos
**expresar algo** (un nombre, un texto, un tono, una imagen, el clima de una
pantalla), la fuente de las buenas ideas está acá. No inventamos universo:
lo **leemos** y lo mostramos con fidelidad.

> *"Un mundo que ardió y se rearmó con cruces y fusiles. Una Argentina del siglo
> XXII donde la fe católica rige con ley marcial, la tecnología es herejía y la
> humedad lo pudre todo."* — `inicio.md`

---

## De qué se trata el mundo

Argentina, siglo XXII, **post-diluvio**, bajo una **teocracia militar**. La fe
católica gobierna con ley marcial; la tecnología es **herejía** (el *Anatema
Mecánico*); la lluvia y la humedad lo pudren todo. La ciudad de referencia es
**Dársena**, y debajo, las **Tuberías** (una comunidad subacuática). La palabra
escrita es a la vez herejía y salvación.

Es un mundo de **incienso barato y grasa rancia**, de liturgia mezclada con
cables, de inquisidores y herejes, de agua negra.

---

## El tono y la estética (lo que minamos para expresar)

El canon tiene una **voz** muy definida — y esa voz es nuestra guía cuando
escribimos copy o componemos una vista:

- **Elipsis emocional:** se muestran síntomas físicos en lugar de nombrar
  sentimientos.
- **Sincretismo léxico:** liturgia + tecnología en la misma frase ("servidores
  clandestinos", "confesiones bajo tortura", "el anatema contra la máquina").
- **Atmósfera fáctica:** se construye con datos sensoriales concretos (olores,
  texturas, humedad), no con adjetivos vagos.
- **Castellano rioplatense, grave y literario**, tipo dossier/archivista. Sin
  emojis.

> Esta voz es **la misma** que el design system "Diseño Verde" encarna en lo
> visual (verde mate militar, terminal clandestino, austeridad). Lore y estética
> son dos caras de lo mismo — ver [syv-design-system.md](./syv-design-system.md).

---

## Cómo está organizado (mapa del corpus)

Carpetas raíz numeradas (de la guía a la diégesis):

| Carpeta | Qué contiene |
|---|---|
| `0_proyecto/` | Cómo se construye el mundo: `guias-para-colaboradores/` (manual, guía de metadatos), `deuda-tecnica/`. |
| `1_trasfondo/` | El fundamento: `facciones/` (`iglesia-de-darsena/`, `fuerzas-armadas/`, `union/`, `facciones-menores/`), `credos/`, `codex/`, `hitos/`. |
| `2_atlas/` | El mundo físico: `ciudades/` (**darsena**, cordoba, mendoza, san-luis, fuerte-san-martin), `climas/`, `tecnologia-y-ciencia/`. |
| `3_personajes/` | La gente: `principales/`, `secundarios/`. |
| `4_diegesis/` | Ficción dentro de la ficción: `relatos/`, `cartas/`, `cronicas/`. |
| `5_aventuras/` | Módulos jugables: `poseidos/`. |
| `6_media/` | Material audiovisual / assets. |

Punto de entrada: `inicio.md`. Para colaborar: `0_proyecto/guias-para-colaboradores/manual-del-colaborador.md`.

---

## Cómo se accede (y la regla de oro)

El corpus se opera por su **MCP propia, `markdown-vault-syv`** — es la SSOT de
búsqueda y lectura:

- Búsqueda/lectura: `mcp__markdown-vault-syv__search` (con `mode="hybrid"`),
  `read`, `list_documents`, `get_context`, `get_backlinks`, `get_outlinks`.
- **Para esta app, el corpus es de solo lectura.** No editamos el lore; lo
  consultamos. (La escritura del corpus existe, pero pertenece al trabajo sobre
  `syv-docs`, no a esta interfaz.)

Convenciones del vault (por si leemos su frontmatter): campos indexados
`entidad`, `alcance`, `estado`, `tags`, `region`, `fecha`; las relaciones son
**wikilinks** `[[slug]]`; `entidad` es un catálogo cerrado (`personaje`,
`faccion`, `ubicacion`, `concepto`, `credo`, `hito`, `relato`, `guia`, `objeto`,
`vehiculo`); `alcance: secreto` marca **spoilers** (no exponer).

---

## Qué se consigue de este repo

Cuando esta interfaz necesita **expresar** algo, acá está la materia prima:

1. **Nombres y entidades reales** — personajes, facciones, lugares, conceptos
   canónicos para poblar pantallas con verdad (no placeholders genéricos).
2. **El tono y la voz** — para escribir copy, microcopy, vacíos y mensajes con
   la cadencia del universo (ya lo hicimos: el texto del frontpage salió de
   `inicio.md`).
3. **La estética** — atmósfera, paleta sensorial, identidad visual; la base
   conceptual del design system.
4. **Descripciones de las facciones y lugares** — que el motor (`syv-pj-api`)
   referencia por slug; acá está su forma narrativa completa.

> Relación con el dominio: los `tags` de un personaje (`faccion/iglesia`,
> `lealtad/...`) y los campos `doc:` de los catálogos de `syv-pj` **apuntan a
> este vault**. El lore vive acá; el dominio lo referencia, no lo duplica.
