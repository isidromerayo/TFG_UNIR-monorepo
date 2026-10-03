# Spec Delta

## MODIFIED Requirements

### Requirement: Acciones de workflow en mayores soportadas
Toda referencia `uses:` a una acción de terceros en los workflows de cualquiera de los repositorios del proyecto MUST fijarse a un SHA de commit completo de 40 caracteres con un comentario `# vX.Y.Z` en la misma línea, y MUST corresponder a la versión mayor más reciente soportada de esa acción. MUST NOT usarse tags flotantes (p. ej. `@v4`) ni referencias a ramas.

#### Scenario: Auditoría de versiones de acciones
- **WHEN** se listan todas las referencias `uses:` de los workflows de los cinco repositorios
- **THEN** cada referencia es un SHA de 40 caracteres hexadecimales acompañado de un comentario `# vX.Y.Z`, y no queda ninguna referencia a tag flotante ni a rama

#### Scenario: Versión soportada al día
- **WHEN** se resuelve cada SHA a su etiqueta de versión
- **THEN** corresponde a la mayor más reciente publicada (p. ej. `actions/checkout` v7, `actions/setup-java` v6, `actions/setup-node` v7, `actions/upload-artifact` v7, `actions/download-artifact` v8, `pnpm/action-setup` v6, `actions/github-script` v9) en los cinco repositorios

#### Scenario: Runtime de las acciones actualizadas
- **WHEN** un workflow se ejecuta en runners gestionados por GitHub (`ubuntu-latest`)
- **THEN** los pasos de acciones se ejecutan sin advertencias de deprecación de runtime de Node ni errores de versión mínima de runner

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

## ADDED Requirements

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
