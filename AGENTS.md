# 🤖 AGENTS.md - Contexto Global del Monorepo TFG UNIR

Este archivo sirve como punto de entrada para Agentes de Inteligencia Artificial que operan en el monorepo. Proporciona una visión general y redirige a la documentación específica de cada submódulo.

## 📋 Descripción del Monorepo

Este repositorio contiene la implementación de una plataforma de cursos online (TFG) utilizando cuatro tecnologías diferentes para fines comparativos:

- **Backend**: Java con Spring Boot.
- **Frontend 1**: Angular.
- **Frontend 2**: React (Next.js).
- **Frontend 3**: Vue 3.

## 🗺️ Mapa de Navegación

Para instrucciones detalladas, reglas de codificación y comandos específicos, consulta el `AGENTS.md` de cada proyecto:

| Proyecto | Tecnología Principal | Versión Actual | Ruta a Docs |
|----------|----------------------|----------------|-------------|
| **Backend** | Spring Boot / Java | 3.5.16 / 21 | [backend/AGENTS.md](./backend/AGENTS.md) |
| **Angular** | Angular / TypeScript | 21.2.11 | [angular/AGENTS.md](./angular/AGENTS.md) |
| **React** | Next.js / React | 16.2.4 / 19.2.4 | [react/AGENTS.md](./react/AGENTS.md) |
| **Vue3** | Vue 3 / Vite | 3.5.33 / 7.3.2 | [vue3/AGENTS.md](./vue3/AGENTS.md) |

> **⚠️ IMPORTANTE**: Antes de realizar cambios en un submódulo, LEE SIEMPRE su archivo `AGENTS.md` específico.

## ⚡ Comandos Globales

El monorepo cuenta con scripts para facilitar tareas comunes a nivel global.

### Testing Global
Ejecuta los tests de TODOS los proyectos (Backend + 3 Frontends):
```bash
./scripts/test-all.sh
```

### Actualización de Submódulos
Sincroniza todos los submódulos con sus ramas remotas:
```bash
./scripts/update-all.sh
```

### Auditoría de Seguridad
Ejecuta un análisis de seguridad en todos los proyectos:
```bash
./scripts/security-audit.sh
```

## 🔄 Flujo de Trabajo Recomendado para Agentes

1.  **Identificar el Ámbito**: Determina en qué submódulo(s) necesitas realizar cambios.
2.  **Leer Documentación Específica**:
    *   Si trabajas en `backend/`, lee `backend/AGENTS.md`.
    *   Si trabajas en `angular/`, lee `angular/AGENTS.md`.
    *   Etc.
3.  **Seguir Reglas Locales**: Cada proyecto tiene sus propios comandos de test, build y linting. **ÚSALOS**.
    *   *Ejemplo*: Vue3 usa `pnpm type-check`, mientras que Backend usa `./mvnw spotbugs:check`.
4.  **Verificación**: Antes de confirmar cambios, asegúrate de que los tests pasen en el módulo modificado.

## 🛠️ Tecnologías Comunes

- **Gestión de Paquetes (Frontend)**: `pnpm` es el estándar para React y Vue3. Angular utiliza `pnpm` (versión 10.24.0). Verifica siempre el `package.json` local.
- **Base de Datos**: PostgreSQL para producción, H2 para tests (Backend).
- **CI/CD**: GitHub Actions configurado en `.github/workflows`.

---
**Última actualización de este índice:** Junio 2026
