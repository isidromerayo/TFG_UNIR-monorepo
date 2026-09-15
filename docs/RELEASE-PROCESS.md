# 🚀 Runbook de Releases — Monorepo TFG UNIR

**Última actualización:** 2026-09-15 · **Aplica a:** `angular/`, `react/`, `vue3/`, `backend/`

Este runbook centraliza el flujo de release que hasta ahora estaba disperso en los `AGENTS.md` de cada submódulo. Cualquier nueva versión de un proyecto debe recorrer estos pasos, en orden.

## 1. Disparador: nueva versión en `package.json`

El bump de versión **no se edita a mano en un commit suelto**: se hace siempre en una rama `release/X.Y.Z` (o formando parte de una rama de trabajo si es menor), ya sea:
- manualmente (`package.json` + `README.md` footer + requerimientos),
- o vía release tooling del subproyecto si lo hubiera.

## 2. Rama `release/X.Y.Z`

- Crear desde `main` **actualizado** (`git pull --ff-only`).
- Cambiar versión en `package.json` y sincronizar el footer "Versión" del `README.md` (política de docs: README debe coincidir con `package.json`).
- Revisar `AGENTS.md`/README con datos de stack/toochain si cambian.
- `CHANGELOG.md` o notas: opcional; las release notes de GitHub cubren el histórico.

## 3. Pre-commit (obligatorio, consulta el AGENTS.md local)

```bash
# angular
pnpm install --frozen-lockfile && pnpm lint && pnpm test-headless-cc && pnpm build
# react
pnpm lint && pnpm test-headless && pnpm cypress:component && pnpm build
# vue3
pnpm lint && pnpm type-check && pnpm test-headless && pnpm cypress:component && pnpm build
# backend
./mvnw test
```

## 4. PR `release/X.Y.Z` → `main`

- Título convencional: `chore(release): bump version to X.Y.Z`
- Esperar CI verde (checks obligatorios del repo, incluida sonarqube/security).
- Merge (squash preferente).

## 5. Tag desde `main` actualizado

- ⚠️ **Nunca** puntear el tag desde la rama `release/*`: el tag se crea **siempre** desde `main` tras el merge (regla común en angular/react/vue3).
- **Convención de nombres (obligatoria, sin excepciones desde 2026-09-15):** tag `vX.Y.Z` Y el título/nombre de la GitHub Release también `vX.Y.Z` — la unificación histórica ya se aplicó (tags con prefijo ya existían; renombrados los títulos `0.2.0` de angular y vue3).
- `git tag vX.Y.Z && git push origin vX.Y.Z`

## 6. GitHub Release

- **Obligatorio**: crear la Release desde el tag (`gh release create vX.Y.Z --verify-tag --generate-notes`, o notas manuales por secciones Security/Feature/Fix) **y publicarla en la misma sesión** — una release en draft es fácil que quede huérfana; la política vigente es no dejar drafts abiertos.
- Los drafts históricos `v0.2.1` de angular y react quedan como legado (decisión: se obvian, sin acción).

## 7. Puntero en el monorepo

- En el monorepo: `git submodule update --remote <repo>` + commit del gitlink en `main` (PR si cambia algo más).
- Si procede, refrescar la tabla de versiones del `AGENTS.md` raíz.
- Si hay doc asociada (plan en `plans/`), marcar la fase como completada.

## Checklist exprés

- [ ] `release/X.Y.Z` desde `main` actualizado
- [ ] `package.json` + README footer sincronizados
- [ ] Pre-commit/CI verde
- [ ] PR merged (squash) a `main`
- [ ] Tag `vX.Y.Z` creado **desde `main`** y pusheado
- [ ] GitHub Release publicada (no draft) con notas
- [ ] Puntero de submódulo avanzado en el monorepo + docs refrescadas

## Deuda conocida (auditoría 2026-09-15)

- ~ Releases `v0.2.1` **en Draft** en `TFG_UNIR-angular` y `TFG_UNIR-react` (feb 2026): **se obvian por decisión** (el resto está publicado); sin acción.
- ✅ **[Hecho 2026-09-15]** Unificación del prefijo `v`: todos los tags ya usaban `vX.Y.Z`; se renombraron los títulos de release `0.2.0` → `v0.2.0` (angular y vue3). React solo conserva tags `v*`.
- ✅ **[Hecho 2026-09-15]** Release `v0.2.2` de vue3 creada y publicada (el tag existía sin GitHub Release) — marcada Latest automáticamente.
- Desalineación angular main↔tag: `v0.2.3` (release ago 2026) sigue en `package.json` 0.2.3 pero `main` acumula ~21 commits (incluye pa11y y sync deps); sin bump, el tag no refleja el `main` actual — esperar al próximo `release/0.2.4` para regularizar.
- `backend`: `v0.7.1-6-ga7813e1` → 6 commits tras su tag; bump pendiente de decidir (fuera de frontends).
- No hay workflow automático de release (`release-please`/`semantic-release`); todo el flujo es manual — este runbook es su estándar. Considerarlo como posible mejora (opt-in).
