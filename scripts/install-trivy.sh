#!/bin/bash

# Script para instalar Trivy en diferentes sistemas operativos

echo "📦 Instalando Trivy - Scanner de vulnerabilidades..."

# Verificar si Trivy ya está instalado
if command -v trivy &> /dev/null; then
    echo "✅ Trivy ya está instalado:"
    trivy --version
    exit 0
fi

# Detectar el sistema operativo
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Detectado: Linux"
    
    # Verificar distribución
    if [ -f /etc/debian_version ]; then
        echo "📦 Instalando en Debian/Ubuntu..."
        sudo apt-get update
        sudo apt-get install -y wget apt-transport-https gnupg lsb-release
        
        # Añadir repositorio de Trivy
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
        
        sudo apt-get update
        sudo apt-get install -y trivy
        
    elif [ -f /etc/redhat-release ]; then
        echo "📦 Instalando en Red Hat/CentOS/Fedora..."
        sudo tee -a /etc/yum.repos.d/trivy.repo << EOF
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
        sudo yum -y update
        sudo yum -y install trivy
        
    else
        echo "⚠️  Distribución Linux no reconocida. Instalando desde binario..."
        # Instalar desde GitHub releases
        TRIVY_VERSION=$(curl -s "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        wget https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/trivy_${TRIVY_VERSION#v}_Linux-64bit.tar.gz
        tar zxvf trivy_${TRIVY_VERSION#v}_Linux-64bit.tar.gz
        sudo mv trivy /usr/local/bin/
        rm trivy_${TRIVY_VERSION#v}_Linux-64bit.tar.gz
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Detectado: macOS"
    
    if command -v brew &> /dev/null; then
        echo "📦 Instalando con Homebrew..."
        brew install trivy
    else
        echo "⚠️  Homebrew no encontrado. Instalando desde binario..."
        # Instalar desde GitHub releases
        TRIVY_VERSION=$(curl -s "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        wget https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/trivy_${TRIVY_VERSION#v}_macOS-64bit.tar.gz
        tar zxvf trivy_${TRIVY_VERSION#v}_macOS-64bit.tar.gz
        sudo mv trivy /usr/local/bin/
        rm trivy_${TRIVY_VERSION#v}_macOS-64bit.tar.gz
    fi
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "🪟 Detectado: Windows"
    echo "📦 Para Windows, descarga Trivy desde:"
    echo "   https://github.com/aquasecurity/trivy/releases"
    echo "   O usa Chocolatey: choco install trivy"
    exit 1
    
else
    echo "❌ Sistema operativo no soportado: $OSTYPE"
    echo "📖 Consulta la documentación de instalación:"
    echo "   https://aquasecurity.github.io/trivy/latest/getting-started/installation/"
    exit 1
fi

# Verificar instalación
if command -v trivy &> /dev/null; then
    echo ""
    echo "✅ Trivy instalado correctamente!"
    trivy --version
    echo ""
    echo "🔍 Uso básico:"
    echo "  trivy fs .                                    # Escanear directorio actual"
    echo "  trivy fs --format table .                     # Formato tabla"
    echo "  trivy fs --format json .                      # Formato JSON"
    echo "  trivy fs --format template --template \"@contrib/html.tpl\" . # Formato HTML"
    echo ""
    echo "📚 Documentación completa:"
    echo "   https://aquasecurity.github.io/trivy/"
else
    echo "❌ Error en la instalación de Trivy"
    exit 1
fi