# Proposal

## Why

Los cinco repositorios que forman la plataforma (monorepo + backend + angular + react + vue3) han divergido en cómo fijan y mantienen sus GitHub Actions: conviven tres estilos de pinning (monorepo y backend con tags mayores flotantes; angular/react/vue3 con SHA de commit) y falta el ecosistema `github-actions` de Dependabot en backend y vue3. Eso es exactamente la causa de que vue3 (checkout v4.4.0, cache v4.3.0, upload-artifact v4.6.2, download-artifact v4.3.0, pnpm/action-setup v4, sonarqube-scan v6.0.0) y backend (@v4) se queden atrás mientras angular y react están al día. Además de la deriva, los tags flotantes son mutables (riesgo de cadena de suministro, como el caso Trivy GHSA-69fq-xp46-6x23) y la CI desigual entre los tres frontends contamina la comparación del TFG. Ahora es el momento porque la capability `ci/github-actions` ya existe y los workflows del monorepo acaban de estandarizarse.

## What Changes

- **Estándar único de pinning**: toda referencia `uses:` a una acción de terceros en los workflows de los 5 repos se fija a un SHA de commit de 40 caracteres con un comentario de versión `# vX.Y.Z` en la misma línea.
- **Puesta al día de los rezagados**: se actualizan las acciones desfasadas de vue3 y backend a las mayores actuales antes o junto con el re-pinning (checkout v7, cache v6, upload-artifact v7, download-artifact v8, pnpm/action-setup v6, github-script v9, sonarqube-scan v8, osv-scanner v2.6, codeql-action).
- **Cobertura homogénea de Dependabot**: se añade el ecosistema `github-actions` a `backend/.github/dependabot.yml` y `vue3/.github/dependabot.yml` (angular, react y el monorepo ya lo tienen); cada repo mantiene actualizados SHA + comentario.
- **Equivalencia entre frontends**: angular, react y vue3 usan el mismo conjunto de acciones y versiones alineadas para que la comparación sea justa.
- **Homogeneidad de runtime**: el `ci-simple.yml` del monorepo pasa de JDK 17 a JDK 21 (backend compila con 21); `node-version: 22.x` y pnpm `10.17.1` declarados de forma consistente en los tres frontends.
- **Hygiene**: retirar los restos de plantilla de los tres `codeql.yml` (bloque comentado `setup-example`) y corregir la cabecera obsoleta y el nombre del workflow de notificación del backend (`notify-monorepo-workflow-content.yml` → `notify-monorepo.yml`).

Fuera de alcance: código de aplicación, dependencias de las apps (npm/maven), runners autogestionados y la lógica de los jobs (no se cambia qué se ejecuta, solo cómo se referencia y con qué versión).

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `ci/github-actions`: el requisito de versiones de acciones pasa de "mayor más reciente" a "SHA inmutable + comentario de versión"; el requisito de Dependabot se amplía a todos los repos con workflows; se añaden requisitos de homogeneidad de runtime y de equivalencia de acciones entre los tres frontends.

## Impact

- **Repos afectados (5)**: `TFG_UNIR-monorepo`, `TFG_UNIR-backend`, `TFG_UNIR-angular`, `TFG_UNIR-react`, `TFG_UNIR-vue3`. Los submódulos son repos independientes: sus cambios van en sus propios PRs y luego se actualizan los punteros de submódulo en el monorepo.
- **Ficheros**: 15 workflows (2 del monorepo, 4 en backend, 4 en angular, 4 en react, 4 en vue3 — menos 1 por solape) y sus `dependabot.yml`.
- **Riesgos**: los bumps de mayor pueden romper workflows (Node 24, inputs obsoletos); se verifica con `actionlint` y con los runs reales de cada repo antes de fusionar. El re-pinning a SHA toca muchos ficheros y genera diffs grandes, mitigado porque el comentario `# vX.Y.Z` mantiene la legibilidad.
- **Sin impacto** en código de aplicación, datos ni APIs.
