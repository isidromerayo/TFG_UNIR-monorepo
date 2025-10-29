#!/bin/bash

# Script para ejecutar Trivy usando la imagen Docker oficial

echo "🐳 Ejecutando Trivy con Docker (aquasec/trivy)..."

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado"
    echo "📦 Instala Docker desde: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar que estamos en el directorio correcto
if [ ! -f ".gitmodules" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz del monorepo"
    exit 1
fi

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [OPCIONES] [DIRECTORIO]"
    echo ""
    echo "Opciones:"
    echo "  -f, --format FORMAT    Formato de salida (table, json, template)"
    echo "  -o, --output FILE      Archivo de salida"
    echo "  -t, --template TMPL    Template para formato template (@contrib/html.tpl)"
    echo "  -h, --help            Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 backend                                    # Escanear backend en formato tabla"
    echo "  $0 -f json -o report.json angular           # Escanear Angular en formato JSON"
    echo "  $0 -f template -t @contrib/html.tpl -o report.html react  # Generar reporte HTML"
    echo ""
    echo "Formatos disponibles:"
    echo "  - table: Tabla legible en consola"
    echo "  - json: Formato JSON estructurado"
    echo "  - template: Usando plantillas personalizadas"
    echo "  - sarif: Formato SARIF para integración con herramientas"
}

# Valores por defecto
FORMAT="table"
OUTPUT=""
TEMPLATE=""
TARGET="."

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        -t|--template)
            TEMPLATE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "❌ Opción desconocida: $1"
            show_help
            exit 1
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# Validar formato
case $FORMAT in
    table|json|template|sarif)
        ;;
    *)
        echo "❌ Formato no válido: $FORMAT"
        echo "Formatos válidos: table, json, template, sarif"
        exit 1
        ;;
esac

# Construir comando Trivy
TRIVY_CMD="docker run --rm -v $(pwd):/workspace aquasec/trivy:latest fs"
TRIVY_CMD="$TRIVY_CMD --format $FORMAT"

if [ -n "$OUTPUT" ]; then
    TRIVY_CMD="$TRIVY_CMD --output /workspace/$OUTPUT"
fi

if [ "$FORMAT" = "template" ] && [ -n "$TEMPLATE" ]; then
    TRIVY_CMD="$TRIVY_CMD --template $TEMPLATE"
elif [ "$FORMAT" = "template" ] && [ -z "$TEMPLATE" ]; then
    echo "⚠️  Formato template requiere especificar --template"
    echo "Ejemplo: --template @contrib/html.tpl"
    exit 1
fi

TRIVY_CMD="$TRIVY_CMD /workspace/$TARGET"

echo "🔍 Escaneando: $TARGET"
echo "📊 Formato: $FORMAT"
if [ -n "$OUTPUT" ]; then
    echo "📄 Salida: $OUTPUT"
fi
echo ""

# Descargar imagen si no existe
echo "📦 Verificando imagen aquasec/trivy:latest..."
docker pull aquasec/trivy:latest

echo ""
echo "🚀 Ejecutando Trivy..."
echo "Comando: $TRIVY_CMD"
echo ""

# Ejecutar Trivy
eval $TRIVY_CMD

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Análisis completado exitosamente"
    if [ -n "$OUTPUT" ]; then
        echo "📄 Reporte guardado en: $OUTPUT"
    fi
else
    echo ""
    echo "⚠️  Análisis completado con advertencias (código: $EXIT_CODE)"
    if [ -n "$OUTPUT" ]; then
        echo "📄 Reporte guardado en: $OUTPUT"
    fi
fi

echo ""
echo "🔍 Ejemplos de uso adicional:"
echo "  # Generar reporte HTML del backend:"
echo "  $0 -f template -t @contrib/html.tpl -o backend-report.html backend"
echo ""
echo "  # Generar reporte JSON de Angular:"
echo "  $0 -f json -o angular-report.json angular"
echo ""
echo "  # Escanear archivo JAR específico:"
echo "  $0 -f table backend/target/backend.jar"