#!/bin/bash

# Script para ejecutar análisis de seguridad en todos los proyectos

echo "🛡️ Ejecutando análisis de seguridad completo..."

# Verificar que estamos en el directorio correcto
if [ ! -f ".gitmodules" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz del monorepo"
    exit 1
fi

# Crear directorio para reportes
mkdir -p security-reports
cd security-reports

echo ""
echo "🔍 Análisis de seguridad del Backend (OWASP Dependency Check)..."
echo "================================================================"
cd ../backend
if [ -f "mvnw" ]; then
    if [ -n "$NVD_API_KEY" ]; then
        echo "✅ Usando NVD API Key para análisis más rápido"
        ./mvnw org.owasp:dependency-check-maven:check -Dnvd.api.key=$NVD_API_KEY -Danalyzer.ossindex.enabled=false
    else
        echo "⚠️  NVD_API_KEY no configurada - el análisis será más lento"
        ./mvnw org.owasp:dependency-check-maven:check -Danalyzer.ossindex.enabled=false
    fi
    
    if [ -f "target/dependency-check-report.html" ]; then
        cp target/dependency-check-report.html ../security-reports/backend-owasp-report.html
        echo "✅ Reporte OWASP copiado a security-reports/backend-owasp-report.html"
    fi
else
    echo "❌ mvnw no encontrado en backend"
fi

echo ""
echo "🔍 Análisis de seguridad de Angular (npm audit)..."
echo "=================================================="
cd ../angular
if [ -f "package.json" ]; then
    echo "📦 Instalando dependencias..."
    npm install --legacy-peer-deps --force > /dev/null 2>&1
    
    echo "🔍 Ejecutando npm audit..."
    npm audit --json > ../security-reports/angular-audit.json 2>/dev/null || true
    npm audit --audit-level=moderate || echo "⚠️ Angular audit encontró problemas"
    echo "✅ Reporte Angular guardado en security-reports/angular-audit.json"
else
    echo "❌ package.json no encontrado en angular"
fi

echo ""
echo "🔍 Análisis de seguridad de React (npm audit)..."
echo "==============================================="
cd ../react
if [ -f "package.json" ]; then
    echo "📦 Instalando dependencias..."
    npm ci > /dev/null 2>&1 || npm install > /dev/null 2>&1
    
    echo "🔍 Ejecutando npm audit..."
    npm audit --json > ../security-reports/react-audit.json 2>/dev/null || true
    npm audit --audit-level=moderate || echo "⚠️ React audit encontró problemas"
    echo "✅ Reporte React guardado en security-reports/react-audit.json"
else
    echo "❌ package.json no encontrado en react"
fi

echo ""
echo "🔍 Análisis de seguridad de Vue3 (npm audit)..."
echo "==============================================="
cd ../vue3
if [ -f "package.json" ]; then
    echo "📦 Instalando dependencias..."
    npm ci > /dev/null 2>&1 || npm install > /dev/null 2>&1
    
    echo "🔍 Ejecutando npm audit..."
    npm audit --json > ../security-reports/vue3-audit.json 2>/dev/null || true
    npm audit --audit-level=moderate || echo "⚠️ Vue3 audit encontró problemas"
    echo "✅ Reporte Vue3 guardado en security-reports/vue3-audit.json"
else
    echo "❌ package.json no encontrado en vue3"
fi

cd ..

echo ""
echo "📊 Resumen de Análisis de Seguridad"
echo "==================================="
echo ""
echo "📁 Reportes generados en: ./security-reports/"
ls -la security-reports/ 2>/dev/null || echo "❌ No se generaron reportes"

echo ""
echo "🔍 Para revisar los reportes:"
echo "  - Backend OWASP: Abrir security-reports/backend-owasp-report.html en el navegador"
echo "  - Angular: Revisar security-reports/angular-audit.json"
echo "  - React: Revisar security-reports/react-audit.json"
echo "  - Vue3: Revisar security-reports/vue3-audit.json"

echo ""
echo "⚠️  Recomendaciones:"
echo "  1. Revisar todos los reportes antes del despliegue"
echo "  2. Actualizar dependencias vulnerables"
echo "  3. Ejecutar este análisis regularmente"
echo "  4. Configurar NVD_API_KEY para análisis más rápidos"

echo ""
echo "🎉 Análisis de seguridad completado!"