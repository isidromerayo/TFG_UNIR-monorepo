#!/usr/bin/env bash
#
# check-accepted-advisories.sh (monorepo)
#
# Ejecuta la revisión de advisories aceptados (sin parche upstream) de cada
# submódulo que la implemente. Regla y registro de cada proyecto:
# <proyecto>/docs/security/accepted-advisories.md
#
# Falla si algún advisory aceptado ya tiene versión parcheada publicada: entonces
# hay que subir la dependencia y retirar el silencio en ese proyecto.
#
# Uso: ./scripts/check-accepted-advisories.sh
# Requiere: bash, curl, jq
#
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUBMODULES=(backend angular react vue3)
FAILS=0
CHECKED=0

for module in "${SUBMODULES[@]}"; do
  echo "===== $module ====="
  script="$ROOT/$module/scripts/check-accepted-advisories.sh"

  if [ ! -x "$script" ]; then
    echo "⏭️  $module no tiene (todavía) el chequeo de advisories aceptados."
    echo
    continue
  fi

  CHECKED=$((CHECKED + 1))
  ( cd "$ROOT/$module" && ./scripts/check-accepted-advisories.sh ) || FAILS=$((FAILS + 1))
  echo
done

echo "---"
if [ "$FAILS" -gt 0 ]; then
  echo "❌ $FAILS submódulo(s) con advisories aceptados que ya tienen parche (ver arriba)."
  exit 1
fi

echo "✅ Revisión de advisories aceptados OK en $CHECKED submódulo(s)."
