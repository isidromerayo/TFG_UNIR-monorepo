# Proposal

## Why

React y Vue3 no tienen auditoría de accesibilidad automatizada, mientras que Angular ya dispone de pa11y (PR #254). El monorepo carece de un orquestador que ejecute y compare resultados entre las tres tecnologías. Esta brecha impide detectar regresiones de accesibilidad (WCAG 2.0 AA) en dos de los tres frontends y comparar el estado a11y entre implementaciones.

## What Changes

- Añadir `pa11y` + `pa11y-ci` + `pa11y-ci-reporter-html` (mismas versiones que Angular) como devDependencies en `TFG_UNIR-react` y `TFG_UNIR-vue3`.
- Crear `.pa11yci` en React (8 URLs, puerto 3000, `/` en lugar de `/home`) y Vue3 (8 URLs, puerto 5173, `/home`).
- Añadir script `"a11y": "pa11y-ci"` y `/reports` a `.gitignore` en ambos frontends.
- Corregir hallazgos esperables en React/Vue3 siguiendo el patrón de Angular: contraste del navbar (rgba ≥ .85), labels huérfanos/duplicados en registro/acceso, subrayado de enlaces inline.
- Crear `scripts/a11y-audit.sh` en el monorepo (advisory): arranca cada frontend, ejecuta pa11y, copia `reports/a11y/` a `reports/a11y/<proyecto>/`, muestra resumen comparativo, mata servidores. Nunca falla por hallazgos.
- Actualizar documentación (AGENTS.md, README) en los 3 frontends y en el monorepo.
- Añadir `skip_specs: true`: no hay cambios de comportamiento a nivel de spec, es tooling/docs.

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

(none)

## Impact

- Repos afectados: `TFG_UNIR-react`, `TFG_UNIR-vue3`, `TFG_UNIR-monorepo` (y referencia en `TFG_UNIR-angular`).
- Dependencias nuevas (dev): `pa11y ^10.0.0`, `pa11y-ci ^4.1.1`, `pa11y-ci-reporter-html ^8.1.1`.
- Requiere Chrome del sistema (`/usr/bin/google-chrome-stable`) y backend en `:8080` con seeds (`categoria/2`, `curso/12`).
- No modifica APIs ni comportamiento de la app; advisory (no gate de CI).
- Coordinación de submódulos: los PRs de React/Vue deben mergearse antes de actualizar punteros en el monorepo.
" path="/home/isidromerayo/projects/TFG_UNIR-multi/TFG_UNIR-monorepo/openspec/changes/add-pa11y-frontend-audits/proposal.md