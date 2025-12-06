# Configuración de Actualizaciones Instantáneas de Submodules

Esta guía explica cómo configurar notificaciones instantáneas desde los repositorios individuales al monorepo.

## 📊 Estado Actual

### ✅ Configurado (Funciona)
- ⏰ **Actualización automática cada 6 horas** (workflow programado)
- 🔘 **Trigger manual** desde GitHub Actions UI
- 📝 **Verificación en push** a main del monorepo

### ⏸️ NO Configurado (Opcional)
- 📡 **Notificación instantánea** desde repos individuales

## 🚀 Configurar Notificaciones Instantáneas (Opcional)

Si quieres que el monorepo se actualice **inmediatamente** cuando haces merge de una PR en React/Vue3/Angular, sigue estos pasos:

### Paso 1: Crear Personal Access Token (PAT)

1. Ve a GitHub → **Settings** (tu perfil, no el repo)
2. **Developer settings** → **Personal access tokens** → **Tokens (classic)**
3. Click **Generate new token** → **Generate new token (classic)**
4. Configuración del token:
   - **Note**: `Monorepo Submodule Updates`
   - **Expiration**: 90 days (o lo que prefieras)
   - **Scopes**: Marca solo `repo` (acceso completo a repositorios)
5. Click **Generate token**
6. **⚠️ IMPORTANTE**: Copia el token ahora, no podrás verlo después

### Paso 2: Añadir el Token como Secret en Cada Repo

Repite esto para **cada repositorio individual** (React, Vue3, Angular):

1. Ve al repositorio (ej: TFG_UNIR-react)
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Configuración:
   - **Name**: `MONOREPO_PAT`
   - **Secret**: Pega el token que copiaste
5. Click **Add secret**

### Paso 3: Crear el Workflow en Cada Repo

Crea este archivo en cada repositorio individual:

**Archivo**: `.github/workflows/notify-monorepo.yml`

```yaml
name: Notify Monorepo on Main Update

on:
  push:
    branches:
      - main
  pull_request:
    types: [closed]
    branches:
      - main

jobs:
  notify-monorepo:
    # Solo ejecutar si es push directo a main O si la PR fue mergeada
    if: github.event_name == 'push' || (github.event.pull_request.merged == true)
    runs-on: ubuntu-latest
    
    steps:
      - name: Get repository name
        id: repo
        run: |
          REPO_NAME=$(echo ${{ github.repository }} | cut -d'/' -f2)
          echo "name=$REPO_NAME" >> $GITHUB_OUTPUT
      
      - name: Trigger monorepo submodule update
        run: |
          echo "🔔 Notifying monorepo about update in ${{ steps.repo.outputs.name }}"
          
          curl -X POST \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token ${{ secrets.MONOREPO_PAT }}" \
            https://api.github.com/repos/isidromerayo/TFG_UNIR-monorepo/dispatches \
            -d '{
              "event_type": "submodule-updated",
              "client_payload": {
                "repo": "${{ github.repository }}",
                "repo_name": "${{ steps.repo.outputs.name }}",
                "ref": "${{ github.ref }}",
                "sha": "${{ github.sha }}",
                "triggered_by": "${{ github.actor }}"
              }
            }'
          
          echo "✅ Notification sent to monorepo"
      
      - name: Summary
        run: |
          echo "### 🔔 Monorepo Notification Sent" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "- **Repository**: ${{ steps.repo.outputs.name }}" >> $GITHUB_STEP_SUMMARY
          echo "- **Commit**: ${{ github.sha }}" >> $GITHUB_STEP_SUMMARY
          echo "- **Triggered by**: ${{ github.actor }}" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "The monorepo will update this submodule automatically." >> $GITHUB_STEP_SUMMARY
```

### Paso 4: Commit y Push

Para cada repositorio:

```bash
# React
cd TFG_UNIR-react
git checkout main
git pull
# Crear el archivo .github/workflows/notify-monorepo.yml con el contenido de arriba
git add .github/workflows/notify-monorepo.yml
git commit -m "feat: add monorepo notification workflow"
git push

# Vue3
cd TFG_UNIR-vue3
git checkout main
git pull
# Crear el archivo .github/workflows/notify-monorepo.yml
git add .github/workflows/notify-monorepo.yml
git commit -m "feat: add monorepo notification workflow"
git push

# Angular
cd TFG_UNIR-angular
git checkout main
git pull
# Crear el archivo .github/workflows/notify-monorepo.yml
git add .github/workflows/notify-monorepo.yml
git commit -m "feat: add monorepo notification workflow"
git push
```

## 🧪 Probar la Configuración

1. Haz un cambio pequeño en cualquier repo (ej: actualizar README)
2. Crea una PR y mergéala a main
3. Ve a **Actions** en ese repo → deberías ver "Notify Monorepo on Main Update" ejecutándose
4. Ve a **Actions** en el monorepo → deberías ver "Update Submodules" ejecutándose automáticamente
5. Verifica que el submodule se actualizó en el monorepo

## 📊 Comparación de Opciones

| Característica | Sin Notificación | Con Notificación |
|----------------|------------------|------------------|
| **Configuración** | ✅ Ya está | ⚙️ Requiere PAT |
| **Tiempo de actualización** | ⏰ Hasta 6 horas | ⚡ ~1 minuto |
| **Mantenimiento** | 🟢 Ninguno | 🟡 Renovar PAT cada 90 días |
| **Complejidad** | 🟢 Simple | 🟡 Media |
| **Recomendado para** | Desarrollo normal | Releases urgentes |

## 🎯 Recomendación

### Para Desarrollo Normal
**NO configurar notificaciones instantáneas**. La actualización cada 6 horas es suficiente y no requiere mantenimiento.

### Para Producción/Releases
**Configurar notificaciones instantáneas** si necesitas que los cambios se reflejen inmediatamente en el monorepo.

### Alternativa Híbrida (Recomendada)
- Usar actualización automática cada 6 horas para desarrollo
- Usar trigger manual cuando necesites actualización inmediata
- Configurar notificaciones solo si haces releases frecuentes

## 🔒 Seguridad del PAT

### ✅ Buenas Prácticas
- Usa tokens con **mínimos permisos** necesarios (solo `repo`)
- Configura **expiración** (90 días recomendado)
- **Renueva** el token antes de que expire
- **Revoca** tokens viejos después de renovar
- **No compartas** el token con nadie
- **No lo commits** en el código

### 🔄 Renovar el Token

Cuando el token expire:
1. Genera un nuevo token (Paso 1)
2. Actualiza el secret en cada repo (Paso 2)
3. No necesitas cambiar los workflows

## 🐛 Troubleshooting

### Error: "Bad credentials"
- El PAT expiró o es inválido
- Verifica que el secret `MONOREPO_PAT` existe en el repo
- Genera un nuevo PAT y actualiza el secret

### Error: "Resource not accessible by integration"
- El PAT no tiene permisos `repo`
- Genera un nuevo PAT con el scope correcto

### El workflow no se ejecuta
- Verifica que el archivo está en `.github/workflows/`
- Verifica que el evento es `push` a `main` o PR mergeada
- Revisa los logs en Actions

### El monorepo no se actualiza
- Verifica que el workflow "Update Submodules" se ejecutó en el monorepo
- Revisa los logs del workflow en el monorepo
- Puede haber un delay de ~30 segundos

## 📚 Referencias

- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub Repository Dispatch](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

**Última actualización**: Diciembre 2024  
**Estado**: Documentación completa, configuración opcional
