# Automatización de Actualización de Submodules

Este documento explica cómo funcionan las actualizaciones automáticas de submodules en el monorepo.

## 🔄 Cómo Funcionan los Submodules

Los submodules en Git son **referencias a commits específicos**, no a ramas. Esto significa que:

- ❌ **NO se actualizan automáticamente** cuando haces push a los repos individuales
- ✅ **Debes actualizar manualmente** el monorepo para apuntar a nuevos commits
- 🤖 **Podemos automatizar** este proceso con GitHub Actions

## 🤖 Automatización Implementada

### Workflow del Monorepo

**Archivo**: `.github/workflows/update-submodules.yml`

**Se ejecuta cuando:**
1. ⏰ **Programado**: Cada 6 horas automáticamente
2. 🔘 **Manual**: Desde la pestaña Actions → "Update Submodules" → Run workflow
3. 📡 **Repository Dispatch**: Cuando un repo individual lo notifica
4. 📝 **Push a main**: Para verificar el estado actual

**Qué hace:**
1. Hace checkout del monorepo con submodules
2. Ejecuta `git submodule update --remote --merge`
3. Si hay cambios, hace commit y push automáticamente
4. Genera logs detallados de los cambios

### Opciones de Actualización

#### Opción 1: Automática Programada (Implementada) ⭐
- **Ventaja**: No requiere configuración en repos individuales
- **Desventaja**: Puede tardar hasta 6 horas en detectar cambios
- **Uso**: Ideal para desarrollo normal

#### Opción 2: Trigger Manual
```bash
# Desde GitHub UI
1. Ve a Actions en el monorepo
2. Selecciona "Update Submodules"
3. Click en "Run workflow"
```

#### Opción 3: Trigger desde Repos Individuales (Opcional)

Para actualización inmediata, añade este workflow a cada repo individual:

**Archivo**: `.github/workflows/notify-monorepo.yml`

```yaml
name: Notify Monorepo

on:
  push:
    branches:
      - main
  pull_request:
    types: [closed]
    branches:
      - main

jobs:
  notify:
    if: github.event_name == 'push' || (github.event.pull_request.merged == true)
    runs-on: ubuntu-latest
    steps:
      - name: Trigger monorepo update
        run: |
          curl -X POST \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token ${{ secrets.MONOREPO_PAT }}" \
            https://api.github.com/repos/isidromerayo/TFG_UNIR-monorepo/dispatches \
            -d '{"event_type":"submodule-updated","client_payload":{"repo":"${{ github.repository }}","ref":"${{ github.ref }}"}}'
```

**Requisitos para Opción 3:**
1. Crear un Personal Access Token (PAT) con permisos `repo`
2. Añadirlo como secret `MONOREPO_PAT` en cada repo individual
3. Añadir el workflow a cada repo

## 📋 Actualización Manual

Si prefieres control total, actualiza manualmente:

```bash
# 1. Ir al monorepo
cd TFG_UNIR-monorepo

# 2. Actualizar todos los submodules
git submodule update --remote --merge

# 3. Ver qué cambió
git status
git diff

# 4. Commit y push
git add .
git commit -m "chore: update submodules to latest versions"
git push
```

## 🔍 Verificar Estado de Submodules

```bash
# Ver commits actuales de submodules
git submodule status

# Ver si hay actualizaciones disponibles
git submodule update --remote --dry-run

# Ver diferencias
git diff --submodule
```

## 📊 Frecuencia de Actualización Recomendada

| Escenario | Método | Frecuencia |
|-----------|--------|------------|
| **Desarrollo activo** | Automático programado | Cada 6 horas |
| **Pre-release** | Manual | Antes de cada release |
| **Producción** | Manual | Solo para releases estables |
| **Hotfix urgente** | Manual inmediato | Según necesidad |

## 🎯 Mejores Prácticas

### ✅ Hacer

1. **Revisar cambios** antes de mergear PRs en repos individuales
2. **Esperar a que pasen los tests** antes de actualizar submodules
3. **Documentar cambios importantes** en commits del monorepo
4. **Usar tags/releases** para versiones estables
5. **Verificar CI** del monorepo después de actualizar

### ❌ Evitar

1. **No actualizar submodules** sin revisar los cambios
2. **No hacer push directo** a submodules desde el monorepo
3. **No mezclar** actualizaciones de submodules con otros cambios
4. **No ignorar** fallos de CI en repos individuales

## 🔧 Troubleshooting

### Problema: Submodules no se actualizan

```bash
# Forzar actualización
git submodule update --init --recursive --remote --force
```

### Problema: Conflictos en submodules

```bash
# Reset a la versión remota
cd submodule_name
git fetch origin
git reset --hard origin/main
cd ..
git add submodule_name
```

### Problema: Submodule en estado detached HEAD

Esto es **normal** y esperado. Los submodules siempre están en detached HEAD porque apuntan a commits específicos, no a ramas.

## 📚 Referencias

- [Git Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Actions - Repository Dispatch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#repository_dispatch)
- [GitHub Actions - Schedule](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)

## 🤝 Contribución

Si encuentras formas de mejorar la automatización, por favor:
1. Documenta el cambio propuesto
2. Prueba en un fork primero
3. Crea una PR con la mejora

---

**Última actualización**: Diciembre 2024  
**Mantenedor**: Isidro Merayo
