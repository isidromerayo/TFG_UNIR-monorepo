# Tasks

## 1. Backend (TFG_UNIR-backend)

- [x] 1.1 Añadir el ecosistema `github-actions` (`directory: "/"`, `interval: weekly`, grupo `actions-minors` con `[minor, patch]`, grupo `actions-majors` con `[major]`, `open-pull-requests-limit: 5`) a `backend/.github/dependabot.yml`, conservando `maven`, y verificar con `python3 -c "import yaml; yaml.safe_load(open('backend/.github/dependabot.yml'))"`
- [x] 1.2 Bump + re-pin a SHA+comentario en los workflows de backend: `actions/checkout` v4→v7, `actions/setup-java` v4→v6, `actions/upload-artifact` v4→v7, `actions/cache` v4→v6 (todas las apariciones en `maven.yml`, `sonarqube.yml`, `owasp-dependency-check-maven.yml`); verificar con `grep -rE "uses:.*@v[0-9]" backend/.github/workflows/` que no queda ningún tag flotante
- [x] 1.3 Hygiene backend: renombrar `backend/.github/workflows/notify-monorepo-workflow-content.yml` a `notify-monorepo.yml`, sustituir la cabecera `# VERSIÓN CORREGIDA PARA: ...` por una descripción real, y verificar que se mantienen `name: Notify Monorepo on Main Update` y `event-type: submodule-updated`
- [x] 1.4 Abrir el PR del backend y confirmar en verde los workflows del repo (Java CI, OWASP, SonarQube, notify); verificar que `actionlint` (contenedor fijado) no reporta nuevos errores

## 2. Vue3 (TFG_UNIR-vue3)

- [x] 2.1 Añadir el ecosistema `github-actions` (mismos parámetros de grupo que backend) a `vue3/.github/dependabot.yml`, conservando `npm`, y validar el YAML
- [x] 2.2 Bump + re-pin a SHA+comentario de los rezagos de vue3: `actions/checkout` v4→v7, `actions/cache` v4→v6, `actions/upload-artifact` v4→v7, `actions/download-artifact` v4→v8, `pnpm/action-setup` v4→v6 (con `with: version: 10.17.1`), `actions/github-script` v7→v9, `SonarSource/sonarqube-scan-action` v6→v8, `google/osv-scanner-action` v2.5→v2.6, `github/codeql-action` a la actual; verificar que no queda ningún `uses:` sin comentario de versión (o la anotación de origen para acciones sin release, p. ej. snyk)
- [x] 2.3 Hygiene vue3: eliminar el bloque comentado `#   uses: actions/setup-example@v1` de `vue3/.github/workflows/codeql.yml`
- [x] 2.4 Abrir el PR de vue3 y confirmar en verde sus workflows (CI, Tests, Security Audit, CodeQL) y `actionlint`

## 3. Angular y React (TFG_UNIR-angular, TFG_UNIR-react)

- [x] 3.1 Agrupar el ecosistema `github-actions` (grupos minor+patch / major, `open-pull-requests-limit: 5`) en `angular/.github/dependabot.yml` y `react/.github/dependabot.yml`, conservando `npm`, y validar ambos YAML
- [x] 3.2 Añadir el comentario `# vX.Y.Z` a cada `uses:` fijado por SHA en los workflows de angular y react, resolviendo el SHA a su tag con `git ls-remote --tags` (commit pelado, `^{}`); verificar con un script que cada SHA resuelve a la versión comentada
- [x] 3.3 Añadir `with: version: 10.17.1` a todas las apariciones de `pnpm/action-setup` en angular (hoy depende de `packageManager`), para igualar el patrón de react
- [x] 3.4 Hygiene: eliminar el bloque comentado `setup-example` de `angular/.github/workflows/codeql.yml` y `react/.github/workflows/codeql.yml`
- [x] 3.5 Abrir los PRs de angular y react y confirmar en verde sus workflows y `actionlint`

## 4. Monorepo (este repositorio)

- [x] 4.1 Cambiar `java-version` de `17` a `21` en las 3 apariciones de `.github/workflows/ci-simple.yml` (`backend-tests`, `security-analysis`, `build-all`) y verificar con `grep -n "java-version" .github/workflows/ci-simple.yml`
- [x] 4.2 Re-pin de las acciones del monorepo a SHA+comentario en `ci-simple.yml` y `update-submodules.yml` (`actions/checkout` v7, `actions/setup-java` v6, `actions/setup-node` v7, `actions/upload-artifact` v7, `pnpm/action-setup` v6), y verificar que no queda ningún `@vN` flotante
- [x] 4.3 Agrupar `github-actions` (minor+patch / major) en `.github/dependabot.yml`, conservando `docker`, y validar el YAML
- [x] 4.4 Ejecutar `actionlint` sobre los workflows del monorepo y confirmar que no hay nuevos errores (solo SC2086 preexistentes)

## 5. Verificación de integración

- [ ] 5.1 Confirmar que los PRs de los cuatro submódulos están fusionados y que su CI corre en verde con las versiones nuevas
- [ ] 5.2 Actualizar los punteros de submódulo en el monorepo al commit fusionado de cada repo y verificar `ci-simple.yml` en verde (incluido el job de backend con JDK 21)
- [ ] 5.3 Verificar que el check de configuración de Dependabot pasa en los 5 repos (o que los PRs de Dependabot se generan) y que el conjunto de acciones de angular, react y vue3 queda alineado
