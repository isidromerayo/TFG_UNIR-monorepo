# Design

## Context

Estado actual verificado (Oct 2026):

- `ci-simple.yml` fija `actions/checkout@v4`, `actions/setup-java@v4`, `actions/setup-node@v4`, `actions/upload-artifact@v4`, `pnpm/action-setup@v4` (con `version: 10.17.1` explícito).
- `update-submodules.yml` fija `actions/checkout@v3`.
- Mayores publicados hoy: checkout **v7.0.1**, setup-java **v6.0.1**, setup-node **v7.0.0**, upload-artifact **v7.0.1**, pnpm/action-setup **v6.1.0**.
- El escaneo Trivy ejecuta `docker.io/aquasec/trivy:latest` vía Podman/Docker detectado en runtime. La etiqueta `latest` es el mismo vector que explotó el compromiso de cadena de suministro de Trivy de marzo de 2026 (GHSA-69fq-xp46-6x23, crítica: releases 0.69.4–0.69.6 e imágenes maliciosas). Última versión legítima de Trivy: **v0.75.0** (2026-10-01).
- Los runners son `ubuntu-latest` gestionados por GitHub (siempre ≥ 2.327.1), por lo que el cambio a runtime Node 24 de los mayores v5+ no es un impedimento.
- Las tres pipelines front-end declaran `packageManager: pnpm@10.17.1` en su `package.json`.
- `ci-monorepo.yml.disabled` no se ejecuta: fuera de alcance por decisión del usuario.

Motivación y alcance: ver `proposal.md` (sección Why/What Changes) y los requisitos en `specs/ci/github-actions/spec.md`.

## Goals / Non-Goals

**Goals:**
- Todos los workflows activos en mayores soportadas, sin breaking changes funcionales observables.
- Trivy referenciado por versión + digest SHA-256 (inmutable).
- Dependabot como mecanismo continuo que evite nueva deriva de versiones.

**Non-Goals:**
- No se tocan versiones de librerías de las aplicaciones ni de los submódulos.
- No se reactiva ni moderniza `ci-monorepo.yml.disabled`.
- No se migran las acciones a pinnar por commit SHA (ver Decisión 1).
- No se cambian triggers, jobs ni pasos más allá de lo que exija la compatibilidad de los mayores.

## Decisions

1. **Acciones de GitHub: pin por etiqueta mayor (`@v7`) + Dependabot, no por commit SHA.**
   Alternativa considerada: fijar cada `uses:` a un SHA de commit (máxima protección contra re-tagging malicioso). Descartada: con Dependabot activo sobre el ecosistema `github-actions`, los PRs de actualización ya cierran la ventana de deriva, y el SHA pin reduce mucho la legibilidad para un repo académico. La protección por digest sí se aplica a la imagen Docker (Decisión 2), donde existe un precedente real de compromiso.

2. **Trivy: Dockerfile acompañante `.github/workflows/trivy.dockerfile` con el pin `FROM docker.io/aquasec/trivy:0.75.0@sha256:<digest>`, y los `run:` invocan la imagen local `trivy-pinned` construida desde él.**
   Motivo verificado en implementación: Dependabot NO parsea imágenes referenciadas dentro de pasos `run:` de workflows (dependabot-core #5819/#8362, sin soporte en 2026); el workaround soportado es un Dockerfile en `directory: "/.github/workflows"` que Dependabot sí mantiene. El job hace `$CONTAINER_CMD build -t trivy-pinned - < .github/workflows/trivy.dockerfile` (contexto vacío por stdin, funciona igual con Docker y Podman; equivale al pull del `:latest` anterior) y luego ejecuta `trivy-pinned` en los mismos comandos `fs`. El digest verificado de 0.75.0 (2026-10-01): `sha256:af6acf9a6b85dfe389a1941505c0ce9efef52a4719635e1a962f022a3d855daa`. Alternativas: (a) invocar la imagen fijada directamente en `run:` — descartada, Dependabot no la rastrearía y violaría el requisito de actualización automática del digest; (b) `aquasecurity/trivy-action` — descartada porque cambiaría el mecanismo de escaneo (binario nativo vs contenedor) y perdería el patrón Podman/Docker existente.

3. **`pnpm/action-setup@v6`: probar resolución desde `packageManager` (sin input `version:`) con fallback explícito si no funciona.**
   v6 auto-actualiza su bootstrap a la versión fijada en `packageManager` del `package.json` **del directorio donde corre la acción**. Resultado verificado en PR #15: la acción corre en la raíz del monorepo, que no tiene `package.json`/`packageManager`, y falla con "No pnpm version is specified" → se aplica el fallback previsto: `version: 10.17.1` explícito en las 4 apariciones. Alternativa descartada: añadir un `package.json` raíz con `packageManager` — cambiaría la estructura del monorepo por un tema de CI.

4. **`setup-node@v7` sin inputs de caché**: v5 introdujo caché automático por `packageManager` y v6 lo restringió a npm; nuestro uso (solo `node-version: '22'`) no se ve afectado. Se mantiene Node 22.

5. **`upload-artifact@v7`**: los inputs usados (`name`, `path`, `retention-days`) no cambiaron semántica entre v4→v7 (v5/v6 fueron runtime Node 24; v7 añade uploads directos y ESM). No se requieren ajustes.

6. **Dependabot (`dependabot.yml`)**: 
   - `github-actions` para `directory: /` y `/.github/workflows`, `interval: weekly`, un grupo `actions-minors` (`update-types: [version-update:semver-minor, version-update:semver-patch]`) y otro `actions-majors` (semver-major), `open-pull-requests-limit: 5`.
   - `docker` con `directory: "/.github/workflows"` para el Dockerfile acompañante de Trivy (Decisión 2), semanal.
   - Sin `package-ecosystem: npm`/`maven` (la gestión de librerías pertenece a los submódulos y a `./scripts/update-all.sh`).
   Alternativa: Renovate — descartado por requerir desplegar un bot adicional con token propio; Dependabot es nativo y suficiente.

7. **Orden de verificación**: un único PR con todos los bumps + pin + `dependabot.yml`, validando con `gh run` que `CI Simple` y `Update Submodules` quedan en verde antes de fusionar.

## Risks / Trade-offs

- [Bumps de mayor con breaking changes no detectados en lectura (p. ej. ESM en checkout v7 afecta a uso con `workflow_run`)] → Un solo PR de CI con ambos workflows ejecutándose; rollback = revert del PR.
- [`pnpm/action-setup@v6` sin `version:` puede instalar un pnpm distinto si no detecta `packageManager` en la raíz] → Verificar en el PR la versión efectivamente instalada (`pnpm --version`); fallback explícito documentado en la Decisión 3.
- [Digest fijado "caduco" frente a nuevas versiones de Trivy] → El ecosistema `docker` de Dependabot renueva versión y digest automáticamente.
- [Etiquetas mayores mutables para acciones first-party] → Riesgo asumido conscientemente (Decisión 1); mitigado por Dependabot semanal y porque los runners de GitHub ejecutan acciones de `actions/*` que son de la propia organización.
- [Dependabot genere ruido en un repo académico] → Agrupación por tipos de semver y límite de 5 PRs abiertos.

## Migration Plan

1. Aplicar bumps de `uses:` en ambos workflows activos.
2. Sustituir las 10 referencias a `aquasec/trivy:latest` por la construcción (`build - < trivy.dockerfile`) y ejecución de la imagen local `trivy-pinned`, con el pin versión+digest en el Dockerfile acompañante.
3. Añadir `.github/dependabot.yml`.
4. Push a rama, abrir PR, comprobar verde en ambos workflows (incluido un `workflow_dispatch` de Update Submodules).
5. Fusionar. Rollback: revertir el commit único; no hay estado migrado.

## Open Questions

- Ninguna que afecte a specs o tareas. (Si el propietario desea además "Dependabot security updates" —escaneo de CVEs en dependencias del pipeline— se activa desde Settings sin cambios en repo; se decide tras el archive.)
