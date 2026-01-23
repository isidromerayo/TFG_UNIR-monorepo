# Análisis de Despliegue Frontend (Monorepo TFG)

## 🎯 Objetivo
Identificar la mejor estrategia de despliegue gratuito para **tres frontends** (Angular, React/Next.js, Vue3) integrando CI/CD con GitHub Actions y conectando con el backend real en `https://tfg.estilolibre.eu/api`.

---

## 🏗️ El Desafío de los "Tres Frontends"
En un monorepo con tres proyectos distintos, necesitamos una plataforma que permita:
1.  **Múltiples Sitios**: Alojar al menos 3 sitios independientes desde el mismo repositorio.
2.  **Configuración de Rutas**: Manejar subcarpetas (`angular/`, `react/`, `vue3/`) como raíces de build.

---

## 📊 Comparativa Detallada

### 1. GitHub Pages (La opción del ecosistema)
*   **Ventajas ✅**:
    *   **Coste**: 100% gratuito sin límites de "proyectos" (puedes tener uno por repositorio, o usar carpetas/ramas).
    *   **Integración**: Máxima con GitHub Actions.
    *   **Simplicidad**: No requiere cuentas externas.
*   **Inconvenientes ❌**:
    *   **Next.js limitado**: Solo permite despliegue estático (`next export`). **Pierdes SSR/ISR** y las API Routes si las usaras.
    *   **SPA Routing**: Requiere el truco del `404.html` para que las rutas internas (ej: `/mis-cursos`) funcionen al recargar, o usar `HashLocationStrategy`.
    *   **Monorepo**: Desplegar 3 apps desde un solo repo a GH Pages requiere configurar rutas (ej: `user.github.io/angular/`, `user.github.io/react/`, etc.) lo cual complica los base-href.
*   **Veredicto**: Excelente para estáticos puros, limitada para frameworks modernos con SSR.

### 2. Vercel (Optimizado para Next.js)
*   **Ventajas ✅**:
    *   **Ilimitado**: Permite crear proyectos personales (Hobby) de forma ilimitada. Puedes crear `tfg-angular`, `tfg-react` y `tfg-vue` apuntando al mismo repo pero a carpetas diferentes.
    *   **Next.js Nativo**: Es el único que soporta el 100% de las características de React/Next.js sin configuración.
*   **Inconvenientes ❌**:
    *   Uso estrictamente no comercial (apropiado para el TFG).
*   **Veredicto**: La mejor opción para este monorepo específico por su flexibilidad con las 3 carpetas.

### 3. Cloudflare Pages (Ancho de banda infinito)
*   **Ventajas ✅**:
    *   **Sin límites de tráfico**: El más generoso en ancho de banda.
    *   **Previews**: Genera una URL por cada commit para los 3 proyectos.
*   **Inconvenientes ❌**:
    *   Configuración de Next.js es más compleja que en Vercel.
*   **Veredicto**: Muy potente si esperas mucho tráfico.

### 4. Azure Static Web Apps (Aclaración de límites)
*   **Ventajas ✅**: Integración Azure-GitHub.
*   **Inconvenientes ❌**: 
    *   **Límite Crítico**: El plan gratuito permite hasta **10 apps por suscripción**, pero la gestión de un monorepo con 3 carpetas raíz puede ser más engorrosa que en plataformas "frontend-first".
    *   **Complejidad**: Menos intuitivo para usuarios que no vienen del ecosistema Microsoft.
*   **Veredicto**: **Descartada** por preferencia del usuario y complejidad innecesaria para 3 frontends independientes.

---

## 🛠️ Resumen de Capacidades para 3 Frontends

| Servicio | Límite de Sitios (Gratis) | ¿Soporta Next.js SSR? | Dificultad Monorepo |
|----------|--------------------------|-----------------------|---------------------|
| **Vercel** | Ilimitados | **Sí (Excelente)** | Baja |
| **Netlify** | Ilimitados | Sí | Baja |
| **GitHub Pages** | 1 principal + N proyectos | **No (Solo estático)** | Media |
| **Cloudflare** | Ilimitados | Sí (via adapter) | Media |
| **Azure SWA** | 10 | Sí | Media-Alta |

---

## 💡 Recomendación Técnica Final

Dada la estructura del TFG con **3 frontends** y el uso de **Next.js 16**:

1.  **Vercel** sigue siendo el ganador técnico por su manejo de Next.js y su facilidad para configurar 3 proyectos independientes desde el mismo repo (`Root Directory` setting).
2.  **GitHub Pages** es la alternativa si buscas "permanencia absoluta" y no te importa perder las capacidades de servidor (SSR) de Next.js y aplicar parches para el routing de Angular/Vue.

### 🔧 Propuesta de Mejora en el Código (Independiente del hosting):
*   **Angular**: Añadir `APP_BASE_HREF` dinámico si se va a desplegar en subcarpetas de GitHub Pages.
*   **Variables de Entorno**: Crear un archivo `.github/workflows/deploy.yml` que use secretos de GitHub para inyectar la URL del backend: `https://tfg.estilolibre.eu/api`.

