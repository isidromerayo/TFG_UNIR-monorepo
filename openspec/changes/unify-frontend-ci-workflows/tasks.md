# Tasks

## 1. Angular (baseline)

- [x] 1.1 Mantener `security.yml` como referencia: gate duro `pnpm audit --prod` por exit code + lista `ACCEPTED="braces"`.
- [x] 1.2 Alinear `node.js.yml` (jobs `lint` + `build`) como estructura canónica.
- [x] 1.3 Confirmar `tests.yml` con job `sonarqube` guardado por `SONAR_TOKEN` y `dependabot.yml` con el esquema común.
- [x] 1.4 Bump de acciones a las versiones compartidas (setup-node v7.1.0, upload-artifact v7.0.2, download-artifact v8.0.2, codeql-action v4.38.3, osv-scanner v2.7.0, lcov-reporter-action v0.4.0, sonarqube-scan-action v8.3.0, snyk/actions/node).
- [x] 1.5 Abrir PR y dejar los workflows en verde (angular #277/#278).

## 2. React

- [x] 2.1 `node.js.yml` a jobs `lint` + `build`, sin pasos duplicados.
- [x] 2.2 `security.yml` idéntico a angular (gate por exit code + `ACCEPTED`); retirar la comparación con `npm audit`.
- [x] 2.3 Bump de acciones a las versiones compartidas.
- [x] 2.4 Alinear el `cron` de `codeql.yml`.
- [x] 2.5 Abrir PR y dejar los workflows en verde (react #254).

## 3. Vue3

- [x] 3.1 Mover `SonarQube` de `node.js.yml` a `tests.yml` con guarda `if: env.SONAR_TOKEN != ''` (desbloquea los PRs de Dependabot).
- [x] 3.2 `node.js.yml` a jobs `lint` + `build` (con `type-check` en `build`).
- [x] 3.3 `security.yml` idéntico a angular.
- [x] 3.4 `dependabot.yml` al esquema común (weekly, labels, commit-message, versioning-strategy).
- [x] 3.5 Bump de acciones y `cron` de `codeql.yml`.
- [x] 3.6 Abrir PR y dejar los workflows en verde (vue3 #252).

## 4. Dependabot de acciones

- [x] 4.1 Cerrar `actions-minors` (#275 angular, #250 react, #251 vue3) y `snyk/actions/node` (#272 angular, #246 react, #245 vue3) por quedar sustituidas.

## 5. Verificación de integración

- [x] 5.1 `actionlint` sin errores y `yaml.safe_load` válido en los 12 workflows.
- [x] 5.2 `security.yml` byte a byte idéntico en los tres frontends.
- [x] 5.3 CI en verde en los tres repos (los runs de PR pasan; SonarQube `skipped`/`pass`).
- [x] 5.4 Punteros de submódulo actualizados por `update-submodules.yml` tras fusionar los PRs.
