#!/usr/bin/env bash
# shellcheck disable=SC1091,2154

set -e

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  cp -rp src/insider/* vscode/
else
  cp -rp src/stable/* vscode/
fi

cp -f LICENSE vscode/LICENSE.txt

cd vscode || { echo "'vscode' dir not found"; exit 1; }

{ set +x; } 2>/dev/null

# {{{ product.json
cp product.json{,.bak}

setpath() {
  local jsonTmp
  { set +x; } 2>/dev/null
  jsonTmp=$( jq --arg 'value' "${3}" "setpath(path(.${2}); \$value)" "${1}.json" )
  echo "${jsonTmp}" > "${1}.json"
  set -x
}

setpath_json() {
  local jsonTmp
  { set +x; } 2>/dev/null
  jsonTmp=$( jq --argjson 'value' "${3}" "setpath(path(.${2}); \$value)" "${1}.json" )
  echo "${jsonTmp}" > "${1}.json"
  set -x
}

setpath "product" "checksumFailMoreInfoUrl" "https://go.microsoft.com/fwlink/?LinkId=828886"
setpath "product" "documentationUrl" "https://go.microsoft.com/fwlink/?LinkID=533484#vscode"
setpath_json "product" "extensionsGallery" '{"serviceUrl": "https://open-vsx.org/vscode/gallery", "itemUrl": "https://open-vsx.org/vscode/item", "latestUrlTemplate": "https://open-vsx.org/vscode/gallery/{publisher}/{name}/latest", "controlUrl": "https://raw.githubusercontent.com/EclipseFdn/publish-extensions/refs/heads/master/extension-control/extensions.json"}'

setpath "product" "introductoryVideosUrl" "https://go.microsoft.com/fwlink/?linkid=832146"
setpath "product" "keyboardShortcutsUrlLinux" "https://go.microsoft.com/fwlink/?linkid=832144"
setpath "product" "keyboardShortcutsUrlMac" "https://go.microsoft.com/fwlink/?linkid=832143"
setpath "product" "keyboardShortcutsUrlWin" "https://go.microsoft.com/fwlink/?linkid=832145"
setpath "product" "licenseUrl" "https://github.com/adra2n/zao/blob/main/LICENSE"
setpath_json "product" "linkProtectionTrustedDomains" '["https://open-vsx.org"]'
setpath "product" "releaseNotesUrl" "https://go.microsoft.com/fwlink/?LinkID=533483#vscode"
setpath "product" "reportIssueUrl" "https://github.com/adra2n/zao/issues/new"
setpath "product" "requestFeatureUrl" "https://go.microsoft.com/fwlink/?LinkID=533482"
setpath "product" "tipsAndTricksUrl" "https://go.microsoft.com/fwlink/?linkid=852118"
setpath "product" "twitterUrl" "https://go.microsoft.com/fwlink/?LinkID=533687"

if [[ "${DISABLE_UPDATE}" != "yes" ]]; then
  setpath "product" "updateUrl" "https://raw.githubusercontent.com/VSCodium/versions/refs/heads/master"

  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    setpath "product" "downloadUrl" "https://github.com/VSCodium/vscodium-insiders/releases"
  else
    setpath "product" "downloadUrl" "https://github.com/VSCodium/vscodium/releases"
  fi

  # if [[ "${OS_NAME}" == "windows" ]]; then
  #   setpath_json "product" "win32VersionedUpdate" "true"
  # fi
fi

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  setpath "product" "nameShort" "Zao - Insiders"
  setpath "product" "nameLong" "Zao - Insiders"
  setpath "product" "applicationName" "zao-insiders"
  setpath "product" "dataFolderName" ".zao-insiders"
  setpath "product" "linuxIconName" "zao-insiders"
  setpath "product" "quality" "insider"
  setpath "product" "urlProtocol" "zao-insiders"
  setpath "product" "serverApplicationName" "zao-server-insiders"
  setpath "product" "serverDataFolderName" ".zao-server-insiders"
  setpath "product" "dataFolderName" ".zao-insiders"
  setpath "product" "darwinBundleIdentifier" "com.zao.ZaoInsiders"
  setpath "product" "win32AppUserModelId" "Zao.ZaoInsiders"
  setpath "product" "win32DirName" "Zao Insiders"
  setpath "product" "win32MutexName" "zaoinsiders"
  setpath "product" "win32NameVersion" "Zao Insiders"
  setpath "product" "win32RegValueName" "ZaoInsiders"
  setpath "product" "win32ShellNameShort" "Zao Insiders"
  setpath "product" "win32AppId" "{{4AEC4738-32C0-4C10-9949-07F5E3870E7C}"
  setpath "product" "win32x64AppId" "{{E10F55AD-8282-481F-9696-FDA04383372C}"
  setpath "product" "win32arm64AppId" "{{49658453-5142-45A1-8D8D-EAACA1E5E9B3}"
  setpath "product" "win32UserAppId" "{{73087B6B-58B6-4294-9661-225D16F95531}"
  setpath "product" "win32x64UserAppId" "{{41C920D8-E13B-4723-9BC7-9703FF612DEA}"
  setpath "product" "win32arm64UserAppId" "{{77CB4BFB-69D1-427A-B231-80C8D4B44854}"
  setpath "product" "tunnelApplicationName" "zao-insiders-tunnel"
  setpath "product" "win32TunnelServiceMutex" "zaoinsiders-tunnelservice"
  setpath "product" "win32TunnelMutex" "zaoinsiders-tunnel"
  setpath "product" "win32ContextMenu.x64.clsid" "E0CDE833-CDE0-4594-B0AB-5751C202C1F1"
  setpath "product" "win32ContextMenu.arm64.clsid" "89E84112-C7FA-44E9-B405-3D142B123612"
else
  setpath "product" "nameShort" "Zao"
  setpath "product" "nameLong" "Zao"
  setpath "product" "applicationName" "zao"
  setpath "product" "linuxIconName" "zao"
  setpath "product" "quality" "stable"
  setpath "product" "urlProtocol" "zao"
  setpath "product" "serverApplicationName" "zao-server"
  setpath "product" "serverDataFolderName" ".zao-server"
  setpath "product" "dataFolderName" ".zao"
  setpath "product" "darwinBundleIdentifier" "com.zao"
  setpath "product" "win32AppUserModelId" "Zao.Zao"
  setpath "product" "win32DirName" "Zao"
  setpath "product" "win32MutexName" "zao"
  setpath "product" "win32NameVersion" "Zao"
  setpath "product" "win32RegValueName" "Zao"
  setpath "product" "win32ShellNameShort" "Zao"
  setpath "product" "win32AppId" "{{41C920D8-E13B-4723-9BC7-9703FF612DEA}"
  setpath "product" "win32x64AppId" "{{77CB4BFB-69D1-427A-B231-80C8D4B44854}"
  setpath "product" "win32arm64AppId" "{{E0CDE833-CDE0-4594-B0AB-5751C202C1F1}"
  setpath "product" "win32UserAppId" "{{89E84112-C7FA-44E9-B405-3D142B123612}"
  setpath "product" "win32x64UserAppId" "{{768D5791-3361-4328-8BD7-92EE71AE8A6A}"
  setpath "product" "win32arm64UserAppId" "{{ABB509CF-BA7E-49F1-A162-DA1B22150062}"
  setpath "product" "tunnelApplicationName" "zao-tunnel"
  setpath "product" "win32TunnelServiceMutex" "zao-tunnelservice"
  setpath "product" "win32TunnelMutex" "zao-tunnel"
  setpath "product" "win32ContextMenu.x64.clsid" "45001264-0DE6-4B32-8E2E-DF2CB462C90E"
  setpath "product" "win32ContextMenu.arm64.clsid" "05FA6EDE-BC35-4B49-9414-ED6F1E7EC1DE"
fi

setpath_json "product" "tunnelApplicationConfig" '{}'

jsonTmp=$( jq -s '.[0] * .[1]' product.json ../product.json )
echo "${jsonTmp}" > product.json && unset jsonTmp

cat product.json
# }}}

# include common functions
. ../utils.sh

# {{{ apply patches

echo "APP_NAME=\"${APP_NAME}\""
echo "APP_NAME_LC=\"${APP_NAME_LC}\""
echo "ASSETS_REPOSITORY=\"${ASSETS_REPOSITORY}\""
echo "BINARY_NAME=\"${BINARY_NAME}\""
echo "GH_REPO_PATH=\"${GH_REPO_PATH}\""
echo "GLOBAL_DIRNAME=\"${GLOBAL_DIRNAME}\""
echo "ORG_NAME=\"${ORG_NAME}\""
echo "TUNNEL_APP_NAME=\"${TUNNEL_APP_NAME}\""

if [[ "${DISABLE_UPDATE}" == "yes" && -f ../patches/00-update-disable.patch.yet ]]; then
  mv ../patches/00-update-disable.patch.yet ../patches/00-update-disable.patch
fi

for file in ../patches/*.json; do
  if [[ -f "${file}" ]]; then
    apply_actions "${file}"
  fi
done

for file in ../patches/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  for file in ../patches/insider/*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

if [[ -d "../patches/${OS_NAME}/" ]]; then
  for file in "../patches/${OS_NAME}/"*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

for file in ../patches/user/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done

# Inject the Zao (DSH) agent as a built-in extension.
if [[ -f "../dsh-inject.sh" ]]; then
  bash ../dsh-inject.sh
fi
# }}}

set -x

# {{{ install dependencies
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

if [[ "${OS_NAME}" == "linux" ]]; then
  export VSCODE_SKIP_NODE_VERSION_CHECK=1

   if [[ "${npm_config_arch}" == "arm" ]]; then
    export npm_config_arm_version=7
  fi
elif [[ "${OS_NAME}" == "windows" ]]; then
  if [[ "${npm_config_arch}" == "arm" ]]; then
    export npm_config_arm_version=7
  fi
else
  if [[ "${CI_BUILD}" != "no" ]]; then
    clang++ --version
  fi
fi

node build/npm/preinstall.ts

mv .npmrc .npmrc.bak
cp ../npmrc .npmrc

for i in {1..5}; do # try 5 times
  if [[ "${CI_BUILD}" != "no" && "${OS_NAME}" == "osx" ]]; then
    CXX=clang++ npm ci && break
  else
    npm ci && break
  fi

  if [[ $i == 5 ]]; then
    echo "Npm install failed too many times" >&2
    exit 1
  fi
  echo "Npm install failed $i, trying again..."

  sleep $(( 15 * (i + 1)))
done

mv .npmrc.bak .npmrc
# }}}

# package.json
cp package.json{,.bak}

setpath "package" "version" "${RELEASE_VERSION%-insider}"

replace 's|Microsoft Corporation|Zao|' package.json

cp resources/server/manifest.json{,.bak}

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  setpath "resources/server/manifest" "name" "VSCodium - Insiders"
  setpath "resources/server/manifest" "short_name" "VSCodium - Insiders"
else
  setpath "resources/server/manifest" "name" "Zao"
  setpath "resources/server/manifest" "short_name" "Zao"
fi

# announcements
replace "s|\\[\\/\\* BUILTIN_ANNOUNCEMENTS \\*\\/\\]|$( tr -d '\n' < ../announcements-builtin.json )|" src/vs/workbench/contrib/welcomeGettingStarted/browser/gettingStarted.ts

../undo_telemetry.sh

replace 's|Microsoft Corporation|Zao|' build/lib/electron.ts
replace 's|([0-9]) Microsoft|\1 Zao|' build/lib/electron.ts

if [[ "${OS_NAME}" == "linux" ]]; then
  # microsoft adds their apt repo to sources
  # unless the app name is code-oss
  # as we are renaming the application to vscodium
  # we need to edit a line in the post install template
  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    sed -i "s/code-oss/codium-insiders/" resources/linux/debian/postinst.template
  else
    sed -i "s/code-oss/codium/" resources/linux/debian/postinst.template
  fi

  # fix the packages metadata
  # code.appdata.xml
  sed -i 's|Visual Studio Code|VSCodium|g' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://github.com/VSCodium/vscodium#download-install|' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com/home/home-screenshot-linux-lg.png|https://vscodium.com/img/vscodium.png|' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com|https://vscodium.com|' resources/linux/code.appdata.xml

  # control.template
  sed -i 's|Microsoft Corporation <vscode-linux@microsoft.com>|VSCodium Team https://github.com/VSCodium/vscodium/graphs/contributors|'  resources/linux/debian/control.template
  sed -i 's|Visual Studio Code|VSCodium|g' resources/linux/debian/control.template
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://github.com/VSCodium/vscodium#download-install|' resources/linux/debian/control.template
  sed -i 's|https://code.visualstudio.com|https://vscodium.com|' resources/linux/debian/control.template

  # code.spec.template
  sed -i 's|Microsoft Corporation|VSCodium Team|' resources/linux/rpm/code.spec.template
  sed -i 's|Visual Studio Code Team <vscode-linux@microsoft.com>|VSCodium Team https://github.com/VSCodium/vscodium/graphs/contributors|' resources/linux/rpm/code.spec.template
  sed -i 's|Visual Studio Code|VSCodium|' resources/linux/rpm/code.spec.template
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://github.com/VSCodium/vscodium#download-install|' resources/linux/rpm/code.spec.template
  sed -i 's|https://code.visualstudio.com|https://vscodium.com|' resources/linux/rpm/code.spec.template

  # snapcraft.yaml
  sed -i 's|Visual Studio Code|VSCodium|' resources/linux/rpm/code.spec.template
elif [[ "${OS_NAME}" == "windows" ]]; then
  # code.iss
  sed -i 's|https://code.visualstudio.com|https://vscodium.com|' build/win32/code.iss
  sed -i 's|Microsoft Corporation|VSCodium|' build/win32/code.iss
fi

cd ..
