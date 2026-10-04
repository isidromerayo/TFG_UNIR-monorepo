# ci/github-actions Specification

## Purpose

Define los requisitos de mantenimiento y seguridad del pipeline de CI/CD de GitHub Actions del monorepo: uso de versiones soportadas de acciones, fijado inmutable de contenedores y actualización automática continua.

## Requirements

### Requirement: Acciones de workflow en mayores soportadas
Toda referencia `uses:` a una acción de terceros en los workflows de cualquiera de los repositorios del proyecto MUST fijarse a un SHA de commit completo de 40 caracteres con un comentario `# vX.Y.Z` en la misma línea, y MUST corresponder a la versión mayor más reciente soportada de esa acción. MUST NOT usarse tags flotantes (p. ej. `@v4`) ni referencias a ramas. Cuando una acción no publique releases etiquetados, MUST documentarse la referencia usada con una anotación de origen (p. ej. `# master @ YYYY-MM-DD`).

#### Scenario: Auditoría de versiones de acciones
- **WHEN** se listan todas las referencias `uses:` de los workflows de los cinco repositorios
- **THEN** cada referencia es un SHA de 40 caracteres hexadecimales acompañado de un comentario de versión (`# vX.Y.Z`, o la anotación de origen para acciones sin releases etiquetados) y no queda ninguna referencia a tag flotante ni a rama

#### Scenario: Versión soportada al día
- **WHEN** se resuelve cada SHA a su etiqueta de versión
- **THEN** corresponde a la mayor más reciente publicada (p. ej. `actions/checkout` v7, `actions/setup-java` v6, `actions/setup-node` v7, `actions/upload-artifact` v7, `actions/download-artifact` v8, `pnpm/action-setup` v6, `actions/github-script` v9) en los cinco repositorios

#### Scenario: Runtime de las acciones actualizadas
- **WHEN** un workflow se ejecuta en runners gestionados por GitHub (`ubuntu-latest`)
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
Todo repositorio del proyecto que contenga workflows de GitHub Actions MUST declarar en su `.github/dependabot.yml` el ecosistema `github-actions`; el monorepo MUST cubrir además el ecosistema `docker` para los manifiestos de imagen fijados. Las actualizaciones MUST agruparse para limitar el número de PRs.

#### Scenario: Cobertura por repositorio
- **WHEN** se revisan los `dependabot.yml` de los cinco repositorios
- **THEN** cada uno declara `github-actions` con `directory: "/"` y el monorepo declara además `docker`

#### Scenario: Nueva versión mayor de una acción
- **WHEN** se publica una nueva versión de una acción usada por los workflows
- **THEN** Dependabot abre un PR agrupado que actualiza a la vez el SHA y el comentario `# vX.Y.Z`

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

### Requirement: Homogeneidad de runtime entre repositorios
Los workflows de todos los repositorios MUST usar runtimes consistentes: la compilación y el análisis del backend, incluido el job correspondiente del monorepo, MUST usar JDK 21; los frontends MUST usar Node 22.x; y pnpm MUST ser `10.17.1`, declarado explícitamente o resuelto desde el campo `packageManager`.

#### Scenario: JDK del backend en el monorepo
- **WHEN** el workflow `ci-simple.yml` del monorepo prepara la compilación del backend
- **THEN** `actions/setup-java` configura `java-version: '21'`, igual que los workflows del repositorio backend

#### Scenario: Versión de pnpm en los frontends
- **WHEN** los jobs de angular, react y vue3 instalan dependencias
- **THEN** se usa pnpm `10.17.1` y `pnpm install --frozen-lockfile` tiene éxito

### Requirement: Equivalencia de CI entre los tres frontends
Los repositorios angular, react y vue3 MUST usar el mismo conjunto de acciones con versiones alineadas en sus workflows equivalentes (`node.js`, `tests`, `security`, `codeql`), de modo que las diferencias de CI no sesguen la comparación entre frameworks.

#### Scenario: Comparación de acciones entre frontends
- **WHEN** se comparan las referencias `uses:` de angular, react y vue3
- **THEN** toda acción presente en uno de los tres aparece en los otros dos con la misma versión, sin acciones desactualizadas o ausentes en un frontend respecto a los otros
