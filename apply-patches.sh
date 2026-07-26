#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:-source}"

ACCOUNTS_FILE="$SOURCE_DIR/ZalithLauncher/src/main/java/com/movtery/zalithlauncher/game/account/AccountsManager.kt"

# --- Patch: Bypass offline limit ---
echo "[1/1] Bypassing offline limit..."

if grep -q 'return !circumventLimit.exists()' "$ACCOUNTS_FILE"; then
  sed -i 's|return !circumventLimit.exists()|return circumventLimit.exists()|' "$ACCOUNTS_FILE"
  echo "  - Inverted circumventLimit check"
else
  echo "  ! Pattern not found (already patched?)"
fi

echo "=== Done ==="
