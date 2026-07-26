#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:-source}"

ACCOUNTS_FILE="$SOURCE_DIR/ZalithLauncher/src/main/java/com/movtery/zalithlauncher/game/account/AccountsManager.kt"
URL_FILE="$SOURCE_DIR/ZalithLauncher/src/main/java/com/movtery/zalithlauncher/path/UrlManager.kt"

# --- Patch 0001: Remove geo-restriction ---
echo "[1/2] Removing geo-restriction..."

if grep -q '^import com\.movtery\.zalithlauncher\.utils\.isInGreaterChina$' "$ACCOUNTS_FILE"; then
  sed -i '/^import com\.movtery\.zalithlauncher\.utils\.isInGreaterChina$/d' "$ACCOUNTS_FILE"
  echo "  - Removed isInGreaterChina import"
else
  echo "  ! isInGreaterChina import not found (already removed?)"
fi

if grep -q '^        val isOffline = checkLimit()$' "$ACCOUNTS_FILE"; then
  sed -i '/^        val isOffline = checkLimit()$/,/^        _isOffline.update { isOffline }$/c\        _currentAccountFlow.update { currentAccount }\n        _isOffline.update { false }' "$ACCOUNTS_FILE"
  echo "  - Replaced refreshCurrentAccountState body"
else
  echo "  ! Line 'val isOffline = checkLimit()' not found (already patched?)"
fi

if grep -q '^    private fun checkLimit(): Boolean {$' "$ACCOUNTS_FILE"; then
  sed -i '/^    private fun checkLimit(): Boolean {$/,/^    }$/d' "$ACCOUNTS_FILE"
  echo "  - Removed checkLimit() function"
else
  echo "  ! checkLimit() function not found (already removed?)"
fi

# --- Patch 0002: Point URLs to patches repo ---
echo "[2/2] Pointing URLs to patches repo..."

if grep -q 'const val URL_PROJECT: String = "https://github.com/ZalithLauncher/ZalithLauncher2"' "$URL_FILE"; then
  sed -i 's|const val URL_PROJECT: String = "https://github.com/ZalithLauncher/ZalithLauncher2"|const val URL_PROJECT: String = "https://github.com/Astreele/ZalithLauncher2-patches"|' "$URL_FILE"
  echo "  - Updated URL_PROJECT"
else
  echo "  ! URL_PROJECT pattern not found (already updated?)"
fi

if grep -q 'const val URL_PROJECT_INFO: String = "https://api.github.com/repos/ZalithLauncher/Zalith-Info/contents/v2"' "$URL_FILE"; then
  sed -i 's|const val URL_PROJECT_INFO: String = "https://api.github.com/repos/ZalithLauncher/Zalith-Info/contents/v2"|const val URL_PROJECT_INFO: String = "https://api.github.com/repos/Astreele/ZalithLauncher2-patches/contents"|' "$URL_FILE"
  echo "  - Updated URL_PROJECT_INFO"
else
  echo "  ! URL_PROJECT_INFO pattern not found (already updated?)"
fi

echo "=== Done ==="
