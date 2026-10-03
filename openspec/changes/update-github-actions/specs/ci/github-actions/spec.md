# Spec Delta

## Purpose

Define los requisitos de mantenimiento y seguridad del pipeline de CI/CD de GitHub Actions del monorepo: uso de versiones soportadas de acciones, fijado inmutable de contenedores y actualización automática continua.

## ADDED Requirements

### Requirement: Acciones de workflow en mayores soportadas
Todos los pasos `uses:` que referencien acciones de GitHub en los workflows activos del repositorio MUST apuntar a la versión mayor actualmente publicada de cada acción.

#### Scenario: Auditoría de versiones de acciones
- **WHEN** se listan todas las referencias `uses:` de los workflows activos (`ci-simple.yml`, `update-submodules.yml`)
- **THEN** cada acción aparece en su mayor más reciente (p. ej. `actions/checkout@v7`, `actions/setup-java@v6`, `actions/setup-node@v7`, `actions/upload-artifact@v7`, `pnpm/action-setup@v6`) y ninguna queda en `v3` o `v4`

#### Scenario: Runtime de las acciones actualizadas
- **WHEN** un workflow se ejecuta en runners gestionados por GitHub (`ubuntu-latest`) tras los bumps
- **THEN** los pasos de acciones se ejecutan sin advertencias de deprecación de runtime de Node ni errores de versión mínima de runner

### Requirement: Imágenes de contenedor fijadas de forma inmutable
Cualquier imagen de contenedor invocada por un workflow activo MUST fijarse a una versión concreta junto con su digest criptográfico (`imagen:<versión>@sha256:<digest>`) y MUST NOT usar la etiqueta `latest` ni otras etiquetas mutables. La referencia fijada MUST residir en un manifiesto que Dependabot pueda parsear (p. ej. un Dockerfile en `/.github/workflows`), de modo que pueda renovarse automáticamente.

#### Scenario: Escaneo Trivy con imagen fijada
- **WHEN** el job `security-analysis` de `ci-simple.yml` ejecuta el escaneo con Trivy
- **THEN** construye la imagen local desde `.github/workflows/trivy.dockerfile` (cuyo `FROM` lleva versión y digest SHA-256), la invoca para los mismos escaneos `fs` (backend, JAR, angular, react, vue3) y produce los mismos informes (TXT/HTML) que antes

#### Scenario: Ausencia de etiquetas mutables
- **WHEN** se buscan referencias a imágenes `:latest` (u otras etiquetas mutables) en los ficheros de `.github/workflows`
- **THEN** no existe ninguna coincidencia

### Requirement: Dependabot mantiene las dependencias del pipeline
El repositorio MUST disponer de configuración de Dependabot (`.github/dependabot.yml`) que cubra el ecosistema `github-actions` para todos los workflows activos y el ecosistema `docker` para los manifiestos de imagen fijados, agrupando actualizaciones para limitar el ruido.

#### Scenario: Nueva versión mayor de una acción
- **WHEN** se publica una nueva versión de una acción usada por los workflows
- **THEN** Dependabot abre un PR de actualización agrupado (máximo 5 PRs abiertos por grupo) sin dividir un PR por acción

#### Scenario: Actualización del digest de Trivy
- **WHEN** se publica una nueva versión de `aquasec/trivy` o cambia su digest
- **THEN** Dependabot abre un PR que actualiza la versión y el digest fijados en `.github/workflows/trivy.dockerfile`

### Requirement: Los bumps preservan el comportamiento de las pipelines
Las actualizaciones de versiones MUST mantener inalterados los jobs, pasos, artefactos y semántica de disparo de los workflows existentes; el pipeline MUST seguir funcionando tras los cambios.

#### Scenario: Ejecución verde tras los bumps
- **WHEN** se abre un PR con los cambios y se ejecutan `CI Simple - All Projects` y `Update Submodules`
- **THEN** ambos workflows completan con éxito, los informes de Trivy y las auditorías de pnpm se suben como artefactos, y `Update Submodules` sigue pudiendo commitear y pushear actualizaciones de submódulos

#### Scenario: Sin cambios de versión de pnpm
- **WHEN** los jobs de frontend ejecutan la instalación con `pnpm/action-setup` actualizado
- **THEN** se usa pnpm `10.17.1`, en coherencia con el campo `packageManager` de los `package.json` de cada frontend (la acción corre en la raíz del monorepo, que carece de `packageManager`, por lo que la versión se declara explícitamente en el workflow), y `pnpm install --frozen-lockfile` tiene éxito
