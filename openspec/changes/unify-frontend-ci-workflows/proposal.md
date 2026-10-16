# Proposal

## Why

El change `unify-github-actions` alineó las **acciones y sus versiones** (SHA + comentario `# vX.Y.Z`) en los tres frontends, pero dejó fuera la **estructura y la semántica de los workflows**. Hoy angular, react y vue3 siguen divergiendo en el contenido de sus pipelines: angular tenía el job `SonarQube` en `tests.yml` con guarda de `SONAR_TOKEN` mientras vue3 lo tenía sin guarda en `node.js.yml` (lo que hacía **fallar el CI de cada PR de Dependabot**, porque los PRs de Dependabot no reciben secretos); `node.js.yml` tenía jobs distintos (angular `lint`+`build`; react/vue3 un único `build` con tests y auditorías duplicadas); `security.yml` difería en el gate de vulnerabilidades; y `dependabot.yml` no compartía esquema. Esas diferencias sesgan la comparación entre frameworks que motiva el TFG. Ahora es el momento porque la capability `ci/github-actions` ya existe y las versiones de acciones ya están alineadas.

## What Changes

- **Baseline angular**: se adopta angular como referencia canónica (gate de producción duro en `security.yml` y job `SonarQube` en `tests.yml` con guarda `if: env.SONAR_TOKEN != ''`).
- **`node.js.yml` homogéneo**: los tres frontends usan jobs `lint` y `build`; se eliminan de `build` los pasos de test, Cypress y auditoría que ya viven en `tests.yml`/`security.yml`.
- **SonarQube con guarda en los tres**: el job se mueve a `tests.yml` en vue3 y queda idéntico en angular/react; los PRs de Dependabot pasan a `skipped`, no a `failure`.
- **`security.yml` idéntico**: el gate de producción `pnpm audit --prod` respeta `pnpm.auditConfig.ignoreCves` (usa el exit code) y tolera el paquete aceptado `braces` (sin parche upstream), fallando ante cualquier otra vulnerabilidad de producción.
- **`dependabot.yml` con esquema común**: `weekly` (lunes 09:00 Europe/Madrid), `versioning-strategy: increase`, `labels` y `commit-message` en ambos ecosistemas (vue3 carecía de labels/prefix en `github-actions`).
- **CodeQL**: mismo `cron` de schedule en los tres.

Fuera de alcance: código de aplicación, runners autogestionados y la lógica funcional de los tests (Angular mantiene su limitación conocida de Cypress component en Angular 21).

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `ci/github-actions`: el requisito de "Equivalencia de CI entre los tres frontends" se amplía desde "mismo conjunto de acciones y versiones" a "workflows equivalentes en estructura y semántica" (mismos jobs, mismo gate de seguridad y mismo esquema de Dependabot).

## Impact

- **Repos afectados (3)**: `TFG_UNIR-angular`, `TFG_UNIR-react`, `TFG_UNIR-vue3`. Son repos independientes: cada cambio va en su propio PR y luego el monorepo actualiza los punteros de submódulo (automatizado por `update-submodules.yml`).
- **Ficheros**: `node.js.yml`, `tests.yml`, `security.yml`, `codeql.yml` y `dependabot.yml` de cada frontend, más `pnpm-workspace.yaml` en vue3 (override de `source-map-js`, ya resuelto en su `main`).
- **Riesgos**: el gate de producción duro puede destapar vulnerabilidades antes toleradas; se verificó que angular/react/vue3 quedan en verde y que el único hallazgo de producción en react (`braces`) es el riesgo aceptado ya documentado. Angular mantiene su limitación de Cypress component (Angular 21).
- **Sin impacto** en código de aplicación, datos ni APIs.
