# Spec Delta

## MODIFIED Requirements

### Requirement: Equivalencia de CI entre los tres frontends
Los repositorios angular, react y vue3 MUST mantener workflows equivalentes en estructura y semántica, no solo el mismo conjunto de acciones: sus `node.js.yml` MUST exponer los mismos jobs (`lint` y `build`), sus `security.yml` MUST ser idénticos con un gate duro de vulnerabilidades de producción, su job de análisis estático MUST residir en `tests.yml` protegido por el secreto de Sonar, y sus `dependabot.yml` MUST compartir el mismo esquema de programación, etiquetas y mensajes de commit. Las diferencias se limitan a los comandos específicos de cada framework (`lint`/`build`/`test`/`type-check`) y a los grupos de dependencias por framework.

#### Scenario: Comparación de acciones entre frontends
- **WHEN** se comparan las referencias `uses:` de angular, react y vue3
- **THEN** toda acción presente en uno de los tres aparece en los otros dos con la misma versión, sin acciones desactualizadas o ausentes en un frontend respecto a los otros

#### Scenario: Mismos jobs en la CI principal
- **WHEN** se comparan los jobs de `node.js.yml` en angular, react y vue3
- **THEN** los tres declaran exactamente los jobs `lint` y `build`, y ninguno duplica pasos de test, Cypress o auditoría que ya residan en `tests.yml` o `security.yml`

#### Scenario: Job de análisis estático protegido por secreto
- **WHEN** se ejecuta el job de SonarQube en un pull request abierto por Dependabot (sin acceso a secretos)
- **THEN** el job vive en `tests.yml`, está guardado con `if: env.SONAR_TOKEN != ''` en los tres frontends y queda en estado `skipped` en lugar de `failure`

#### Scenario: Gate de seguridad de producción idéntico
- **WHEN** se comparan los `security.yml` de angular, react y vue3
- **THEN** los tres son idénticos, ejecutan `pnpm audit --prod` como gate duro (guiándose por el exit code para respetar `pnpm.auditConfig.ignoreCves`), toleran únicamente el paquete aceptado documentado en `SECURITY_AUDIT_ANALYSIS.md` y fallan ante cualquier otra vulnerabilidad de producción

#### Scenario: Esquema de Dependabot homogéneo
- **WHEN** se revisan los `dependabot.yml` de angular, react y vue3
- **THEN** los tres declaran para `npm` y `github-actions` una programación `weekly` (lunes 09:00 Europe/Madrid), límites equivalentes, `labels` y `commit-message`, y grupos `actions-minors`/`actions-majors` para las acciones
