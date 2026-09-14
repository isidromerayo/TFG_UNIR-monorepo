# Plan: Unificar versiones de pnpm (y Node) en los 3 frontends

**Creado:** 2026-09-14 · **Estado:** Aprobado (pnpm 10.17.1 exacta · Angular→pnpm · Node→22) · **Ejecución:** pendiente

## Estado actual (auditoría)

| Sitio | Versión usada |
|---|---|
| `angular/package.json` → `packageManager` | `pnpm@10.17.1` ✅ |
| `react/package.json` / `vue3/package.json` | ❌ sin campo `packageManager` |
| Monorepo `ci-simple.yml` (`version: 9`: líneas 219, 270, 336) | pnpm 9 ⚠️ |
| Job `angular-tests` en `ci-simple.yml` (178-192) y Angular en `build-all` (341-342) | npm ⚠️ (contradice `angular/AGENTS.md`: "pnpm only") |
| Workflows propios de `react/` y `vue3/` (`tests.yml` ×4, `node.js.yml`, `security.yml`) | `version: 10` (sin fixear) |
| `AGENTS.md` raíz | cita "pnpm 10.24.0" para Angular (obsoleto) |
| `node-version` en `ci-simple.yml` (173, 214, 265, 325) | 20 (docs dicen 22.x) |
| Entorno local | pnpm 10.17.1 + corepack 0.34.6 — `pnpm install --frozen-lockfile` pasa en las 3 apps |
| Lockfiles | todos `lockfileVersion: 9.0` (compatibles pnpm 9/10, no cambian) |

**Causa raíz del fallo CI `vue3-tests` (desde PR #5 y también en main):** vue3 migró sus `overrides` de seguridad a `pnpm-workspace.yaml` (commit 30cb498, solo lo lee pnpm ≥10); con pnpm 9 en CI no se ven → `ERR_PNPM_LOCKFILE_CONFIG_MISMATCH` en `pnpm install --frozen-lockfile`.

**Estándar objetivo: pnpm 10.17.1 fijada vía `packageManager` + corepack, Node 22.x en CI de frontends.**

## Fase A — Submódulos react y vue3 (1 PR por repo, rama `chore/unify-pnpm-10.17.1`)

### react/
- [ ] Añadir `"packageManager": "pnpm@10.17.1"` en `package.json`
- [ ] Workflows propios: `version: 10` → `version: 10.17.1` (`tests.yml` líneas ~26/135/208, `node.js.yml:29`, `security.yml:43`)
- [ ] Verificar `pnpm install --frozen-lockfile` sin cambios en el lockfile

### vue3/
- [ ] Añadir `"packageManager": "pnpm@10.17.1"` en `package.json`
- [ ] Workflows propios: `version: 10` → `version: 10.17.1` (mismos archivos que react)
- [ ] Verificar `pnpm install --frozen-lockfile` sin cambios en el lockfile

### angular/
- [ ] Verificar si tiene workflows propios con pnpm sin fijar (no detectados en la auditoría; confirmar en su repo)

## Fase B — Monorepo (rama `ci/unify-frontend-pnpm-node22`)

Depende del merge de los PRs de la Fase A (para los punteros).

- [ ] `ci-simple.yml`: `version: 9` → `version: 10.17.1` en los 3 `pnpm/action-setup@v4` (219, 270, 336)
- [ ] Job `angular-tests`: añadir setup pnpm 10.17.1 y sustituir:
  - `npm install --legacy-peer-deps --force` → `pnpm install --frozen-lockfile`
  - `npm run test-headless-cc` → `pnpm test-headless-cc`
  - `npm audit` → `pnpm audit` (mantener artefacto `angular-audit.json`; revisar si algún step posterior consume ese JSON con formato npm)
- [ ] Job `build-all`: bloque Angular (341-342) de npm → pnpm (usa el setup pnpm del propio job)
- [ ] `node-version: '20'` → `'22'` en jobs de frontend (173, 214, 265, 325)
- [ ] Avanzar punteros `react` y `vue3` al `main` de cada submódulo
- [ ] PR contra `main` del monorepo

## Fase C — Documentación

- [ ] `AGENTS.md` raíz: "pnpm 10.24.0" → "pnpm 10.17.1 (fijada en `packageManager` + corepack) en los tres frontends"
- [ ] Notas en `scripts/` si `test-all.sh` asume pnpm global: documentar resolución por corepack según `packageManager`

## Fase D — Verificación

- [ ] `./scripts/test-all.sh` local
- [ ] CI monorepo verde: `vue3-tests` (error raíz desaparece con pnpm 10), `angular-tests` estable con pnpm
- [ ] `pnpm audit` sin regresiones frente a `npm audit` en Angular

## Riesgos conocidos

- Migrar Angular a pnpm puede destapar roturas latentes: `angular/AGENTS.md` documenta quirks de hoisting bajo pnpm 12 (roturas `TS2688`); con pnpm 10.17.1 sus notas indican que CI es verde.
- Node 22 con Angular 21: soportado. Node 22 con binarios de Cypress de los submódulos: verificar en la primera corrida.
- Diferencia de salida `pnpm audit --json` vs `npm audit --json` en los artefactos de seguridad.

---
**Última actualización:** 2026-09-14
