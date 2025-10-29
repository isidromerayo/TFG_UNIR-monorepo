#!/bin/bash

# Script para actualizar todos los submodules

echo "🔄 Actualizando todos los submodules..."

# Actualizar cada submodule a la última versión
git submodule update --remote --merge

# Mostrar el estado
echo ""
echo "📊 Estado actual de los submodules:"
git submodule status

echo ""
echo "📝 Cambios detectados:"
git status --porcelain

# Opcional: hacer commit automático de las actualizaciones
echo ""
read -p "¿Hacer commit de las actualizaciones? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    git commit -m "Update all submodules to latest versions"
    echo "✅ Cambios commitados. Ejecuta 'git push' para subirlos."
else
    echo "ℹ️  Cambios no commitados. Puedes revisarlos con 'git status'"
fi