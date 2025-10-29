# Guía de Contribución

## Estructura del Proyecto

Este monorepo contiene cuatro proyectos independientes que implementan la misma funcionalidad usando diferentes tecnologías:

- **Backend**: Spring Boot 3 + Java 17
- **Angular**: Angular 16+ con TypeScript
- **React**: Next.js con TypeScript
- **Vue3**: Vue 3 con TypeScript

## Flujo de Desarrollo

### Desarrollo en Proyectos Individuales

1. **Clona el repositorio específico** para desarrollo diario:
   ```bash
   git clone https://github.com/isidromerayo/TFG_UNIR-angular.git
   git clone https://github.com/isidromerayo/TFG_UNIR-backend.git
   git clone https://github.com/isidromerayo/TFG_UNIR-react.git
   git clone https://github.com/isidromerayo/TFG_UNIR-vue3.git
   ```

2. **Desarrolla normalmente** en cada repositorio individual

3. **Haz push** a los repositorios individuales

### Actualización del Monorepo

Cuando quieras sincronizar el monorepo con los últimos cambios:

```bash
# Desde el directorio del monorepo
./scripts/update-all.sh
```

## Convenciones de Commits

Usa [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new course search functionality
fix: resolve authentication token expiration
docs: update API documentation
test: add unit tests for user service
refactor: improve code organization
```

## Testing

### Tests Individuales
```bash
# Backend
cd backend && ./mvnw test

# Angular
cd angular && npm test

# React
cd react && npm test

# Vue3
cd vue3 && npm run test
```

### Tests Completos
```bash
./scripts/test-all.sh
```

## Builds

### Builds Individuales
```bash
# Backend
cd backend && ./mvnw clean package

# Angular
cd angular && npm run build

# React
cd react && npm run build

# Vue3
cd vue3 && npm run build
```

## Releases

### Versionado

Cada proyecto mantiene su propio versionado siguiendo [Semantic Versioning](https://semver.org/):

- **MAJOR**: Cambios incompatibles en la API
- **MINOR**: Nueva funcionalidad compatible
- **PATCH**: Correcciones de bugs

### Proceso de Release

1. **Actualiza versiones** en cada proyecto individual
2. **Crea tags** en los repositorios individuales
3. **Actualiza el monorepo** con `./scripts/update-all.sh`
4. **Crea release** del monorepo

## Estructura de Directorios

```
TFG_UNIR-monorepo/
├── angular/          # Submodule: Angular app
├── backend/          # Submodule: Spring Boot API
├── react/            # Submodule: Next.js app
├── vue3/             # Submodule: Vue 3 app
├── scripts/          # Scripts de gestión
│   ├── dev-setup.sh  # Configuración inicial
│   ├── test-all.sh   # Ejecutar todos los tests
│   └── update-all.sh # Actualizar submodules
├── .github/
│   └── workflows/    # GitHub Actions
├── README.md
├── CONTRIBUTING.md
└── .gitmodules       # Configuración de submodules
```

## Configuración del Entorno

### Requisitos
- Java 17+
- Node.js 18+
- npm 8+
- Git

### Setup Inicial
```bash
git clone --recursive https://github.com/isidromerayo/TFG_UNIR-monorepo.git
cd TFG_UNIR-monorepo
./scripts/dev-setup.sh
```

## CI/CD

El proyecto incluye GitHub Actions que:

- ✅ Ejecutan tests automáticamente
- 🔍 Analizan código con CodeQL
- 🛡️ Verifican dependencias con OWASP
- 📦 Generan builds de todos los proyectos
- 📊 Reportan cobertura de tests

## Troubleshooting

### Problemas Comunes

**Error de submodules vacíos:**
```bash
git submodule update --init --recursive
```

**Conflictos de dependencias en Angular:**
```bash
cd angular && npm install --legacy-peer-deps
```

**Puerto ocupado:**
- Backend: 8080
- Angular: 4200
- React: 3000
- Vue3: 5173

### Logs y Debug

```bash
# Ver logs del backend
cd backend && ./mvnw spring-boot:run --debug

# Debug de Angular
cd angular && ng serve --verbose

# Debug de React
cd react && npm run dev -- --debug

# Debug de Vue3
cd vue3 && npm run dev -- --debug
```

## Contribuidores

### Autor Principal
- **Isidro Merayo** - [@isidromerayo](https://github.com/isidromerayo)
  - Desarrollo del TFG UNIR
  - Arquitectura del proyecto
  - Implementación de todos los frameworks

### Colaboradores
- **Kiro AI** - Asistente de desarrollo
  - Configuración del monorepo
  - Scripts de automatización
  - Documentación y CI/CD
  - Optimización de workflows

## Contacto

Para preguntas sobre el proyecto:
- 📧 Contacta con [@isidromerayo](https://github.com/isidromerayo)
- 🐛 Abre un issue en GitHub para bugs o mejoras
- 💡 Usa las Discussions para ideas y preguntas generales