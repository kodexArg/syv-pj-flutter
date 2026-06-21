# ADRs — Registro de decisiones de arquitectura

Los ADRs (Architecture Decision Records) documentan las decisiones que afectan
la estructura y dirección del proyecto. Son la memoria del porqué, no solo del
qué.

> **Estado actual:** ningún ADR registrado. Este directorio está scaffoldeado
> y listo para el primer ADR cuando el usuario lo apruebe.

---

## Para qué sirven

Cada vez que se toma una decisión de arquitectura con impacto duradero
(elección de dependencia, patrón de estado, estrategia de integración con la
API, convención de estructura), se registra aquí. El objetivo es que cualquier
agente o desarrollador futuro pueda entender **por qué** el proyecto llegó a
su estado actual, sin tener que reconstruirlo desde git log.

---

## Formato

Nombre de archivo: `YYYYMMDD-slug-descriptivo.md`

Ejemplos: `20260621-window-manager-choice.md`, `20260701-http-client-strategy.md`

Ciclo de vida del campo `status`:

| Valor | Significado |
|---|---|
| `propuesto` | En discusión, aún no adoptado |
| `aceptado` | Decisión tomada y vigente |
| `obsoleto` | Fue válido, ya no aplica |
| `reemplazado` | Sustituido por otro ADR (indicar cuál) |

Usar la plantilla en [0000-template.md](0000-template.md).

---

## Cuándo escribir un ADR

- Se elige una dependencia no trivial (y por qué esa y no otra).
- Se define un patrón que todos los features deben seguir.
- Se descarta una alternativa por razones que no son obvias.
- Se cambia una decisión anterior (el ADR nuevo referencia al que reemplaza).

No hace falta un ADR para cada línea de código — solo para decisiones con
impacto en la dirección del proyecto.
