#!/bin/bash

# Script para ejecutar análisis de seguridad con Trivy en todos los proyectos

echo "🛡️ Ejecutando análisis de seguridad completo con Trivy..."

# Verificar que estamos en el directorio correcto
if [ ! -f ".gitmodules" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz del monorepo"
    exit 1
fi

# Verificar si Trivy está instalado
if ! command -v trivy &> /dev/null; then
    echo "📦 Trivy no está instalado. Instalando..."
    
    # Detectar el sistema operativo
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update
        sudo apt-get install -y wget apt-transport-https gnupg lsb-release
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install -y trivy
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install trivy
        else
            echo "❌ Homebrew no encontrado. Instala Trivy manualmente: https://aquasecurity.github.io/trivy/"
            exit 1
        fi
    else
        echo "❌ Sistema operativo no soportado. Instala Trivy manualmente: https://aquasecurity.github.io/trivy/"
        exit 1
    fi
fi

# Crear directorio para reportes
mkdir -p security-reports
cd security-reports

echo ""
echo "🔍 Análisis de seguridad del Backend (Trivy)..."
echo "==============================================="
cd ../backend
if [ -f "mvnw" ]; then
    echo "📦 Construyendo backend para análisis..."
    ./mvnw clean package -DskipTests > /dev/null 2>&1
    
    echo "🔍 Ejecutando Trivy en el proyecto backend..."
    trivy fs --format table --output ../security-reports/backend-trivy-report.txt .
    trivy fs --format template --template "@contrib/html.tpl" --output ../security-reports/backend-trivy-report.html .
    
    # Analizar JAR si existe
    if [ -f "target/backend.jar" ]; then
        echo "📦 Analizando JAR del backend..."
        trivy fs --format table --output ../security-reports/backend-jar-trivy-report.txt target/backend.jar
        trivy fs --format template --template "@contrib/html.tpl" --output ../security-reports/backend-jar-trivy-report.html target/backend.jar
    fi
    
    echo "✅ Análisis Trivy del backend completado"
else
    echo "❌ mvnw no encontrado en backend"
fi

echo ""
echo "🔍 Análisis de seguridad de Angular (Trivy)..."
echo "=============================================="
cd ../angular
if [ -f "package.json" ]; then
    echo "🔍 Ejecutando Trivy en Angular..."
    trivy fs --format table --output ../security-reports/angular-trivy-report.txt .
    trivy fs --format template --template "@contrib/html.tpl" --output ../security-reports/angular-trivy-report.html .
    
    # También ejecutar npm audit como complemento
    echo "📋 Ejecutando npm audit complementario..."
    npm audit --json > ../security-reports/angular-npm-audit.json 2>/dev/null || true
    echo "✅ Análisis Trivy de Angular completado"
else
    echo "❌ package.json no encontrado en angular"
fi

echo ""
echo "🔍 Análisis de seguridad de React (Trivy)..."
echo "==========================================="
cd ../react
if [ -f "package.json" ]; then
    echo "🔍 Ejecutando Trivy en React..."
    trivy fs --format table --output ../security-reports/react-trivy-report.txt .
    trivy fs --format template --template "@contrib/html.tpl" --output ../security-reports/react-trivy-report.html .
    
    # También ejecutar npm audit como complemento
    echo "📋 Ejecutando npm audit complementario..."
    npm audit --json > ../security-reports/react-npm-audit.json 2>/dev/null || true
    echo "✅ Análisis Trivy de React completado"
else
    echo "❌ package.json no encontrado en react"
fi

echo ""
echo "🔍 Análisis de seguridad de Vue3 (Trivy)..."
echo "==========================================="
cd ../vue3
if [ -f "package.json" ]; then
    echo "🔍 Ejecutando Trivy en Vue3..."
    trivy fs --format table --output ../security-reports/vue3-trivy-report.txt .
    trivy fs --format template --template "@contrib/html.tpl" --output ../security-reports/vue3-trivy-report.html .
    
    # También ejecutar npm audit como complemento
    echo "📋 Ejecutando npm audit complementario..."
    npm audit --json > ../security-reports/vue3-npm-audit.json 2>/dev/null || true
    echo "✅ Análisis Trivy de Vue3 completado"
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
echo "  📊 Reportes HTML (abrir en navegador):"
echo "    - Backend: security-reports/backend-trivy-report.html"
echo "    - Backend JAR: security-reports/backend-jar-trivy-report.html"
echo "    - Angular: security-reports/angular-trivy-report.html"
echo "    - React: security-reports/react-trivy-report.html"
echo "    - Vue3: security-reports/vue3-trivy-report.html"
echo ""
echo "  📄 Reportes de texto:"
echo "    - Backend: security-reports/backend-trivy-report.txt"
echo "    - Backend JAR: security-reports/backend-jar-trivy-report.txt"
echo "    - Angular: security-reports/angular-trivy-report.txt"
echo "    - React: security-reports/react-trivy-report.txt"
echo "    - Vue3: security-reports/vue3-trivy-report.txt"
echo ""
echo "  📋 Reportes npm audit complementarios:"
echo "    - Angular: security-reports/angular-npm-audit.json"
echo "    - React: security-reports/react-npm-audit.json"
echo "    - Vue3: security-reports/vue3-npm-audit.json"

echo ""
echo "📊 Resumen rápido de vulnerabilidades:"
for file in security-reports/*-trivy-report.txt; do
    if [ -f "$file" ]; then
        project=$(basename "$file" | cut -d'-' -f1)
        echo "  🔍 $project:"
        # Mostrar resumen de vulnerabilidades críticas y altas
        grep -E "(CRITICAL|HIGH)" "$file" | wc -l | xargs -I {} echo "    - Vulnerabilidades CRITICAL/HIGH: {}"
        grep -E "Total:" "$file" | head -1 || echo "    - Análisis completado"
    fi
done

echo ""
echo "⚠️  Recomendaciones:"
echo "  1. Revisar todos los reportes HTML para detalles completos"
echo "  2. Priorizar vulnerabilidades CRITICAL y HIGH"
echo "  3. Actualizar dependencias vulnerables"
echo "  4. Ejecutar este análisis regularmente"
echo "  5. Integrar Trivy en tu pipeline de CI/CD"

echo ""
echo "🎉 Análisis de seguridad con Trivy completado!"