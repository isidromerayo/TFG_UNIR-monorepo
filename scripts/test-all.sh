#!/bin/bash

# Script para ejecutar todos los tests

echo "🧪 Ejecutando tests de todos los proyectos..."

# Función para mostrar resultados
show_result() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2: PASSED"
    else
        echo "❌ $2: FAILED"
    fi
}

# Contadores
total_tests=0
passed_tests=0

# Tests del Backend
echo ""
echo "🔧 Testing Backend (Spring Boot)..."
if [ -d "backend" ]; then
    cd backend
    ./mvnw test -q
    backend_result=$?
    show_result $backend_result "Backend Tests"
    if [ $backend_result -eq 0 ]; then ((passed_tests++)); fi
    ((total_tests++))
    cd ..
else
    echo "⚠️  Directorio backend no encontrado"
fi

# Tests de Angular
echo ""
echo "🅰️  Testing Angular..."
if [ -d "angular" ]; then
    cd angular
    npm test -- --watch=false --browsers=ChromeHeadless 2>/dev/null
    angular_result=$?
    show_result $angular_result "Angular Tests"
    if [ $angular_result -eq 0 ]; then ((passed_tests++)); fi
    ((total_tests++))
    cd ..
else
    echo "⚠️  Directorio angular no encontrado"
fi

# Tests de React (pnpm)
echo ""
echo "⚛️  Testing React (pnpm)..."
if [ -d "react" ]; then
    cd react
    if command -v pnpm &> /dev/null; then
        pnpm test-headless 2>/dev/null
        react_result=$?
    else
        echo "⚠️  pnpm no encontrado, usando npm..."
        npm test -- --watchAll=false 2>/dev/null
        react_result=$?
    fi
    show_result $react_result "React Tests"
    if [ $react_result -eq 0 ]; then ((passed_tests++)); fi
    ((total_tests++))
    cd ..
else
    echo "⚠️  Directorio react no encontrado"
fi

# Tests de Vue3 (pnpm)
echo ""
echo "🟢 Testing Vue3 (pnpm)..."
if [ -d "vue3" ]; then
    cd vue3
    if command -v pnpm &> /dev/null; then
        pnpm test-headless 2>/dev/null
        vue_result=$?
    else
        echo "⚠️  pnpm no encontrado, usando npm..."
        npm run test 2>/dev/null
        vue_result=$?
    fi
    show_result $vue_result "Vue3 Tests"
    if [ $vue_result -eq 0 ]; then ((passed_tests++)); fi
    ((total_tests++))
    cd ..
else
    echo "⚠️  Directorio vue3 no encontrado"
fi

# Resumen final
echo ""
echo "📊 Resumen de Tests:"
echo "   Total: $total_tests"
echo "   Passed: $passed_tests"
echo "   Failed: $((total_tests - passed_tests))"

if [ $passed_tests -eq $total_tests ]; then
    echo "🎉 ¡Todos los tests pasaron!"
    exit 0
else
    echo "💥 Algunos tests fallaron"
    exit 1
fi