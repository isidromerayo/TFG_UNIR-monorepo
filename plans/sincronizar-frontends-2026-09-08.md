# Plan: Sincronizar librerías comunes de los 3 frontends

**Creado:** 2026-09-08 · **Estado:** Pendiente de aprobación de decisiones abiertas

## Estado actual (auditoría)

- Submódulos limpios, cada uno en el último commit de `main` (fix CI "secrets in if conditions").
- ⚠️ Punteros de submódulos del superproyecto desactualizados (los 3 marcados `+`).
- ⚠️ `vue3/package.json` en `0.2.0` pero 8 commits tras el tag `v0.2.1`.
- ⚠️ Tabla de versiones del `AGENTS.md` raíz obsoleta.

| Librería | Angular | React | Vue3 | Objetivo |
|---|---|---|---|---|
| TypeScript | 5.9.3 | 5.9.3 | 5.9.3 | ✅ ya sincronizado |
| axios | 1.18.1 | 1.18.1 | spec `^1.18.0` | spec `^1.18.1` en vue3 |
| sweetalert2 | 11.26.25 | 11.26.25 | 11.26.24 | `^11.26.25` en vue3 |
| eslint | spec `^9.27.0` | 9.39.3 | 9.39.4 | spec `^9.39.4` los 3 |
| cypress | lock 15.13.0 | 15.19.0 | 15.14.2 | `^15.19.0` los 3 |
| yup | — | spec `^1.6.1` (lock 1.7.1) | 1.7.1 | spec `^1.7.1` en react |
| @cypress/code-coverage | 3.13.4 | 4.0.3 | 3.14.7 | **pendiente de decisión** |
| nyc / istanbul-lib-coverage / lcov-result-merger | 17.1.0 / 3.2.2 / 5.0.1 | idem | idem | ✅ ya sincronizado |

## Fase 1 — Sincronizar librerías (1 PR por submódulo)

Regla: usar siempre `pnpm up '<pkg>@<spec>'` (nunca editar `package.json` a mano en Angular, según su AGENTS.md) para mantener `pnpm-lock.yaml` coherente.

### angular/
- [ ] `pnpm up 'cypress@^15.19.0'`
- [ ] `pnpm up 'eslint@^9.39.4'`
- [ ] Verificar overrides `pnpm.overrides` siguen vigentes tras el bump

### react/
- [ ] Cambiar spec `yup` a `^1.7.1` vía `pnpm up 'yup@^1.7.1'`
- [ ] `pnpm up 'eslint@^9.39.4'`

### vue3/
- [ ] `pnpm up 'sweetalert2@^11.26.25'`
- [ ] `pnpm up 'axios@^1.18.1'`
- [ ] `pnpm up 'cypress@^15.19.0'` y después `pnpm cypress install`
- [ ] `pnpm up '@cypress/code-coverage'` (ver Decisión 1)

### Verificación por proyecto (pre-commit de cada AGENTS.md)

```bash
# angular
pnpm run lint && pnpm run test-headless-cc && pnpm run build   # cobertura ≥80%

# react
pnpm lint && pnpm test-headless && pnpm cypress:component && pnpm build

# vue3
pnpm lint && pnpm type-check && pnpm test-headless && pnpm cypress:component && pnpm build
```

Ramas: `chore/deps-sync-common-libs` en cada submódulo → PR → merge.

## Fase 2 — Versiones de proyecto y docs locales

- [ ] `vue3/package.json`: `0.2.0` → `0.2.2`
- [ ] `vue3/README.md:374`: "Versión: 0.2.0" → `0.2.2`
- [ ] `react/README.md:319`: "Versión: 0.2.0" → `0.2.2`
- [ ] Actualizar sección "Dependencies" de `react/AGENTS.md` y tablas equivalentes en AGENTS.md/README de angular y vue3 con las nuevas versiones

## Fase 3 — Docs del superproyecto

- [ ] `AGENTS.md` raíz, tabla: Angular 21.2.19 · Next 16.2.12 / React 19.2.8 · Vue 3.5.33 / Vite 7.3.5
- [ ] Actualizar fecha "Última actualización de este índice"
- [ ] Verificar `README.md` raíz (ya muestra 21.2.19 / 19.2.8 / 3.5.33 — solo revisar menciones de Vite/pnpm)

## Fase 4 — Punteros de submódulos + verificación global

1. [ ] Tras mergear los 3 PRs: `./scripts/update-all.sh` (o fetch + checkout `main` en cada submódulo)
2. [ ] Staged de los 3 gitlinks + commit: `chore(deps): sincronizar librerías comunes y punteros de submódulos`
3. [ ] Gate final: `./scripts/test-all.sh`
4. [ ] (Opcional) Tags `v0.2.2` en el submódulo vue3 si el equipo lo usa

## Decisiones abiertas

1. **`@cypress/code-coverage`**: React en v4 (`^4.0.3`), Angular/Vue3 en v3.
   → Opción recomendada: subir Angular+Vue3 a `^4` y verificar scripts de cobertura (`cypress:component:coverage`). Alternativa: dejar divergencia.
2. **Cypress en Angular**: el AGENTS.md local avisa de limitaciones de component testing con Angular 21; el plan solo toca la versión de la librería, no los tests. Confirmar OK.

## Notas

- `pnpm audit` da HTTP 410 (endpoint retirado) en react → usar `pnpm outdated` / `./scripts/security-audit.sh`.
- Tras cambiar versión de Cypress, puede requerir `pnpm cypress install` (quirky documented en react/AGENTS.md).
