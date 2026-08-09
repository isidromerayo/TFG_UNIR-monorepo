# TFG UNIR - Frameworks Frontend JavaScript: Análisis y estudio práctico

## 📊 Calidad de Código - SonarQube

| Proyecto | Quality Gate | Coverage |
|----------|--------------|----------|
| **Backend** | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-backend&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-backend) | [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-backend&metric=coverage)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-backend) |
| **Angular** | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-angular&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-angular) | [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-angular&metric=coverage)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-angular) |
| **React** | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-react&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-react) | [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-react&metric=coverage)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-react) |
| **Vue3** | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-vue3&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-vue3) | [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=isidromerayo_TFG_UNIR-vue3&metric=coverage)](https://sonarcloud.io/summary/new_code?id=isidromerayo_TFG_UNIR-vue3) |

# Universidad Internacional de La Rioja

## Escuela Superior de Ingeniería y Tecnología 

### Grado en Ingeniería Informática

#### TFG: Frameworks frontend JavaScript: Análisis y estudio práctico

##### Monorepo

## 📅 Ciclo de Vida de los Frameworks

Este monorepo agrupa las tecnologías del TFG; cada una tiene su propio ciclo de vida y política de soporte:

| Proyecto | Tecnología | Versión | Estado | Fin de soporte |
|----------|-----------|---------|--------|----------------|
| **Backend** | Spring Boot | 3.5.16 | Soporte OSS finalizado | 30 de Junio 2026 |
| **Angular** | Angular | 21.2.19 | LTS | ~Junio 2027 |
| **React** | React | 19.2.8 | Estable (SemVer, sin EOL fijo) | - |
| **Vue3** | Vue | 3.5.33 | Estable / Actual | - |

Detalles completos del ciclo de vida de cada tecnología en el README de cada proyecto.

## 🚀 Descripción

Este es el repositorio principal que contiene todos los proyectos del TFG sobre frameworks frontend JavaScript.

## 📁 Estructura del Proyecto

- `angular/` - Aplicación Angular (versión 21.2.19)
- `backend/` - API Backend con Spring Boot 3.5.16 y Java 21
- `react/` - Aplicación React 19.2.8 con Next.js 16.2.12
- `vue3/` - Aplicación Vue 3.5.33 con TypeScript

## 🚀 Configuración Inicial

### Clonar el repositorio completo

```bash
# Clonar con todos los submodules
git clone --recursive https://github.com/isidromerayo/TFG_UNIR-monorepo.git

# O si ya clonaste sin --recursive
git submodule update --init --recursive
```

### Configurar el entorno de desarrollo

```bash
# Ejecutar el script de configuración
./scripts/dev-setup.sh
```

## 🛠️ Desarrollo

### Backend (Spring Boot)
```bash
cd backend
./mvnw spring-boot:run
# API disponible en: http://localhost:8080/api
# Swagger UI: http://localhost:8080/swagger-ui.html
```

#### 👥 Usuarios de Prueba

La base de datos incluye usuarios de prueba precargados para facilitar el desarrollo y testing:

**Usuarios Activos** (estado: A - pueden acceder a la aplicación)

| Email | Contraseña | Nombre |
|-------|-----------|--------|
| `helena@localhost` | `1234` | Helena García Sánchez |
| `carlos@localhost` | `1234` | Carlos Toreno Sil |
| `ines@localhost` | `1234` | Ines Boeza Alonso |
| `isable@localhost` | `1234` | Isabel Fresnedo Noceda |
| `c@example.com` | `1234` | Carla Canedo Castro |

**Usuarios Pendientes** (estado: P - para testing de estados)

| Email | Contraseña | Nombre |
|-------|-----------|--------|
| `maria@localhost` | `1234` | María García Sánchez |
| `juanantonio@localhost` | `1234` | Juan Antonio Ponferrada Dominguez |
| `marta@localhost` | `1234` | Marta Toral Alonso |
| `pedro@localhost` | `1234` | Pedro Villa Ledesma |
| `d@example.com` | `1234` | Diego Diaz Diez |
| `c@demo.com` | `1234` | Clara Cedro Claro |
| `m@example.com` | `1234` | Marta Martinez Marcos |
| `Kathryne1@example.com` | `1234` | Krista Frami |
| `Alva_Streich@example.net` | `TFG_1234` | Jevon Harber |

> **⚠️ Nota de seguridad**: Estos usuarios son solo para desarrollo y testing. En producción, las contraseñas deben estar hasheadas y seguir políticas de seguridad robustas.

> **💡 Tip**: Los usuarios **activos** pueden iniciar sesión normalmente. Los usuarios **pendientes** están desactivados y sirven para probar flujos de activación de cuentas.

### Frontend Angular (pnpm)
```bash
cd angular
pnpm install
pnpm start
# Aplicación disponible en: http://localhost:4200
```

### Frontend React (Next.js) - **Migrado a pnpm** ✨
```bash
cd react
pnpm install
pnpm dev
# Aplicación disponible en: http://localhost:3000
```

### Frontend Vue 3 - **Migrado a pnpm** ✨
```bash
cd vue3
pnpm install
pnpm dev
# Aplicación disponible en: http://localhost:5173
```

> **Nota**: Los tres frontends (Angular, React y Vue3) usan **pnpm** como gestor de dependencias para mejor gestión, 
> mayor velocidad de instalación y menor uso de espacio en disco.

## 🔄 Actualizar Submodules

### Actualización Automática ⭐

Los submodules se actualizan **automáticamente cada 6 horas** mediante GitHub Actions.

También puedes disparar una actualización manual:
1. Ve a la pestaña **Actions** en GitHub
2. Selecciona **"Update Submodules"**
3. Click en **"Run workflow"**

### Actualización Manual

Para actualizar manualmente en local:

```bash
# Actualizar todos los submodules
git submodule update --remote

# O usar el script helper
./scripts/update-all.sh
```

📚 Ver [SUBMODULE_AUTOMATION.md](./SUBMODULE_AUTOMATION.md) para más detalles sobre la automatización.

## 🧪 Testing

Cada proyecto tiene sus propios tests. Para ejecutar todos:

```bash
# Backend
cd backend && ./mvnw test

# Angular (pnpm)
cd angular && pnpm run test-headless

# React (pnpm)
cd react && pnpm test-headless

# Vue3 (pnpm)
cd vue3 && pnpm test-headless

# Todos los tests
./scripts/test-all.sh
```

## 🛡️ Análisis de Seguridad

### Análisis Automático (CI/CD)
El pipeline incluye análisis de seguridad automático con **Trivy**:
- **Todos los proyectos**: Análisis completo de vulnerabilidades con Trivy
- **Reportes duales**: Formato texto y HTML para cada proyecto
- **Cobertura completa**: Dependencias, código fuente y artefactos

### Análisis Manual
```bash
# Ejecutar análisis completo con Trivy (usa Podman/Docker automáticamente si está disponible)
./scripts/security-audit.sh

# Usar Trivy con contenedores directamente (recomendado)
./scripts/trivy-container.sh backend                                    # Formato tabla
./scripts/trivy-container.sh -f json -o report.json angular           # Formato JSON
./scripts/trivy-container.sh -f template -t @contrib/html.tpl -o report.html react  # Formato HTML

# Usar imagen con Podman manualmente (preferido)
podman run --rm -v $(pwd):/workspace docker.io/aquasec/trivy:latest fs --format table /workspace/backend

# Usar imagen con Docker manualmente
docker run --rm -v $(pwd):/workspace docker.io/aquasec/trivy:latest fs --format table /workspace/backend

# Análisis complementario con pnpm audit
cd angular && pnpm audit
cd vue3 && pnpm audit

# React: el endpoint de pnpm audit está retirado (HTTP 410) - usar pnpm outdated
cd react && pnpm outdated
```

### Reportes de Seguridad
Los reportes se generan en `./security-reports/`:

**Reportes Trivy (HTML):**
- `backend-trivy-report.html` - Análisis completo del backend
- `backend-jar-trivy-report.html` - Análisis del JAR compilado
- `angular-trivy-report.html` - Análisis de Angular
- `react-trivy-report.html` - Análisis de React
- `vue3-trivy-report.html` - Análisis de Vue3

**Reportes Trivy (Texto):**
- `backend-trivy-report.txt` - Resumen textual del backend
- `angular-trivy-report.txt` - Resumen textual de Angular
- `react-trivy-report.txt` - Resumen textual de React
- `vue3-trivy-report.txt` - Resumen textual de Vue3

**Reportes Complementarios:**
- `*-pnpm-audit.json` - Auditorías pnpm de cada frontend

### Ventajas de usar Trivy con Contenedores (Podman/Docker)
- ✅ **Sin instalación**: No requiere instalar Trivy localmente
- ✅ **Consistencia**: Misma versión en desarrollo y CI/CD
- ✅ **Portabilidad**: Funciona en cualquier sistema con Podman o Docker
- ✅ **Actualizaciones**: Siempre usa la última versión disponible
- ✅ **Aislamiento**: No interfiere con el sistema local
- 🐙 **Podman**: Más seguro (sin daemon), rootless por defecto
- 🐳 **Docker**: Amplia compatibilidad y ecosistema

## 📦 Build y Deploy

### Builds individuales
```bash
# Backend
cd backend && ./mvnw clean package

# Angular (pnpm)
cd angular && pnpm run build

# React (pnpm)
cd react && pnpm build

# Vue3 (pnpm)
cd vue3 && pnpm build
```

## 🏗️ Arquitectura

Este proyecto implementa la misma funcionalidad (plataforma de cursos online) usando diferentes frameworks frontend para comparar:

- **Performance**
- **Developer Experience**
- **Bundle Size**
- **Ecosystem**
- **Learning Curve**

### Backend Común
- Spring Boot 3.5.16
- Java 21
- Spring Security 6.x
- JPA/Hibernate 6.x
- PostgreSQL
- OpenAPI/Swagger

### Funcionalidades Implementadas
- Autenticación y autorización
- Gestión de cursos
- Carrito de compras
- Búsqueda y filtros
- Perfil de usuario

## 🔄 Migraciones y Mejoras Recientes

### Migración a pnpm (Angular, React y Vue3)
Los proyectos frontend (Angular, React y Vue3) han sido migrados de npm a pnpm, obteniendo:
- ⚡ **Instalación 2-3x más rápida** gracias al caché global
- 💾 **Ahorro de espacio en disco** con enlaces simbólicos
- 🔒 **Mayor seguridad** con lockfile estricto
- 🎯 **Mejor gestión de dependencias** con workspace support

### Infraestructura de Seguridad Multi-Capa
Todos los proyectos frontend incluyen:
- 🛡️ **GitHub Actions Security Workflow** con 5 herramientas de auditoría
- 🤖 **Dependabot** configurado con agrupación inteligente
- 📊 **Scripts locales** para auditoría multi-herramienta
- 📝 **Documentación completa** de seguridad y actualización de dependencias

Ver [SECURITY_STATUS.md](./SECURITY_STATUS.md) para el estado actual de seguridad.

## 📊 CI/CD

El proyecto incluye GitHub Actions para:
- Tests automatizados (con pnpm en los frontends y Maven en el backend)
- Análisis de seguridad multi-herramienta (Trivy, pnpm audit)
- Type checking (TypeScript)
- Build verification
- Dependency checking (Dependabot)

## 📝 Documentación

- [Documentación del Backend](./backend/README.md)
- [Documentación Angular](./angular/README.md)
- [Documentación React](./react/README.md)
- [Documentación Vue3](./vue3/README.md)

## 🤝 Contribución

Cada subproyecto puede desarrollarse independientemente:

1. Trabaja en el repositorio específico del framework
2. Haz push de tus cambios al repo individual
3. Actualiza este monorepo cuando sea necesario

## 👥 Contribuidores

- **[Isidro Merayo](https://github.com/isidromerayo)** - Autor principal y desarrollador del TFG
- **Kiro AI** - Asistente de desarrollo, configuración del monorepo y automatización

## 📄 Licencia

Este proyecto es parte de un Trabajo de Fin de Grado (TFG) de la Universidad Internacional de La Rioja (UNIR).