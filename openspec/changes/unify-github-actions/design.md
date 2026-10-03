# Design

## Context

Ver `proposal.md - Why` para la motivación. Estado verificado (Oct 2026):

- **5 repos independientes**: monorepo + `TFG_UNIR-backend`, `-angular`, `-react`, `-vue3`. Los cuatro submódulos son repos propios enlazados por punteros; sus workflows se cambian ahí, no en el monorepo.
- **Tres estilos de pinning coexisten**:
  - monorepo: tags mayores flotantes (`actions/checkout@v7`, `setup-java@v6`...).
  - backend: tags mayores flotantes (`@v4`).
  - angular/react/vue3: SHA de 40 caracteres, casi siempre **sin** comentario de versión.
- **Monorepo**: 2 workflows activos (`ci-simple.yml`, `update-submodules.yml`) + `trivy.dockerfile`. `actionlint` limpio (solo SC2086 preexistentes). Dependabot con `github-actions` + `docker`.
- **Backend** (4 workflows): `maven.yml`, `sonarqube.yml`, `owasp-dependency-check-maven.yml`, `notify-monorepo-workflow-content.yml`. Dependabot solo `maven` (sin `github-actions`).
- **Angular/React** (4 workflows cada uno): ya en mayores actuales (checkout v7.0.1, setup-node v7.0.0, upload-artifact v7.0.1, cache v6.1.0, download-artifact v8.0.1, github-script v9.0.0, codeql v4.38.2, sonarqube-scan v8.2.2, osv-scanner v2.6.0). Dependabot con `npm` + `github-actions`.
- **Vue3** (4 workflows): **rezagado** — checkout v4.4.0, cache v4.3.0, upload-artifact v4.6.2, download-artifact v4.3.0, pnpm/action-setup v4, github-script v7.1.0, sonarqube-scan v6.0.0, osv-scanner v2.5.0, codeql desconocido. Dependabot solo `npm` (sin `github-actions`).
- **Inconsistencias observadas**: `ci-simple.yml` del monorepo compila el backend con **JDK 17** mientras backend usa **21**; angular resuelve pnpm por `packageManager` (sin `with:`), react/vue3 pasan `version: 10.17.1`; los tres `codeql.yml` conservan un bloque comentado `#   uses: actions/setup-example@v1`; el notify del backend tiene cabecera `# VERSIÓN CORREGIDA PARA: ... Reemplazar el archivo` y un filename poco estándar.
- Resolución SHA→tag verificada con `git ls-remote --tags` (ojo: tags anotados requieren el commit pelado `^{}`).

## Goals / Non-Goals

**Goals:**
- Un único estándar de pinning en los 5 repos: SHA de commit + comentario `# vX.Y.Z` en la misma línea.
- Rezagos (vue3, backend) al día con las mayores actuales en el mismo movimiento.
- Cobertura `github-actions` de Dependabot en los 5 repos, con agrupación.
- Runtimes homogéneos y CI equivalente entre los tres frontends.

**Non-Goals:**
- No se cambia qué hace cada job (comandos, triggers, artefactos) más allá de lo que exija un bump de mayor.
- No se toca código de aplicación ni dependencias npm/maven.
- No se unifican los ficheros entre repos a un único literal (cada frontend mantiene sus comandos específicos); solo se alinean las acciones y versiones.

## Decisions

1. **SHA de commit + comentario `# vX.Y.Z` en la misma línea, como estándar único.**
   Alternativas: (a) tags mayores flotantes (`@v7`) — simples pero mutables, riesgo de cadena de suministro que ya motivó el pin de Trivy; (b) SHA sin comentario — inmutable pero ilegible e inauditable (el estado actual de los frontends). El comentario en la misma línea es, además, lo que Dependabot usa para documentar la versión al actualizar el SHA. Se resuelve cada tag a su commit con `git ls-remote --tags` y se usa el commit pelado (no el SHA del objeto tag anotado).

2. **Bump y re-pinning en un solo paso para los rezagados (vue3, backend).**
   Alternativa: primero actualizar y luego re-pinnar — duplica PRs y deja una ventana con versiones antiguas. Se fija directamente el SHA de la mayor actual.

3. **Dependabot: añadir `github-actions` a backend y vue3, y agrupar en los 5.**
   Angular/react/monorepo ya tienen `github-actions` pero sin grupos; para cumplir el requisito de agrupación se añade un grupo por tipo de actualización (minor+patch / major) de forma consistente. El monorepo mantiene además `docker`. Alternativa: no agrupar en angular/react — incumpliría el requisito unificado.

4. **pnpm en frontends: `version: 10.17.1` explícito en los tres.**
   Alternativa: depender de `packageManager` (hoy solo lo hace angular). Se prefiere el input explícito porque es determinista, no depende de que la acción corra en el directorio raíz del repo y ya es el patrón de react/vue3 y del monorepo. Se añade `with: version: 10.17.1` a angular.

5. **Runtime del backend: JDK 21 en el `ci-simple.yml` del monorepo.**
   Es la versión que ya usan los workflows del backend y la declarada en AGENTS.md. Se corrigen las 3 apariciones (`backend-tests`, `security-analysis`, `build-all`).

6. **Hygiene acotada**: eliminar el bloque comentado `setup-example` de los tres `codeql.yml`; renombrar `backend/.github/workflows/notify-monorepo-workflow-content.yml` a `notify-monorepo.yml` y sustituir su cabecera `# VERSIÓN CORREGIDA...` por una descripción real. Alternativa: dejar el rename fuera — pero el nombre actual es engañoso respecto al workflow real.

7. **Entrega en PRs por repo, con el monorepo al final.** El orden: backend y vue3 (config + bumps), angular y react (agrupación Dependabot + re-pin con comentarios), monorepo (JDK 21 + agrupación + re-pin de sus propias acciones a SHA+comentario). Tras fusionar en los submódulos, se actualizan los punteros en el monorepo.

8. **Verificación**: `actionlint` (contenedor fijado) sobre los 15 workflows, un script que resuelva cada `uses:` a su tag para confirmar el comentario, ejecución real de cada workflow en su repo, y solo entonces bump de punteros.

## Risks / Trade-offs

- [Tags anotados: usar el SHA del objeto tag en vez del commit rompe el pin/la resolución] → Resolver con `git ls-remote --tags` y tomar la línea `^{}` (commit pelado); verificar resolviendo de vuelta SHA→tag.
- [Bumps de mayor (upload-artifact v4→v7, download-artifact v4→v8, cache v4→v6, github-script v7→v9, pnpm v4→v6) rompen algún job] → Ejecutar cada workflow en su repo antes de fusionar; rollback = revert del PR del repo.
- [El renombrado del workflow de notify puede alterar referencias o historial de Actions] → Confirmar que nada referencia el filename; mantener el `name:` interno (`Notify Monorepo on Main Update`) y el `event-type: submodule-updated`.
- [Diffs muy grandes por el re-pinning a SHA en ~13 workflows] → Aceptado; el comentario `# vX.Y.Z` conserva la legibilidad y Dependabot mantiene ambas partes.
- [Orden entre repos: el monorepo no puede apuntar a commits de submódulo que aún no existen] → Fusionar primero los PRs de los submódulos, después el bump de punteros en el monorepo.
- [Ediciones en 4 repos fuera de este monorepo no quedan cubiertas por su CI agregada] → Cada repo tiene su propia CI; la verificación es por repo, no solo `ci-simple.yml`.

## Migration Plan

1. PR en `TFG_UNIR-backend`: `github-actions` en dependabot + bump+re-pin de sus 4 workflows.
2. PR en `TFG_UNIR-vue3`: `github-actions` en dependabot + bump+re-pin de sus 4 workflows (los 6 rezagos).
3. PRs en `TFG_UNIR-angular` y `TFG_UNIR-react`: agrupar `github-actions` en dependabot + añadir comentarios `# vX.Y.Z` a los SHA existentes (versiones ya al día); angular suma `with: version: 10.17.1`.
4. PR en el monorepo: JDK 17→21 en `ci-simple.yml`, re-pin de sus propias acciones a SHA+comentario, agrupar `github-actions`, hygiene (`codeql.yml` no aplica al monorepo; aquí solo JDK + pin + Dependabot).
5. Tras fusionar 1–3, bump de punteros de submódulo en el monorepo y verificación de `ci-simple.yml` verde.
   Rollback: revertir el PR del repo afectado; el estándar no introduce estado migrado.

## Open Questions

- Ninguna que cambie el enfoque o las tareas. (Queda como decisión posterior, fuera de este change, si se adoptará el mismo estándar SHA+comentario para las imágenes de contenedor de los submódulos, hoy inexistentes.)
