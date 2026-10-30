# Tasks

## 1. React — infraestructura pa11y

- [x] 1.1 Añadir devDeps con `pnpm up`/`pnpm add -D` (`pa11y ^10.0.0`, `pa11y-ci ^4.1.1`, `pa11y-ci-reporter-html ^8.1.1`) y verificar `pnpm install --frozen-lockfile` OK.
- [x] 1.2 Crear `react/.pa11yci` con WCAG2AA, runners htmlcs+axe, `levelCapWhenNeedsReview: warning`, Chrome del sistema, reporters cli+json+html → `./reports/a11y/`, URLs: `/`, `/categorias`, `/categoria/2`, `/curso/12`, `/carrito`, `/acceso`, `/registro`, `/ruta-inexistente` (puerto 3000) y verificar `cat` válido.
- [x] 1.3 Añadir `"a11y": "pa11y-ci"` a `package.json` y `/reports` a `.gitignore`; verificar `pnpm run a11y --help` resuelve.
- [x] 1.4 Documentar en `react/AGENTS.md` (comando + gotcha Chrome) y `README.md` (prerequisito backend `:8080`).

## 2. React — corrección de hallazgos

- [x] 2.1 Eliminar `aria-label` duplicados en `pages/registro.tsx` (label-in-name, SC 2.5.3) y verificar `pnpm run a11y` sin esos errores.
- [x] 2.2 Ajustar contraste del navbar (rgba ≥ .85 sobre fondo rojo) y verificar pa11y 0 errores de contraste.
- [x] 2.3 Añadir `text-decoration: underline` a enlaces inline del listado de categorías (SC 1.4.1) y verificar pa11y.
- [x] 2.4 Ejecutar gate del repo (`pnpm lint && pnpm test-headless && pnpm cypress:component && pnpm build`) en verde.

## 3. Vue3 — infraestructura pa11y

- [x] 3.1 Añadir devDeps alineadas y verificar instalación.
- [x] 3.2 Crear `vue3/.pa11yci` con mismas opciones, URLs con `/home` y `/ruta-inexistente` (puerto 5173) y verificar JSON válido.
- [x] 3.3 Añadir `"a11y": "pa11y-ci"` y `/reports` a `.gitignore`; verificar script.
- [x] 3.4 Documentar en `vue3/AGENTS.md` y `README.md`.

## 4. Vue3 — corrección de hallazgos

- [x] 4.1 Revisar labels en `RegistroComponent`/`AccesoComponent` (huérfanos/duplicados) y verificar pa11y.
- [x] 4.2 Ajustar contraste navbar y overlay del hero (`::before` con rgba plano) y verificar pa11y.
- [x] 4.3 Añadir subrayado a enlaces inline y verificar pa11y.
- [x] 4.4 Ejecutar gate del repo (`pnpm lint && pnpm type-check && pnpm test-headless && pnpm cypress:component && pnpm build`) en verde.

## 5. Monorepo — orquestador

- [x] 5.1 Añadir `reports/` a `.gitignore` del monorepo.
- [x] 5.2 Crear `scripts/a11y-audit.sh`: preflight backend `:8080`, mapeo comando/puerto por proyecto, espera de puerto con timeout 120 s, ejecución de `pnpm run a11y`, copia de `reports/a11y/` a `reports/a11y/<proyecto>/`, parseo de `report.json` para resumen comparativo, trap de limpieza, advisory (exit 0 si arranque OK).
- [x] 5.3 Verificar que `./scripts/a11y-audit.sh` genera los 3 árboles de informes con backend arriba.
- [x] 5.4 Documentar en `AGENTS.md` (Comandos Globales) y `README.md` del monorepo.

## 6. Coordinación e integración

- [x] 6.1 Actualizar punteros de submódulos en el monorepo tras merge de PRs de React/Vue y verificar `git submodule status`.
- [x] 6.2 Revisar `./scripts/check-accepted-advisories.sh` (sin cambios esperados) y confirmar gates verdes en los 3 frontends.
" path="/home/isidromerayo/projects/TFG_UNIR-multi/TFG_UNIR-monorepo/openspec/changes/add-pa11y-frontend-audits/tasks.md