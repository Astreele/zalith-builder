#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:-source}"

ACCOUNTS_FILE="$SOURCE_DIR/ZalithLauncher/src/main/java/com/movtery/zalithlauncher/game/account/AccountsManager.kt"
URL_FILE="$SOURCE_DIR/ZalithLauncher/src/main/java/com/movtery/zalithlauncher/path/UrlManager.kt"

# --- Patch: Bypass offline limit ---
echo "[1/1] Bypassing offline limit..."

if grep -q 'return !circumventLimit.exists()' "$ACCOUNTS_FILE"; then
  sed -i 's|return !circumventLimit.exists()|return circumventLimit.exists()|' "$ACCOUNTS_FILE"
  echo "  - Inverted circumventLimit check"
else
  echo "  ! Pattern not found (already patched?)"
fi

# --- Patch 0002: Point URLs to patches repo ---
echo "[2/2] Pointing URLs to patches repo..."

if grep -q 'const val URL_PROJECT: String = "https://github.com/ZalithLauncher/ZalithLauncher2"' "$URL_FILE"; then
  sed -i 's|const val URL_PROJECT: String = "https://github.com/ZalithLauncher/ZalithLauncher2"|const val URL_PROJECT: String = "https://github.com/Astreele/zalith-builder"|' "$URL_FILE"
  echo "  - Updated URL_PROJECT"
else
  echo "  ! URL_PROJECT pattern not found (already updated?)"
fi

if grep -q 'const val URL_PROJECT_INFO: String = "https://api.github.com/repos/ZalithLauncher/Zalith-Info/contents/v2"' "$URL_FILE"; then
  sed -i 's|const val URL_PROJECT_INFO: String = "https://api.github.com/repos/ZalithLauncher/Zalith-Info/contents/v2"|const val URL_PROJECT_INFO: String = "https://api.github.com/repos/Astreele/zalith-builder/contents"|' "$URL_FILE"
  echo "  - Updated URL_PROJECT_INFO"
else
  echo "  ! URL_PROJECT_INFO pattern not found (already updated?)"
fi

echo "=== Done ==="
