# El ecosistema SyV, visto desde esta app

> Esta carpeta es la **memoria de los proyectos hermanos**. La mantenemos para
> no perder de vista qué construimos *a nuestras espaldas* mientras crecemos.
> Cada archivo describe un proyecto vecino: **qué tiene** y **qué se consigue de
> él**. No duplica su documentación — la resume desde el lugar que nos importa:
> el de la interfaz que va a mostrar todo eso.

---

## Quiénes somos en este mapa

`syv-pj-flutter` es **la cara del universo**. Nuestro nombre completo cuenta la
misión entera:

```
SUBORDINACIÓN Y VALOR   →   PERSONAJES   →   FLUTTER
   (el universo / lore)      (el dominio)     (la interfaz)
      syv-docs                 syv-pj           esta app
```

Empezamos como un visualizador de personajes, pero la dirección es más grande:
**nos convertimos en la interfaz de todos los proyectos que se generan alrededor
de la SSOT.** Hoy mostramos fichas; mañana, el simulador de batallas, y lo que
venga. La regla que no cambia: **cada vez que creamos algo, lo hacemos con el
lore en la cabeza.** El framework es el cómo; el universo es el qué.

---

## El mapa, de la idea a la pantalla

```
  syv-docs ───────────────┐  El universo (SSOT del lore).
  (lore, vault Obsidian)   │  Lugares, facciones, personajes, relatos.
                           │
  syv-pj ─────────────────┤  El DOMINIO del personaje (spec + catálogos).
  (spec en Markdown)       │  Qué ES una ficha: campos, atributos, tags, reglas.
                           │  Referencia el lore por slug; no lo duplica.
                           │
  syv-pj-api ─────────────┤  El MOTOR (FastAPI + D1 en Cloudflare).
  (backend Python)         │  Genera, clasifica, valida, canoniza y SIRVE fichas.
                           │  Consume syv-pj como submódulo (vendor/).
                           │
  syv-design-system ──────┤  El LENGUAJE VISUAL (tokens DTCG → Flutter/CSS).
  (tokens de diseño)       │  Lo encarnamos en packages/syv_ui ("Diseño Verde").
                           │
  syv-pj-flutter ─────────┘  NOSOTROS. La INTERFAZ.
  (esta app, Flutter)         Pide fichas al motor, las viste con el DS,
                              y las muestra con el lore en mente.
```

---

## Los documentos de esta carpeta

Los cuatro vecinos, en orden de "de dónde nace todo" hacia "cómo se ve":

| Documento | Proyecto hermano | Qué cubre |
|---|---|---|
| [syv-docs.md](./syv-docs.md) | `../../../syv-docs/` | **El universo (lo más importante).** El lore y la estética: nombres, lugares, facciones, tono y voz. De acá sacamos las ideas cuando necesitamos expresar algo. SOLO LECTURA. |
| [syv-pj.md](./syv-pj.md) | [`../../../syv-pj/`](../../../syv-pj/) | El dominio: qué es un personaje, sus catálogos y reglas. La base conceptual de lo que mostramos. |
| [syv-pj-api.md](./syv-pj-api.md) | [`../../../syv-pj-api/`](../../../syv-pj-api/) | El motor y su **API**: los endpoints que consumimos y el JSON que recibimos. Nuestra amiga: le pedimos lo que necesitamos. |
| [syv-design-system.md](./syv-design-system.md) | `../../../syv-design-system/` | El lenguaje visual ("Diseño Verde"). El **upstream** de nuestro [`packages/syv_ui`](../../packages/syv_ui/); guía de uso local en [DESIGN-SYSTEM.md](../DESIGN-SYSTEM.md). |

---

## Nuestra posición (lo que nos deja tranquilos)

Saber dónde estamos parados nos libera para hacer mejor lo nuestro — **mostrar**:

1. **No hacemos código de negocio: lo mostramos.** La lógica de dominio no es
   nuestra responsabilidad. Nuestra única misión es presentar bien.
2. **Tenemos una API amiga con toda la lógica.** `syv-pj-api` ya genera, valida y
   sirve los personajes; le **pedimos lo que necesitamos** y renderizamos la
   respuesta. No reimplementamos nada.
3. **Tenemos un universo lleno de buenas ideas.** Cuando hay que **expresar**
   algo —un texto, un nombre, un clima, una pantalla vacía— la fuente está en
   `syv-docs`. Nunca partimos de un placeholder genérico si el canon tiene la
   palabra justa.

---

## Cómo usar esta carpeta

- **Antes de inventar un contrato, un catálogo o un nombre de campo**, mirá
  [syv-pj.md](./syv-pj.md) y [syv-pj-api.md](./syv-pj-api.md). El dominio ya está
  definido afuera; nosotros lo reflejamos, no lo reescribimos.
- **Antes de integrar datos reales**, [syv-pj-api.md](./syv-pj-api.md) tiene la
  tabla de endpoints y la forma exacta del JSON de personaje.
- Estos resúmenes son una **foto** (2026-06-27). La verdad viva está en los repos
  hermanos; si algo no cuadra, manda el repo y se actualiza esta foto.
