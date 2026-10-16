# Design

## Context

El change previo `unify-github-actions` (2026-10-04) fijó el **estándar de pinning** (SHA + `# vX.Y.Z`), puso al día a los rezagados, añadió cobertura `github-actions` a Dependabot y homogeneizó runtimes. Sin embargo, su `design.md` marcaba explícitamente como **non-goal** unificar el *contenido* de los jobs ("cada frontend mantiene sus comandos específicos; solo se alinean las acciones y versiones"). El resultado es que las acciones coinciden, pero los workflows no:

- **SonarQube**: angular/react → job en `tests.yml` con `if: env.SONAR_TOKEN != ''`; vue3 → paso sin guarda en `node.js.yml`. Los PRs de Dependabot (sin secretos) fallaban en vue3 con `sonar-scanner exit 3`.
- **`node.js.yml`**: angular → jobs `lint` + `build`; react/vue3 → un único job `build` con tests, Cypress y auditoría que ya existen en `tests.yml`/`security.yml`.
- **`security.yml`**: angular → gate duro `pnpm audit --prod` + lista `ACCEPTED`; react/vue3 → auditoría no bloqueante y comparación con `npm audit`.
- **`dependabot.yml`**: vue3 en `daily` y sin `labels`/`commit-message` en `github-actions`; los grupos npm diferían de forma.
- **`codeql.yml`**: tres `cron` distintos.

## Goals / Non-Goals

**Goals:**
- Que `security.yml` sea idéntico en los tres frontends y que el gate de producción sea duro.
- Que el job de SonarQube viva en `tests.yml` protegido por `SONAR_TOKEN` en los tres.
- Que `node.js.yml` tenga los mismos jobs (`lint` + `build`) sin duplicar lo que hay en otros workflows.
- Que `dependabot.yml` comparta esquema (schedule, labels, commit-message, límites).

**Non-Goals:**
- No unificar el *contenido funcional* de los tests (Angular mantiene su limitación de Cypress component en Angular 21; cada framework conserva sus comandos `lint`/`build`/`test`).
- No tocar dependencias npm salvo lo imprescindible para que el gate pase (override `source-map-js` en vue3, ya resuelto en su `main`).
- No cambiar los triggers (`on:`) de los workflows.

## Decisions

1. **Baseline angular.** Angular ya implementa el gate duro y el SonarQube guardado, y su `main` estaba en verde con ese patrón; se toma como referencia y se replica en react/vue3.
2. **Gate por exit code.** El gate de producción usa el exit code de `pnpm audit --prod` en lugar de sumar `.metadata.vulnerabilities`, porque el JSON sigue listando como vulnerables los avisos ignorados vía `pnpm.auditConfig.ignoreCves` (react ignora dos CVEs) y los alcanzados por el paquete aceptado `braces`.
3. **Lista `ACCEPTED`.** Se aplica en los tres la misma lista que angular ya documentaba (`braces`, sin parche upstream, ver `SECURITY_AUDIT_ANALYSIS.md`); cualquier otra vulnerabilidad de producción falla el job. En react `braces` aparece clasificado como producción porque `eslint-config-next` está en `dependencies`.
4. **SonarQube en `tests.yml`.** Se adopta la ubicación de angular/react (con `needs: [unit-tests]` y descarga del artefacto de cobertura) y se elimina el paso de `node.js.yml` en vue3; al llevar `if: env.SONAR_TOKEN != ''`, los PRs de Dependabot quedan `skipped` en vez de `failure`.
5. **`node.js.yml` = `lint` + `build`.** Se eliminan los pasos duplicados; los tests, la cobertura y la auditoría permanecen en `tests.yml`/`security.yml`. Vue3 conserva `type-check` dentro de `build` (vite no tipa en el build).
6. **`dependabot.yml`: mismo esquema, grupos por framework.** Se unifican schedule/labels/commit-message/límites; los grupos npm específicos de cada framework se conservan porque no sesgan la comparación.
7. **Verificación sin acción humana previa**: `actionlint` (contenedor/binario fijado) sobre los 12 workflows, `yaml.safe_load` sobre cada fichero y confirmación de que el conjunto de `uses:` coincide en los tres.

## Risks / Trade-offs

- [El gate duro falla PRs existentes] → Se verificó primero en cada repo: angular ya pasaba; vue3 se destapó por `source-map-js` (resuelto con override, `main` ya limpio); react por `braces` clasificado como producción (cubierto por `ACCEPTED`).
- [Mover SonarQube a `tests.yml` cambia el nombre del check] → Se documenta; los checks de Sonar pasan a depender de `tests.yml`, igual que en angular/react.
- [Eliminar pasos de `node.js.yml` podría ocultar fallos] → Los pasos eliminados ya se ejecutan en `tests.yml`/`security.yml`; no se pierde cobertura.
- [Diffs potencialmente grandes] → Aceptado; los tres `security.yml` quedan idénticos y el resto se limita a los jobs y al esquema de Dependabot.

## Migration Plan

1. PR por repo (angular/react/vue3) aplicando el cambio de estructura, el gate y Dependabot.
2. Cerrar las PRs de Dependabot de acciones (`actions-minors` y `snyk/actions/node`), sustituidas por los commits unificados.
3. `update-submodules.yml` del monorepo actualiza los punteros de submódulo una vez fusionados los PRs.
   Rollback: revertir el PR del repo afectado; el estándar no introduce estado migrado.

## Open Questions

- Ninguna que cambie el enfoque. Queda como decisión posterior, fuera de este change, si react debería mover `eslint`/`eslint-config-next` a `devDependencies` (reclasificaría `braces` como dev en la auditoría).
