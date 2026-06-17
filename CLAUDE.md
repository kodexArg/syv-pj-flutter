# AGENTS.md — `syv-pj-flutter`

> Parte del ecosistema *Subordinación y Valor* (SyV). Antes de tocar nada, leé
> el `AGENTS.md` de la raíz (`~/Dev/SyV/`) y el de `../syv-pj/`.

## Qué es esto

`syv-pj-flutter` es un **visualizador de personajes**. Nada más. Toma un
personaje del universo SyV y lo **muestra**: lee, presenta, navega fichas. No
crea lógica de dominio, no valida reglas, no genera personajes.

- **Solo visualiza.** Es una capa de presentación.
- **No tiene backend.** Toda la lógica vive afuera.

## De dónde sale lo que muestra

| Fuente | Rol | Relación |
|---|---|---|
| [`../syv-pj/`](../syv-pj/) | Define **qué es** un personaje (contratos, catálogos, reglas). | Base conceptual — este visualizador refleja esas entidades. |
| [`../syv-pj-api/`](../syv-pj-api/) | El **motor**: clasifica, genera, valida y entrega personajes vía API. | **Esta app consume esa API.** No reimplementa nada de su lógica. |
| [`../syv-design-system/`](../syv-design-system/) | El **sistema de diseño**: la forma visual (tokens, tipografía, componentes). | Esta app **usa** ese design system para renderizar. |

## Principio

Agnóstico al dominio en la cabeza, Flutter en las manos. Pensamos en
**entidades**, **vistas** y **contratos** (no en "modelos" ni "widgets" como
sustantivos de negocio). El framework es el cómo final; la idea nace agnóstica.

- **Stack:** Flutter (Dart).
- **Sin backend propio:** todo dato viene de `syv-pj-api`.
- **Estética:** la define `syv-design-system`.
