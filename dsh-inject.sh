#!/usr/bin/env bash
# Injects the Codon (DSH) agent extension into the freshly-cloned vscode source
# so it is compiled by the vscode build and shipped as a built-in extension.
# Runs from the vscode/ working dir (called by prepare_vscode.sh).
#
# NOTE: the zero-dependency DSH runtime is NOT handled here. After packaging,
# run dsh-vscode-ide/scripts/vendor-dsh.sh <app>/Contents/Resources/app to
# vendor @deepseek-ai/dsh into app/dsh-runtime/ (the extension auto-detects it
# and starts the gateway via the Codon binary in Node mode).
set -e

SRC="${DSH_AGENT_SRC:-../dsh-agent-extension}"
if [ ! -d "$SRC" ]; then
  SRC="/Users/adrain/Desktop/project/dsh-vscode-ide/dsh-agent-extension"
fi
if [ ! -d "$SRC" ]; then
  echo "dsh-inject: extension source not found (set DSH_AGENT_SRC)" >&2
  exit 1
fi
DST="extensions/dsh-agent"

echo "dsh-inject: copying ${SRC} -> ${DST}"
rm -rf "${DST}"
mkdir -p "${DST}"
cp -R "${SRC}/." "${DST}/"

# The vscode monorepo compiles built-in extensions against its own base tsconfig
# and the in-repo vscode.d.ts (not @types/vscode). Replace the standalone tsconfig.
cat > "${DST}/tsconfig.json" <<'EOF'
{
  "extends": "../tsconfig.base.json",
  "compilerOptions": {
    "rootDir": "./src",
    "outDir": "./out",
    "types": ["node"],
    "typeRoots": ["./node_modules/@types"]
  },
  "include": [
    "src/**/*",
    "../../src/vscode-dts/vscode.d.ts"
  ]
}
EOF

# Drop the standalone dev dependencies / node_modules so the monorepo build owns deps.
rm -rf "${DST}/node_modules" "${DST}/out" "${DST}/package-lock.json"

# --- Brand icons (P4.4): overwrite the stock VSCodium/vscode artwork so every
# build ships Codon branding. Assets live in the extension repo under media/brand.
BRAND_DIR="${DSH_AGENT_SRC%/}/media/brand"
if [ -f "$BRAND_DIR/codon.icns" ]; then
  cp "$BRAND_DIR/codon.icns" "resources/darwin/code.icns"
  cp "$BRAND_DIR/codon.ico" "resources/win32/code.ico"
  cp "$BRAND_DIR/codon-512.png" "resources/linux/code.png"
  for f in resources/linux/code_*.png; do
    [ -f "$f" ] && cp "$BRAND_DIR/codon-512.png" "$f"
  done
  echo "dsh-inject: brand icons applied (darwin/win32/linux)"
fi

echo "dsh-inject: done."
