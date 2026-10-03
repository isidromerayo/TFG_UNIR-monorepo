# Tasks

## 1. Bumps de acciones en workflows activos

- [ ] 1.1 En `.github/workflows/ci-simple.yml`, sustituir `actions/checkout@v4` → `@v7`, `actions/setup-java@v4` → `@v6`, `actions/setup-node@v4` → `@v7`, `actions/upload-artifact@v4` → `@v7` (todas las apariciones) y verificar con `grep -n "uses:" .github/workflows/ci-simple.yml` que ninguna referencia first-party queda en v3/v4
- [ ] 1.2 En `ci-simple.yml`, actualizar `pnpm/action-setup@v4` → `@v6` y eliminar el input `version: 10.17.1` de las 4 apariciones, y verificar que ningún bloque `pnpm/action-setup` conserva `with: version:`
- [ ] 1.3 En `.github/workflows/update-submodules.yml`, actualizar `actions/checkout@v3` → `@v7` (manteniendo `token` y `submodules: 'true'`) y verificar que el único `uses:` del fichero es `actions/checkout@v7`
- [ ] 1.4 Añadir un paso temporal `pnpm --version` tras cada `pnpm/action-setup` en `ci-simple.yml` y confirmar en el run del PR (tarea 3.2) que resuelve `10.17.1` desde `packageManager` de los `package.json` de angular/react/vue3; si en la raíz del monorepo no lo detecta, restaurar `version: 10.17.1` explícito como fallback y volver a verificar

## 2. Pin inmutable de Trivy

- [ ] 2.1 Obtener el digest de la última imagen estable de Trivy (`docker buildx imagetools inspect docker.io/aquasec/trivy:v0.75.0` o `skopeo inspect docker://docker.io/aquasec/trivy:v0.75.0`; si existe una versión posterior legítima, usarla) y verificar que se obtiene una referencia `sha256:...` válida
- [ ] 2.2 Reemplazar las 8 referencias a `docker.io/aquasec/trivy:latest` en `ci-simple.yml` por `docker.io/aquasec/trivy:<versión>@sha256:<digest>` y verificar con `grep -c "trivy:latest" .github/workflows/ci-simple.yml` que el resultado es 0 y que todas las invocaciones portan `@sha256:`

## 3. Dependabot y validación

- [ ] 3.1 Crear `.github/dependabot.yml` con `github-actions` (weekly, grupos `actions-minors` para minor+patch y `actions-majors` para major, `open-pull-requests-limit: 5`, `directories: ["/", "/.github/workflows"]`) y `docker` (weekly, para la imagen Trivy fijada) y verificar la sintaxis con `python3 -c "import yaml; yaml.safe_load(open('.github/dependabot.yml'))"` o `actionlint` si está disponible
- [ ] 3.2 Push de la rama, apertura de PR y verificación verde: `gh run list --workflow "CI Simple - All Projects" --limit 1` y `gh run list --workflow "Update Submodules" --limit 1` en la rama del PR, más un `gh workflow run "Update Submodules"` manual (`workflow_dispatch`) que complete con éxito; confirmar en los logs que los artefactos `trivy-security-reports` y `*-security-audit` se suben con los mismos nombres que antes
- [ ] 3.3 Comprobar en el run del PR que los pasos de checkout/setup-java/setup-node/upload-artifact no emiten advertencias de deprecación de runtime ni errores de versión mínima de runner (`gh run view <id> --log | grep -iE "deprecat|minimum.*runner"`) y que `pnpm install --frozen-lockfile` y `./mvnw` funcionan con los bumps
- [ ] 3.4 Retirar los pasos temporales de `pnpm --version` de la tarea 1.4 (si se usaron) y documentar la decisión final sobre `packageManager` vs input `version:` en el cuerpo del PR; verificar que el diff final no contiene pasos temporales
