#!/usr/bin/env bash
# Clean Codon-branded rebuild of the VSCodium fork.
# Resets the vscode/ working tree so the de-MS + Codon patches re-apply cleanly,
# then builds with branding (Codon) + the injected dsh-agent built-in extension.
set -e

cd /Users/adrain/Desktop/project/vscodium-fork

export DISABLE_UPDATE=yes
export OS_NAME=osx
export SHOULD_BUILD=yes
export CI_BUILD=yes
export VSCODE_QUALITY=stable
export VSCODE_ARCH=x64

# Brand the de-MS patches (utils.sh derives !!APP_NAME!! etc. from these).
export APP_NAME="Codon"
export APP_NAME_LC="codon"
export BINARY_NAME="codon"
export GLOBAL_DIRNAME="codon"
export ORG_NAME="Codon"
export GH_REPO_PATH="codon-ide/codon"
export ASSETS_REPOSITORY="codon-ide/codon"
export TUNNEL_APP_NAME="codon-tunnel"

# Where the agent extension source lives (sibling project by default).
export DSH_AGENT_SRC="/Users/adrain/Desktop/project/dsh-vscode-ide/dsh-agent-extension"

# The vscode build compiles extensions from a HARDCODED list in
# build/gulpfile.extensions.ts, so it will NOT compile dsh-agent.
# Pre-compile out/ here; dsh-inject.sh then copies it into the app.
if [ -d "$DSH_AGENT_SRC" ]; then
  ( cd "$DSH_AGENT_SRC" && npm run compile )
fi

# Use the node pinned by VSCodium (.nvmrc -> 24.15.0)
source ~/.nvm/nvm.sh 2>/dev/null || true
nvm use 24.15.0 2>/dev/null || nvm use 24 2>/dev/null || true
echo "node: $(node -v)"

echo "Resetting vscode/ tree so patches re-apply cleanly..."
if [ -d vscode/.git ]; then
  ( cd vscode && git checkout -- . && git clean -fdx -e node_modules )
fi

echo "Running build.sh (Codon branded + dsh-agent injected)..."
./build.sh 2>&1 | tee /tmp/codon-build.log

# The vscode packaging filter drops out/ of extensions it does not compile
# itself, so copy the pre-compiled extension into the packaged app.
APP_EXT="VSCode-darwin-x64/Codon.app/Contents/Resources/app/extensions/dsh-agent"
if [ -d "$DSH_AGENT_SRC" ] && [ -d "VSCode-darwin-x64/Codon.app/Contents/Resources/app" ]; then
  mkdir -p "$APP_EXT/out"
  cp "$DSH_AGENT_SRC"/out/*.js "$APP_EXT/out/"
  echo "Copied compiled dsh-agent into app: $APP_EXT/out ($(ls "$APP_EXT/out" | wc -l | tr -d ' ') files)"
fi

# Vendor the pinned DSH runtime for zero-dependency distribution (tasks P4.2).
if [ -f /Users/adrain/Desktop/project/dsh-vscode-ide/scripts/vendor-dsh.sh ]; then
  bash /Users/adrain/Desktop/project/dsh-vscode-ide/scripts/vendor-dsh.sh \
    "VSCode-darwin-x64/Codon.app/Contents/Resources/app" || echo "WARN: vendor-dsh failed; run manually"
fi

echo "Codon build completed."
