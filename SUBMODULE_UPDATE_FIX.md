# Fix: Submodule Update "Unrelated Histories" Error

## 🐛 Problema

El workflow de GitHub Actions fallaba con el siguiente error:

```
fatal: refusing to merge unrelated histories
fatal: Unable to merge 'a16dd2fb9f433f07911123f43d3ab3da32d2f639' in submodule path 'backend'
Error: Process completed with exit code 128.
```

### Causa Raíz

El problema ocurría porque:

1. **Submódulo en Detached HEAD**: El backend estaba en un commit específico (`cf91e9e`) en lugar de estar en una rama
   ```
   cf91e9e4dcb00061e008173be3f2f8cba318dbe9 backend (cf91e9e)  ❌ Detached HEAD
   715404224ffe85a3315e4f66da1306a25be5020d angular (heads/main) ✅ En rama
   ```

2. **Falta de configuración de rama**: Los submódulos no tenían configurada la rama en `.gitmodules`

3. **Estrategia de merge incorrecta**: `git submodule update --remote --merge` intentaba hacer merge sin una rama base válida

## ✅ Solución Implementada

### 1. Configurar Ramas en `.gitmodules`

Añadimos `branch = main` a cada submódulo:

```diff
[submodule "backend"]
    path = backend
    url = https://github.com/isidromerayo/TFG_UNIR-backend.git
+   branch = main
```

Esto le dice a Git qué rama seguir para cada submódulo.

### 2. Cambiar Estrategia de Actualización

**Antes** (fallaba):
```bash
git submodule update --remote --merge
```

**Después** (funciona):
```bash
# Para cada submódulo:
cd $submodule
git fetch origin
git checkout main
git pull origin main --ff-only || git reset --hard origin/main
```

### 3. Workflow Mejorado

El nuevo workflow:

1. **Itera sobre cada submódulo** individualmente
2. **Hace checkout a la rama** configurada (main)
3. **Hace pull con --ff-only** (fast-forward only)
4. **Fallback a reset --hard** si el pull falla
5. **Maneja detached HEAD** automáticamente

## 🔍 Ventajas de la Nueva Solución

| Aspecto | Antes | Después |
|---------|-------|---------|
| **Manejo de errores** | Falla todo si un submódulo falla | Continúa con otros submódulos |
| **Detached HEAD** | ❌ Causa errores | ✅ Se corrige automáticamente |
| **Historias no relacionadas** | ❌ Falla con error | ✅ Se maneja con reset |
| **Visibilidad** | Mensaje genérico | Logs detallados por submódulo |
| **Recuperación** | Manual | Automática |

## 🧪 Testing

### Verificar Estado Actual

```bash
cd TFG_UNIR-monorepo
git submodule status
```

**Salida esperada** (todos en rama main):
```
 715404224ffe85a3315e4f66da1306a25be5020d angular (heads/main)
 cf91e9e4dcb00061e008173be3f2f8cba318dbe9 backend (heads/main)
 58649296d822d127ccb4db55025de72a442117a3 react (heads/main)
 1fc65f9e0ba357f08d7f8c0af9ba4db718d174ad vue3 (heads/main)
```

### Actualizar Manualmente

```bash
# Actualizar todos los submódulos
git submodule update --remote

# Verificar que están en la rama correcta
git submodule foreach 'git branch'
```

### Probar el Workflow

1. Ve a GitHub Actions
2. Ejecuta manualmente "Update Submodules"
3. Verifica que completa sin errores

## 📝 Comandos Útiles

### Ver configuración de submódulos
```bash
cat .gitmodules
```

### Ver estado detallado
```bash
git submodule status
git submodule foreach 'echo "=== $name ===" && git status'
```

### Forzar actualización de un submódulo específico
```bash
cd backend
git fetch origin
git checkout main
git reset --hard origin/main
cd ..
git add backend
git commit -m "chore: update backend submodule"
```

### Sincronizar URLs de submódulos
```bash
git submodule sync --recursive
```

## 🔄 Flujo de Actualización Automática

1. **Trigger**: Cada 6 horas, manual, o cuando un repo hijo hace push
2. **Fetch**: Obtiene últimos cambios de cada submódulo
3. **Checkout**: Asegura que está en la rama main
4. **Pull**: Actualiza con fast-forward
5. **Commit**: Si hay cambios, hace commit automático
6. **Push**: Sube los cambios al monorepo

## 🚨 Troubleshooting

### Si un submódulo sigue en detached HEAD

```bash
cd <submodulo>
git checkout main
git pull origin main
cd ..
git add <submodulo>
git commit -m "fix: checkout submodule to main branch"
git push
```

### Si hay conflictos

```bash
cd <submodulo>
git fetch origin
git reset --hard origin/main
cd ..
git add <submodulo>
git commit -m "fix: reset submodule to origin/main"
git push
```

### Si el workflow sigue fallando

1. Verifica que `.gitmodules` tiene `branch = main` para todos
2. Verifica que los submódulos existen en GitHub
3. Verifica permisos del token de GitHub Actions
4. Revisa los logs detallados en GitHub Actions

## 📚 Referencias

- [Git Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Actions - Checkout Action](https://github.com/actions/checkout)
- [Git Submodule Best Practices](https://git-scm.com/docs/gitsubmodules)

## ✅ Checklist de Verificación

- [x] `.gitmodules` tiene `branch = main` para todos los submódulos
- [x] Workflow actualizado con nueva estrategia
- [x] Submódulos en rama main (no detached HEAD)
- [x] Workflow probado manualmente
- [x] Documentación actualizada

---

**Fecha de fix**: 2025-12-06  
**Commits relacionados**:
- `dcbe73d` - Initial workflow improvement
- `7698403` - Configure branches and improve strategy
