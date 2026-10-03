# Proposal

## Why

Los workflows activos de GitHub Actions del monorepo utilizan acciones fijadas a versiones mayores muy antiguas (`actions/checkout@v4`/`@v3`, `setup-java@v4`, `setup-node@v4`, `upload-artifact@v4`, `pnpm/action-setup@v4`, con últimas versiones v7/v6/v7/v7/v6 respectivamente), y el escaneo de seguridad ejecuta la imagen `docker.io/aquasec/trivy:latest` sin fijar. Esto crea dos problemas: deriva de versiones (soporte, runtime de Node de las acciones, compatibilidad futura) y un riesgo de seguridad real: el ecosistema Trivy sufrió un compromiso de cadena de suministro en marzo de 2026 (GHSA-69fq-xp46-6x23, crítica), donde se publicaron releases e imágenes Docker maliciosas; usar `latest` expone el CI a exactamente ese vector.

## What Changes

- Actualizar todas las acciones en `.github/workflows/ci-simple.yml` a sus mayores actuales: `actions/checkout@v7`, `actions/setup-java@v6`, `actions/setup-node@v7`, `actions/upload-artifact@v7`, `pnpm/action-setup@v6`.
- Actualizar `actions/checkout@v3` → `@v7` en `.github/workflows/update-submodules.yml`.
- Fijar la imagen de Trivy en `ci-simple.yml` a una versión concreta con digest (`aquasec/trivy:<version>@sha256:...`) en lugar de `latest`, en todas las invocaciones.
- Crear `.github/dependabot.yml` con soporte para los ecosistemas `github-actions` (todos los workflows, agrupado semanalmente) y `docker` (seguimiento del digest de Trivy fijado).
- El workflow deshabilitado `ci-monorepo.yml.disabled` NO se toca (fuera de alcance: no se ejecuta).

## Capabilities

### New Capabilities

- `ci/github-actions`: requisitos sobre el mantenimiento y la seguridad del pipeline de CI/CD de GitHub Actions: versiones de acciones soportadas, contenedores fijados de forma inmutable, y actualización automática continua vía Dependabot.

### Modified Capabilities

(none — `openspec/specs/` está vacío; no existen capacidades previas que modifiques)

## Impact

- **Archivos modificados**: `.github/workflows/ci-simple.yml`, `.github/workflows/update-submodules.yml`.
- **Archivo nuevo**: `.github/dependabot.yml`.
- **Riesgos**: saltos de mayor en acciones pueden introducir breaking changes (p. ej. comportamiento de caché en `setup-node`, formato de artefactos en `upload-artifact`, detección de `packageManager` en `pnpm/action-setup` v6). Se mitiga verificando ambas pipelines en un PR antes de fusionar.
- **Sin impacto** en código de aplicación, submódulos ni versiones de librerías (eso lo cubren `./scripts/update-all.sh` y los `packageManager` ya fijados en pnpm 10.17.1).
