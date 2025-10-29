#!/bin/bash

# Script para configurar el repositorio en GitHub

echo "🚀 Configurando repositorio en GitHub..."

# Verificar que estamos en el directorio correcto
if [ ! -f ".gitmodules" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz del monorepo"
    exit 1
fi

echo ""
echo "📋 Pasos para configurar el repositorio en GitHub:"
echo ""
echo "1. Ve a https://github.com/new"
echo "2. Nombre del repositorio: TFG_UNIR-monorepo"
echo "3. Descripción: 'TFG UNIR - Frameworks Frontend JavaScript: Análisis y estudio práctico - Monorepo'"
echo "4. Público/Privado: según tu preferencia"
echo "5. NO inicialices con README, .gitignore o licencia (ya los tenemos)"
echo "6. Crea el repositorio"
echo ""
echo "Una vez creado el repositorio, ejecuta estos comandos:"
echo ""
echo "git remote add origin https://github.com/isidromerayo/TFG_UNIR-monorepo.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "🔗 Después de hacer push, el monorepo estará disponible en:"
echo "   https://github.com/isidromerayo/TFG_UNIR-monorepo"
echo ""

# Opcional: configurar el remote automáticamente si se proporciona
if [ "$1" != "" ]; then
    echo "🔧 Configurando remote origin..."
    git remote add origin "$1"
    echo "✅ Remote configurado: $1"
    echo ""
    echo "Ahora puedes hacer push con:"
    echo "git push -u origin main"
fi