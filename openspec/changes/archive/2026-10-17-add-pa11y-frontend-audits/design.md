# Design

## Context

Angular ya implementó pa11y (PR #254) con `.pa11yci` (WCAG2AA, runners htmlcs+axe, Chrome del sistema, reporters cli+json+html en `reports/a11y/`). React y Vue3 carecen de equivalente. El monorepo tiene `scripts/test-all.sh` como patrón de orquestación a replicar. Restricciones: pnpm 10, Node 22, Chrome en `/usr/bin/google-chrome-stable`, backend en `:8080`.

## Goals / Non-Goals

**Goals:**
- Paridad de infraestructura a11y entre los 3 frontends.
- Orquestador advisory en el monorepo con resumen comparativo.
- Corregir hallazgos reales (no solo instalar tooling).

**Non-Goals:**
- No añadir pa11y como gate de CI (advisory, como Angular).
- No auditar rutas autenticadas (`mis-cursos`, `mis-datos`).
- No modificar la app más allá de fixes a11y necesarios.

## Decisions

- **Comandos de arranque por proyecto**: Angular `pnpm start` (:4200), React `pnpm dev` (:3000), Vue3 `pnpm dev` (:5173). El orquestador mapea explícitamente en lugar de un comando genérico.
- **Versiones alineadas** con Angular (`pa11y ^10.0.0`, `pa11y-ci ^4.1.1`, `pa11y-ci-reporter-html ^8.1.1`) para consistencia.
- **Chrome del sistema** vía `chromeLaunchConfig.executablePath` (puppeteer postinstall bloqueado por `onlyBuiltDependencies`).
- **`levelCapWhenNeedsReview: "warning"`** para que los needs-review no cuenten como error (decisión de Angular).
- **Preflight de backend** antes de auditar; abortar si `:8080` no responde.
- **Trap de limpieza** para matar servidores aunque se interrumpa.
- **Parseo de `report.json`** (campos `errors`, `passes`, `total`) para el resumen comparativo en lugar de parsear stdout.
- **Secuencia de PRs**: React → Vue3 → monorepo (actualizar punteros de submódulos al final).

## Risks / Trade-offs

- [Chrome path en CI] → a11y es advisory y no corre en CI; aceptable. Si se quiere CI, usar variable de entorno.
- [Next.js 404] → pa11y audita HTML renderizado de `/ruta-inexistente`; verificar `<title>` y landmarks.
- [Lockfile] → aplicar bumps con `pnpm up`, no hand-edit, para no romper `--frozen-lockfile`.
- [Submódulos] → orquestador fallará si se añade antes de que existan scripts `a11y`; mitigado por la secuencia de PRs.
- [Dev servers lentos] → timeout de 120 s con polling por puerto.
" path="/home/isidromerayo/projects/TFG_UNIR-multi/TFG_UNIR-monorepo/openspec/changes/add-pa11y-frontend-audits/design.md