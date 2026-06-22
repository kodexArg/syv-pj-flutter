# ADRs — Registro de decisiones de arquitectura

Los ADRs (Architecture Decision Records) documentan las decisiones que afectan
la estructura y dirección del proyecto. Son la memoria del porqué, no solo del
qué.

---

## Para qué sirven

Cada vez que se toma una decisión de arquitectura con impacto duradero
(elección de dependencia, patrón de estado, estrategia de integración con la
API, convención de estructura), se registra aquí. El objetivo es que cualquier
agente o desarrollador futuro pueda entender **por qué** el proyecto llegó a
su estado actual, sin tener que reconstruirlo desde git log.

---

## Formato

Nombre de archivo: `adr-NNN-slug-descriptivo.md` (tres dígitos, cero a la izquierda)

Ejemplos: `adr-003-window-manager-choice.md`, `adr-004-http-client-strategy.md`

Ciclo de vida del campo `status`:

| Valor | Significado |
|---|---|
| `propuesto` | En discusión, aún no adoptado |
| `aceptado` | Decisión tomada y vigente |
| `obsoleto` | Fue válido, ya no aplica |
| `reemplazado` | Sustituido por otro ADR (indicar cuál) |

Usar la plantilla en [adr-000-template.md](adr-000-template.md).

---

## Cuándo escribir un ADR

- Se elige una dependencia no trivial (y por qué esa y no otra).
- Se define un patrón que todos los features deben seguir.
- Se descarta una alternativa por razones que no son obvias.
- Se cambia una decisión anterior (el ADR nuevo referencia al que reemplaza).

No hace falta un ADR para cada línea de código — solo para decisiones con
impacto en la dirección del proyecto.

---

## ADRs registrados

| ADR | Título | Status |
|---|---|---|
| [adr-000](adr-000-template.md) | Cómo usamos ADRs en este proyecto (+ plantilla) | aceptado |
| [adr-001](adr-001-glosario.md) | Glosario: cómo nombramos cada cosa | aceptado |
| [adr-002](adr-002-canonical-docs.md) | Documentos canónicos obligatorios | aceptado |
