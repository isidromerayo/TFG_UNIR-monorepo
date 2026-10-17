#!/usr/bin/env bash
# Orquestador de auditoría de accesibilidad (pa11y) para los 3 frontends.
# Advisory: nunca falla por hallazgos, solo por fallo de arranque/preflight.

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORTS_ROOT="$ROOT_DIR/reports/a11y"

# Resolución de pnpm (binario global > corepack)
run_pnpm() {
    if command -v pnpm >/dev/null 2>&1; then
        pnpm "$@"
    elif command -v corepack >/dev/null 2>&1; then
        corepack pnpm "$@"
    else
        echo "⚠️  Ni pnpm ni corepack disponibles" >&2
        return 127
    fi
}

# Preflight: backend en :8080
if ! curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/categorias 2>/dev/null | grep -q '^2'; then
    echo "❌ Backend no responde en http://localhost:8080/api (necesario para /categorias, /categoria/:id, /curso/:id)."
    echo "   Arráncalo antes de ejecutar este script."
    exit 1
fi
echo "✅ Backend disponible en :8080"

# Definición por proyecto: dir, comando de arranque, puerto
PROJECTS=(
    "angular|angular|start|4200"
    "react|react|dev|3000"
    "vue3|vue3|dev|5173"
)

declare -A PID_MAP

cleanup() {
    for pid in "${!PID_MAP[@]}"; do
        if kill -0 "${PID_MAP[$pid]}" 2>/dev/null; then
            kill "${PID_MAP[$pid]}" 2>/dev/null || true
            wait "${PID_MAP[$pid]}" 2>/dev/null || true
        fi
    done
}
trap cleanup EXIT INT TERM

wait_for_port() {
    local port="$1" timeout="${2:-120}" i=0
    while [ "$i" -lt "$timeout" ]; do
        if curl -s -o /dev/null "http://localhost:${port}/" 2>/dev/null; then
            return 0
        fi
        sleep 1
        i=$((i + 1))
    done
    return 1
}

mkdir -p "$REPORTS_ROOT"

# Resultados para el resumen
SUMMARY=""

for entry in "${PROJECTS[@]}"; do
    IFS='|' read -r name dir script port <<< "$entry"
    proj_path="$ROOT_DIR/$dir"
    if [ ! -d "$proj_path" ]; then
        echo "⚠️  Directorio $dir no encontrado, saltando."
        continue
    fi

    echo ""
    echo "🔍 Auditando $name (puerto $port)..."

    # Arrancar dev server
    (cd "$proj_path" && run_pnpm run "$script" >/tmp/opencode/${name}-dev.log 2>&1) &
    server_pid=$!
    PID_MAP[$name]=$server_pid

    if ! wait_for_port "$port" 120; then
        echo "❌ $name no arrancó en :$port (ver /tmp/opencode/${name}-dev.log)"
        SUMMARY="${SUMMARY}${name}|?|?|?|FAIL_START\n"
        continue
    fi
    echo "✅ $name listo en :$port"

    # Ejecutar pa11y
    (cd "$proj_path" && run_pnpm run a11y) >/tmp/opencode/${name}-a11y.log 2>&1
    a11y_exit=$?

    # Copiar informes
    dest="$REPORTS_ROOT/$name"
    mkdir -p "$dest"
    if [ -d "$proj_path/reports/a11y" ]; then
        rm -rf "$dest"/*
        cp -r "$proj_path/reports/a11y/." "$dest/" 2>/dev/null || true
    fi

    # Parsear report.json
    report="$proj_path/reports/a11y/report.json"
    if [ -f "$report" ]; then
        total=$(jq '.total // 0' "$report")
        passes=$(jq '.passes // 0' "$report")
        errors=$(jq '.errors // 0' "$report")
    else
        total="?"; passes="?"; errors="?"
    fi

    echo "   $name → total=$total passes=$passes errors=$errors (exit=$a11y_exit)"
    SUMMARY="${SUMMARY}${name}|${total}|${passes}|${errors}|${a11y_exit}\n"

    # Matar servidor
    if kill -0 "$server_pid" 2>/dev/null; then
        kill "$server_pid" 2>/dev/null || true
        wait "$server_pid" 2>/dev/null || true
    fi
    unset 'PID_MAP[$name]'
done

echo ""
echo "📊 Resumen comparativo de accesibilidad:"
printf "   %-10s %6s %8s %8s %6s\n" "Proyecto" "URLs" "Passes" "Errors" "Exit"
while IFS='|' read -r name total passes errors exitcode; do
    [ -z "$name" ] && continue
    printf "   %-10s %6s %8s %8s %6s\n" "$name" "$total" "$passes" "$errors" "$exitcode"
done < <(printf "%b" "$SUMMARY")

echo ""
echo "📁 Informes en: $REPORTS_ROOT"
exit 0