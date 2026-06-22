# ADR-000 — Cómo usamos ADRs en este proyecto

**Status:** accepted · **Fecha:** 2026-06-21

---

## Cómo usamos ADRs en este proyecto

Un ADR documenta una decisión de arquitectura con impacto duradero. El objetivo
es que cualquier agente o desarrollador futuro entienda **por qué** el proyecto
llegó a su estado actual, sin tener que reconstruirlo desde el historial de
commits.

### Cuándo escribir un ADR

- Se elige una dependencia no trivial (y por qué esa y no otra).
- Se define un patrón que todos los features deben seguir.
- Se descarta una alternativa por razones que no son obvias.
- Se cambia una decisión anterior (el ADR nuevo referencia al que reemplaza).

No hace falta un ADR para cada línea de código — solo para decisiones con
impacto en la dirección del proyecto.

### Convención de nombres

```
adr-NNN-slug-descriptivo.md
```

- `NNN` es un número de tres dígitos con cero a la izquierda: `001`, `002`, etc.
- El slug es en minúsculas con guiones, sin tildes ni caracteres especiales.
- `adr-000` está reservado para este template.
- `adr-001` es el glosario de nomenclatura.
- `adr-002` es el registro de documentos canónicos obligatorios.

Ejemplos: `adr-003-state-management.md`, `adr-004-http-client-strategy.md`

### Ciclo de vida del campo `status`

| Valor | Significado |
|---|---|
| `propuesto` | En discusión, aún no adoptado |
| `aceptado` | Decisión tomada y vigente |
| `obsoleto` | Fue válido, ya no aplica |
| `reemplazado` | Sustituido por otro ADR (indicar cuál en el campo) |

### Dónde viven los ADRs

Los ADRs viven en `docs/adrs/` y se vinculan con symlinks en `.claude/rules/`
para que los agentes los carguen como contexto fuerte en cada sesión. Cuando
creés un ADR nuevo, agregá el symlink correspondiente en `.claude/rules/`.

---

## Plantilla

Copiá el bloque siguiente como punto de partida para un ADR nuevo.

```markdown
# ADR-NNN — [Título de la decisión]

**Status:** propuesto · **Fecha:** YYYY-MM-DD

---

## Contexto

Qué situación o problema llevó a tomar esta decisión. Incluí las restricciones
relevantes (técnicas, de ecosistema, de etapa del proyecto).

## Decisión

Qué se decidió hacer, en una oración directa. Luego el detalle.

## Alternativas consideradas

| Opción | Por qué se descartó |
|---|---|
| Alternativa A | ... |
| Alternativa B | ... |

## Consecuencias

Qué implica adoptar esta decisión: qué se gana, qué se resigna, qué hay que
tener en cuenta en el futuro.

## Referencias

- Links a issues, PRs, docs externas o ADRs relacionados.
```
