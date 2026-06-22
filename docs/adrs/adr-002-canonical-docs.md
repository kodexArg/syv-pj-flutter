# ADR-002 — Documentos canónicos obligatorios

**Status:** accepted · **Fecha:** 2026-06-21

---

## Contexto

El repo `syv-pj-flutter` tiene documentación dispersa que define la
arquitectura, los requisitos y el design system. Sin un registro explícito de
qué archivos son la fuente de verdad, cada agente o desarrollador puede partir
de información desactualizada o redundante.

## Decisión

Los archivos listados a continuación son los **documentos canónicos
obligatorios** de este repo. Son lectura obligatoria antes de cualquier tarea
de implementación o modificación significativa. Cada uno es la SSOT del área
que cubre; ante conflicto entre estos documentos y el código, el documento
manda (el código se corrige, no el documento).

## Documentos canónicos

| Documento | Qué cubre |
|---|---|
| [docs/ARCHITECTURE.md](../ARCHITECTURE.md) | Estructura del repo, capas, decisiones de layout, cómo se organiza `packages/syv_ui` y `lib/`. |
| [docs/REQUIREMENTS.md](../REQUIREMENTS.md) | Requisitos funcionales y no funcionales del visualizador; criterios de aceptación de cada feature. |
| [docs/DESIGN-SYSTEM.md](../DESIGN-SYSTEM.md) | Guía de uso del design system "Diseño Verde": tokens, componentes, patrones de composición, relación con `syv-design-system`. |
| [docs/adrs/adr-001-glosario.md](./adr-001-glosario.md) | Nomenclatura canónica: términos de dominio SyV, identificadores en código y términos del design system. |

## Regla

- **Antes de nombrar algo nuevo**, consultá [adr-001-glosario.md](./adr-001-glosario.md).
- **Antes de implementar una feature**, verificá [docs/REQUIREMENTS.md](../REQUIREMENTS.md).
- **Antes de tocar la arquitectura o el layout del repo**, leé [docs/ARCHITECTURE.md](../ARCHITECTURE.md).
- **Antes de agregar o modificar un componente del DS**, leé [docs/DESIGN-SYSTEM.md](../DESIGN-SYSTEM.md).

Estos documentos se actualizan con cada decisión significativa; si encontrás
una discrepancia entre lo documentado y el estado real del código, actualizá
el documento (no lo ignores).

## Consecuencias

- Los agentes que operen en este repo cargan estos ADRs desde `.claude/rules/`
  como contexto fuerte; `adr-002` los referencia explícitamente para que
  ningún agente arranque sin saber dónde están los SSOT.
- Si alguno de estos archivos aún no existe al momento de leer este ADR, está
  siendo authored por un compañero — no lo omitas, espera o consultá el estado
  actual.

## Referencias

- [ADR-001 — Glosario](./adr-001-glosario.md)
- [ADR-000 — Cómo usamos ADRs](./adr-000-template.md)
- [README de ADRs](./README.md)
