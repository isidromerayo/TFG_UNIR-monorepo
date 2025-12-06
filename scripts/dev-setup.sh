#!/bin/bash

# Script para configurar el entorno de desarrollo

echo "🚀 Configurando entorno de desarrollo..."

# Verificar que estamos en el directorio correcto
if [ ! -f ".gitmodules" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz del monorepo"
    exit 1
fi

# Verificar dependencias del sistema
echo "🔍 Verificando dependencias del sistema..."

# Verificar Java
if ! command -v java &> /dev/null; then
    echo "❌ Java no encontrado. Instala Java 17 o superior."
    exit 1
fi

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no encontrado. Instala Node.js 18 o superior."
    exit 1
fi

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm no encontrado. Instala npm."
    exit 1
fi

# Verificar pnpm (opcional pero recomendado para React y Vue3)
if ! command -v pnpm &> /dev/null; then
    echo "⚠️  pnpm no encontrado. Se recomienda instalarlo para React y Vue3."
    echo "   Instalar con: npm install -g pnpm"
    echo "   Los proyectos React y Vue3 usan pnpm para mejor gestión de dependencias."
    USE_PNPM=false
else
    echo "✅ pnpm encontrado"
    USE_PNPM=true
fi

echo "✅ Dependencias del sistema verificadas"

# Instalar dependencias de cada proyecto
echo ""
echo "📦 Instalando dependencias del backend..."
if [ -d "backend" ]; then
    cd backend
    if [ -f "mvnw" ]; then
        ./mvnw clean install -DskipTests
        echo "✅ Backend configurado"
    else
        echo "⚠️  mvnw no encontrado en backend"
    fi
    cd ..
else
    echo "⚠️  Directorio backend no encontrado"
fi

echo ""
echo "📦 Instalando dependencias de Angular..."
if [ -d "angular" ]; then
    cd angular
    if [ -f "package.json" ]; then
        npm install
        echo "✅ Angular configurado"
    else
        echo "⚠️  package.json no encontrado en angular"
    fi
    cd ..
else
    echo "⚠️  Directorio angular no encontrado"
fi

echo ""
echo "📦 Instalando dependencias de React (pnpm)..."
if [ -d "react" ]; then
    cd react
    if [ -f "package.json" ]; then
        if [ "$USE_PNPM" = true ]; then
            pnpm install
            echo "✅ React configurado con pnpm"
        else
            echo "⚠️  Usando npm como fallback (se recomienda pnpm)"
            npm install
            echo "✅ React configurado con npm"
        fi
    else
        echo "⚠️  package.json no encontrado en react"
    fi
    cd ..
else
    echo "⚠️  Directorio react no encontrado"
fi

echo ""
echo "📦 Instalando dependencias de Vue3 (pnpm)..."
if [ -d "vue3" ]; then
    cd vue3
    if [ -f "package.json" ]; then
        if [ "$USE_PNPM" = true ]; then
            pnpm install
            echo "✅ Vue3 configurado con pnpm"
        else
            echo "⚠️  Usando npm como fallback (se recomienda pnpm)"
            npm install
            echo "✅ Vue3 configurado con npm"
        fi
    else
        echo "⚠️  package.json no encontrado en vue3"
    fi
    cd ..
else
    echo "⚠️  Directorio vue3 no encontrado"
fi

echo ""
echo "🎉 ¡Entorno configurado! Puedes usar los siguientes comandos:"
echo ""
echo "Backend (Spring Boot):"
echo "  cd backend && ./mvnw spring-boot:run"
echo "  API: http://localhost:8080/api"
echo "  Swagger: http://localhost:8080/swagger-ui.html"
echo ""
echo "Frontend Angular (npm):"
echo "  cd angular && npm start"
echo "  App: http://localhost:4200"
echo ""
if [ "$USE_PNPM" = true ]; then
    echo "Frontend React (pnpm):"
    echo "  cd react && pnpm dev"
    echo "  App: http://localhost:3000"
    echo ""
    echo "Frontend Vue3 (pnpm):"
    echo "  cd vue3 && pnpm dev"
    echo "  App: http://localhost:5173"
else
    echo "Frontend React (npm - considera instalar pnpm):"
    echo "  cd react && npm run dev"
    echo "  App: http://localhost:3000"
    echo ""
    echo "Frontend Vue3 (npm - considera instalar pnpm):"
    echo "  cd vue3 && npm run dev"
    echo "  App: http://localhost:5173"
    echo ""
    echo "💡 Tip: Instala pnpm para mejor rendimiento:"
    echo "   npm install -g pnpm"
fi