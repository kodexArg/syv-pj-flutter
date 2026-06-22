# Changelog

## [Unreleased]

- group: living-documentation-baseline
  priority: high
  commit: pending
  changes:
    - docs(arch): ARCHITECTURE.md canonical — mobile-first target, FVM-pinned SDK, syv_ui presentation layer
    - docs(reqs): REQUIREMENTS.md — functional + non-functional standing requirements
    - docs(design): DESIGN-SYSTEM.md — catalog of 10 Syv* components with implementation links
    - docs(adr): adr-001-glosario.md — domain↔code naming glossary with verified vault links to syv-docs
    - docs(adrs): symlinks in .claude/rules/ point to docs/adrs/ for agent context
    - docs(cleanup): deleted stale docs/architecture.md, docs/design-system.md (superseded by uppercase canonical versions)

- group: syv-design-system-integration
  priority: high
  commit: pending
  changes:
    - feat(ui): local Flutter package `packages/syv_ui/` with design tokens and components
    - feat(design): DTCG tokens from ../syv-design-system (colors, typography, spacing)
    - feat(theme): syvTheme() factory and SyvGlow background provider
    - feat(components): SyvLogo, SyvButton, SyvChip, SyvCard, SyvInput, SyvKicker, SyvSwitch, SyvStat
    - feat(icons): 3 custom stat-icon painters (attack, defense, speed)
    - feat(fonts): bundled OFL fonts (Nunito, DM Mono, Saira Stencil One) at app level
    - feat(showcase): lib/features/showcase/showcase_view.dart demo of all components
    - feat(build): linux desktop target re-enabled and verified
    - chore(quality): flutter analyze clean, flutter test passing, flutter build linux passing

- group: flutter-linux-desktop-bootstrap
  priority: high
  commit: 7a89e97
  changes:
    - feat(app): minimal self-contained Flutter Linux desktop app with FVM pinned SDK
    - feat(ui): 390x844 phone-portrait window via window_manager 0.5.1
    - feat(ui): "Hola, mundo!" splash and exit button on home screen
    - feat(build): Linux desktop toolchain configured; org com.kodexarg
    - feat(test): smoke test scaffold in test/

- group: stage-1-documentation
  priority: normal
  commit: ae4b42e
  changes:
    - docs: PRD.md with 3-stage roadmap (Stage 1 bootstrap, Stage 2 Python harness, Stage 3 API integration)
    - docs: AGENTS.md as SSOT for local conventions
    - docs: README.md project overview and quick-start
    - docs: architecture.md design rationale and stack choices
    - docs: ADR scaffold (docs/adrs/README.md + 0000-template.md)
