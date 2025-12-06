# 🔒 Estado de Seguridad - Proyectos TFG UNIR

**Fecha de auditoría**: 6 de diciembre de 2025

---

## 📊 Resumen General

| Proyecto | Vulnerabilidades | Dependencias Desactualizadas | Estado |
|----------|------------------|------------------------------|--------|
| **React** | ✅ 0 | ⚠️ 9 | ✅ Seguro |
| **Angular** | ✅ 0 | ⚠️ 20 | ✅ Seguro |
| **Vue3** | ✅ 0 | ⚠️ 16 | ✅ Seguro |
| **TOTAL** | **✅ 0** | **⚠️ 45** | **✅ Seguro** |

---

## 🎯 Proyecto React (Next.js)

### Vulnerabilidades
```
✅ No known vulnerabilities found
```

### Dependencias Desactualizadas (9)

#### Actualizaciones Menores/Patches (Seguras)
| Paquete | Actual | Última | Tipo |
|---------|--------|--------|------|
| @types/node | 24.0.3 | 24.10.1 | Minor |
| eslint | 9.31.0 | 9.39.1 | Minor |
| react | 19.1.0 | 19.2.1 | Patch |
| react-dom | 19.1.0 | 19.2.1 | Patch |
| typescript | 5.8.3 | 5.9.3 | Minor |

#### Actualizaciones Mayores (Revisar Breaking Changes)
| Paquete | Actual | Última | Tipo |
|---------|--------|--------|------|
| cypress | 14.5.4 | 15.7.1 | Major |
| eslint-config-next | 15.4.8 | 16.0.7 | Major |
| next | 15.4.8 | 16.0.7 | Major |

### Recomendaciones

**Actualizaciones Seguras** (ejecutar ahora):
```bash
cd TFG_UNIR-react
pnpm update @types/node eslint react react-dom typescript
```

**Actualizaciones Mayores** (revisar changelog primero):
```bash
# Next.js 16 - REVISAR BREAKING CHANGES
# https://nextjs.org/docs/app/building-your-application/upgrading/version-16
pnpm update next eslint-config-next --latest

# Cypress 15 - REVISAR CHANGELOG
# https://docs.cypress.io/guides/references/changelog
pnpm update cypress --latest
```

**Verificar después de actualizar**:
```bash
pnpm lint
pnpm test-headless
pnpm build
```

---

## 🎯 Proyecto Angular

### Vulnerabilidades
```
✅ No known vulnerabilities found
```

### Dependencias Desactualizadas (20)

#### Actualizaciones Menores/Patches (Seguras)
| Paquete | Actual | Última | Tipo |
|---------|--------|--------|------|
| sweetalert2 | 11.4.8 | 11.26.4 | Minor |
| typescript | 5.8.3 | 5.9.3 | Minor |
| zone.js | 0.15.1 | 0.16.0 | Minor |

#### Actualizaciones Mayores (Revisar Breaking Changes)
| Paquete | Actual | Última | Tipo | Nota |
|---------|--------|--------|------|------|
| @angular/* | 20.3.15 | 21.0.3 | Major | Angular 21 |
| @angular/cli | 20.3.13 | 21.0.2 | Major | Angular 21 |
| @angular-devkit/build-angular | 20.3.13 | 21.0.2 | Major | Angular 21 |
| @sweetalert2/ngx-sweetalert2 | 12.4.0 | 14.1.0 | Major | |
| @types/jasmine | 4.6.5 | 5.1.13 | Major | |
| @cypress/schematic | 2.5.2 | 4.3.0 | Major | |
| cypress | 13.17.0 | 15.7.1 | Major | |
| jasmine-core | 4.6.1 | 5.13.0 | Major | |

### Recomendaciones

**Actualizaciones Seguras** (ejecutar ahora):
```bash
cd TFG_UNIR-angular
pnpm update sweetalert2 typescript zone.js
```

**Actualizaciones Mayores** (revisar changelog primero):
```bash
# Angular 21 - REVISAR BREAKING CHANGES
# https://angular.dev/update-guide
# Usar Angular Update Guide: https://update.angular.io/
pnpm update @angular/core @angular/cli --latest

# Cypress 15 - REVISAR CHANGELOG
pnpm update cypress @cypress/schematic --latest

# Jasmine 5 - REVISAR CHANGELOG
pnpm update jasmine-core @types/jasmine --latest

# SweetAlert2 - REVISAR CHANGELOG
pnpm update @sweetalert2/ngx-sweetalert2 --latest
```

**Verificar después de actualizar**:
```bash
pnpm lint
pnpm test
pnpm build
```

---

## 🎯 Proyecto Vue3

### Vulnerabilidades
```
✅ No known vulnerabilities found
```

### Dependencias Desactualizadas (16)

#### Deprecadas (Acción Requerida)
| Paquete | Actual | Estado |
|---------|--------|--------|
| @types/cypress | 1.1.6 | ⚠️ **DEPRECATED** - Cypress provee sus propios tipos |

**Acción**: Remover `@types/cypress`:
```bash
cd TFG_UNIR-vue3
pnpm remove @types/cypress
```

#### Actualizaciones Menores/Patches (Seguras)
| Paquete | Actual | Última | Tipo |
|---------|--------|--------|------|
| eslint-plugin-vue | 10.3.0 | 10.6.2 | Minor |
| prettier | 3.6.2 | 3.7.4 | Minor |
| typescript | 5.8.3 | 5.9.3 | Minor |
| @vue/tsconfig | 0.7.0 | 0.8.1 | Minor |

#### Actualizaciones Mayores (Revisar Breaking Changes)
| Paquete | Actual | Última | Tipo |
|---------|--------|--------|------|
| @types/jsdom | 21.1.7 | 27.0.0 | Major |
| @types/testing-library__jest-dom | 5.14.9 | 6.0.0 | Major |
| @vitejs/plugin-vue | 5.2.4 | 6.0.2 | Major |
| @vitest/coverage-v8 | 3.2.4 | 4.0.15 | Major |
| @vitest/ui | 3.2.4 | 4.0.15 | Major |
| cypress | 14.5.4 | 15.7.1 | Major |
| jsdom | 26.1.0 | 27.2.0 | Major |
| vite | 6.4.1 | 7.2.6 | Major |
| vite-plugin-vue-devtools | 7.7.9 | 8.0.5 | Major |
| vitest | 3.2.4 | 4.0.15 | Major |
| vue-tsc | 2.2.12 | 3.1.6 | Major |

### Recomendaciones

**Acción Inmediata** (remover deprecado):
```bash
cd TFG_UNIR-vue3
pnpm remove @types/cypress
git add package.json pnpm-lock.yaml
git commit -m "chore: remove deprecated @types/cypress"
```

**Actualizaciones Seguras** (ejecutar ahora):
```bash
pnpm update eslint-plugin-vue prettier typescript @vue/tsconfig
```

**Actualizaciones Mayores** (revisar changelog primero):
```bash
# Vite 7 - REVISAR BREAKING CHANGES
# https://vitejs.dev/guide/migration
pnpm update vite @vitejs/plugin-vue vite-plugin-vue-devtools --latest

# Vitest 4 - REVISAR CHANGELOG
# https://vitest.dev/guide/migration
pnpm update vitest @vitest/ui @vitest/coverage-v8 --latest

# Cypress 15 - REVISAR CHANGELOG
pnpm update cypress --latest

# jsdom 27 - REVISAR CHANGELOG
pnpm update jsdom @types/jsdom --latest

# vue-tsc 3 - REVISAR CHANGELOG
pnpm update vue-tsc --latest

# Testing Library - REVISAR CHANGELOG
pnpm update @types/testing-library__jest-dom --latest
```

**Verificar después de actualizar**:
```bash
pnpm type-check
pnpm lint
pnpm test-headless
pnpm build
```

---

## 🛡️ Estrategia de Actualización Recomendada

### Fase 1: Actualizaciones Seguras (Inmediato)

**Prioridad Alta**:
1. ✅ Remover `@types/cypress` deprecado en Vue3
2. ✅ Actualizar TypeScript a 5.9.3 en los 3 proyectos
3. ✅ Actualizar herramientas de linting (ESLint, Prettier)
4. ✅ Actualizar tipos (@types/*)

**Comandos**:
```bash
# Vue3
cd TFG_UNIR-vue3
pnpm remove @types/cypress
pnpm update eslint-plugin-vue prettier typescript @vue/tsconfig

# React
cd ../TFG_UNIR-react
pnpm update @types/node eslint react react-dom typescript

# Angular
cd ../TFG_UNIR-angular
pnpm update sweetalert2 typescript zone.js
```

### Fase 2: Actualizaciones Mayores (Planificado)

**Prioridad Media** (próxima semana):
1. 🔄 Cypress 15 (los 3 proyectos)
2. 🔄 Vite 7 (Vue3)
3. 🔄 Vitest 4 (Vue3)

**Prioridad Baja** (próximo mes):
1. 🔄 Next.js 16 (React) - Requiere revisión exhaustiva
2. 🔄 Angular 21 (Angular) - Requiere Angular Update Guide
3. 🔄 Jasmine 5 (Angular)

### Fase 3: Monitoreo Continuo

**Automatización**:
- ✅ Dependabot configurado (checks diarios)
- ✅ Security workflow (auditoría diaria)
- ✅ PRs automáticas de Dependabot

**Revisión Manual**:
- 📅 Semanal: Revisar PRs de Dependabot
- 📅 Mensual: Ejecutar `pnpm outdated` manualmente
- 📅 Trimestral: Actualizar dependencias mayores

---

## 📋 Checklist de Actualización

### Antes de Actualizar
- [ ] Leer changelog de la dependencia
- [ ] Revisar breaking changes
- [ ] Crear rama específica para la actualización
- [ ] Hacer backup del lockfile

### Durante la Actualización
- [ ] Ejecutar `pnpm update <package>`
- [ ] Revisar cambios en lockfile
- [ ] Ejecutar `pnpm install` para verificar

### Después de Actualizar
- [ ] `pnpm type-check` (si aplica)
- [ ] `pnpm lint`
- [ ] `pnpm test-headless`
- [ ] `pnpm build`
- [ ] Probar manualmente en desarrollo
- [ ] Commit con mensaje descriptivo
- [ ] Crear PR con descripción de cambios

---

## 🎯 Conclusiones

### Estado General
✅ **Excelente**: Los 3 proyectos tienen **0 vulnerabilidades conocidas**

### Acciones Recomendadas

**Inmediato** (hoy):
1. Remover `@types/cypress` deprecado en Vue3
2. Actualizar TypeScript a 5.9.3 en los 3 proyectos
3. Actualizar herramientas de linting

**Corto Plazo** (esta semana):
1. Actualizar Cypress a v15 en los 3 proyectos
2. Actualizar Vite a v7 en Vue3
3. Actualizar Vitest a v4 en Vue3

**Medio Plazo** (próximo mes):
1. Evaluar actualización a Next.js 16 (React)
2. Evaluar actualización a Angular 21 (Angular)
3. Revisar y aplicar actualizaciones menores pendientes

### Monitoreo
- ✅ Dependabot activo y generando PRs
- ✅ Security workflows ejecutándose diariamente
- ✅ Sin vulnerabilidades críticas detectadas

---

**Próxima revisión**: 13 de diciembre de 2025  
**Responsable**: @isidromerayo  
**Estado**: ✅ Todos los proyectos seguros
