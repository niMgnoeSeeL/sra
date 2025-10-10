#!/usr/bin/env bash
set -euo pipefail

# =========================================
# Usage / flags
# =========================================
DRY_RUN=0
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then
  DRY_RUN=1
elif [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<'USAGE'
setup_clang_tooling.sh [-n|--dry-run]
  Checks and installs (via apt) the packages needed to build/run a Clang LibTooling app.
  -n, --dry-run   Do everything except the actual apt install/update.
USAGE
  exit 0
fi

# =========================================
# Config: packages & key artifacts
# =========================================
APT_PACKAGES=(
  build-essential
  cmake
  gcc
  g++
  llvm-20-dev
  clang-20
  libclang-cpp20-dev
  libclang-20-dev
  libclang-common-20-dev
  libedit-dev
  zlib1g-dev
  libzstd-dev
  libxml2-dev
  libffi-dev
  libcurl4-openssl-dev
  bear
)

KEY_FILES=(
  "/usr/lib/llvm-20/lib/libclang-cpp.so"
  "/usr/lib/llvm-20/include/clang/Tooling/Tooling.h"
)
KEY_DIRS=(
  "/usr/lib/llvm-20/cmake"
  "/usr/lib/cmake/clang-20"
)

# =========================================
# Helpers
# =========================================
have_cmd() { command -v "$1" >/dev/null 2>&1; }

is_debian_like() { [[ -f /etc/debian_version ]] || [[ -d /etc/apt ]]; }

pkg_installed_apt() {
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

print_header() { echo -e "\n==================== $* ====================\n"; }

check_packages_apt() {
  local -n arr=$1
  local missing=()
  for p in "${arr[@]}"; do
    if pkg_installed_apt "$p"; then
      printf "✔ %-28s installed\n" "$p"
    else
      printf "✘ %-28s missing\n" "$p"
      missing+=("$p")
    fi
  done
  echo
  if ((${#missing[@]})); then
    echo "Missing packages (${#missing[@]}): ${missing[*]}"
  else
    echo "All required packages are installed."
  fi
  # Return list via stdout sentinel
  echo "__MISSING__:${missing[*]}"
}

check_artifacts() {
  local ok=0
  echo "Checking key directories:"
  for d in "${KEY_DIRS[@]}"; do
    if [[ -d "$d" ]]; then
      printf "  ✔ %s\n" "$d"
    else
      printf "  ✘ %s (not found)\n" "$d"
      ok=1
    fi
  done
  echo "Checking key files:"
  for f in "${KEY_FILES[@]}"; do
    if [[ -e "$f" ]]; then
      printf "  ✔ %s\n" "$f"
    else
      printf "  ✘ %s (not found)\n" "$f"
      ok=1
    fi
  done
  return $ok
}

print_llvm_cmake_hint() {
  if have_cmd llvm-config-20; then
    local cmakedir
    cmakedir="$(llvm-config-20 --cmakedir || true)"
    [[ -n "$cmakedir" ]] && echo "llvm-config-20 --cmakedir => $cmakedir"
  else
    echo "llvm-config-20 not found on PATH."
  fi
}

run_or_echo() {
  if ((DRY_RUN)); then
    echo "[DRY-RUN] $*"
  else
    eval "$@"
  fi
}

# =========================================
# Pre-check
# =========================================
print_header "Pre-check: packages"
if ! is_debian_like; then
  echo "This script supports Debian/Ubuntu via apt."
  echo "Detected non-Debian system. Aborting."
  exit 1
fi

MISSING_LINE="$(check_packages_apt APT_PACKAGES | tail -n1)"
MISSING_PACKAGES=()
if [[ "$MISSING_LINE" == __MISSING__:* ]]; then
  # shellcheck disable=SC2206
  MISSING_PACKAGES=(${MISSING_LINE#__MISSING__:})
fi

print_header "Pre-check: LLVM/Clang artifacts"
check_artifacts || true
print_llvm_cmake_hint

# =========================================
# Install (only missing)
# =========================================
if ((${#MISSING_PACKAGES[@]})); then
  print_header "Installing missing packages (apt)"
  echo "Missing: ${MISSING_PACKAGES[*]}"
  if ((DRY_RUN)); then
    echo "[DRY-RUN] sudo apt-get update"
    echo "[DRY-RUN] sudo apt-get install -y ${MISSING_PACKAGES[*]}"
  else
    sudo apt-get update
    sudo apt-get install -y "${MISSING_PACKAGES[@]}"
  fi
else
  echo -e "\nNothing to install."
fi

# =========================================
# Post-check
# =========================================
print_header "Post-check: packages"
check_packages_apt APT_PACKAGES >/dev/null

print_header "Post-check: LLVM/Clang artifacts"
ARTIFACTS_OK=0
check_artifacts || ARTIFACTS_OK=$?
print_llvm_cmake_hint

# =========================================
# Final tips
# =========================================
print_header "Summary & tips"
if ((ARTIFACTS_OK==0)); then
  echo "✅ Environment looks good."
else
  echo "⚠ Some key files/dirs still missing. If you use non-default prefixes,"
  echo "  adjust KEY_FILES/KEY_DIRS in this script to match your layout."
fi

echo
echo "To configure your project (Debug + compile_commands.json):"
echo "  cmake -S . -B build \\"
echo "        -DCMAKE_BUILD_TYPE=Debug \\"
echo "        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \\"
echo "        -DLLVM_DIR=\$(llvm-config-20 --cmakedir)"
echo
echo "To build:"
echo "  cmake --build build -j\$(nproc)"
echo
echo "If runtime can't find libclang-cpp.so:"
echo "  export LD_LIBRARY_PATH=/usr/lib/llvm-20/lib:\$LD_LIBRARY_PATH"
