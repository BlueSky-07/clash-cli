#!/bin/bash
source "$HOME/.clash-cli/bootstrap.sh"

URL_CLASH_REPO="https://api.github.com/repos/Dreamacro/clash"
URL_CLASH_REPO_RELEASES="$URL_CLASH_REPO/releases"

ASSET_CLASH_RELEASES_JSON="$CLASH_CLI_ASSETS_DIR/clash-releases.json"

dependency_check curl "https://curl.haxx.se/download.html"
dependency_check jq   "https://stedolan.github.io/jq/download/"
dependency_check gzip "https://www.gnu.org/software/gzip/"

filename_pattern() {
  case $(uname) in
    "Linux")
      case $(uname -i) in
        "x86_64")
          echo "linux-amd64"
          ;;
        *86)
          echo "linux-386"
          ;;
      esac
      ;;
    "Darwin")
      echo "darwin-amd64"
      ;;
    esac
}

clash_cli_install_clash__fetch() {
  curl -o "$ASSET_CLASH_RELEASES_JSON" "$URL_CLASH_REPO_RELEASES"
}

clash_cli_install_clash__list() {
  if [ ! -f "$ASSET_CLASH_RELEASES_JSON" ]
  then
    clash_cli_install_clash__fetch
  fi

  count="$1"
  if [ -z "$count" ]
  then
    count=5
  fi

  cat "$ASSET_CLASH_RELEASES_JSON" \
    | jq --arg COUNT "$count"      \
          -r '.[0:$COUNT|tonumber]
            | .[]
            | { tag_name, published_at, html_url, body, prerelease }
            | .tag_name + "\n"
              + "\t" + (.published_at | fromdate | strflocaltime("%Y-%m-%d %H:%M:%S (%Z)")) + "\n"
              + "\t" + .html_url + "\n"
              + "\t" + "pre-release: " + (.prerelease | tostring)
    '
}

clash_cli_install_clash__info() {
  if [ ! -f "$ASSET_CLASH_RELEASES_JSON" ]
  then
    clash_cli_install_clash__fetch
  fi

  version=$1
  if [ -z "$version" ]
  then
    local latest_version=$(
      cat "$ASSET_CLASH_RELEASES_JSON" \
        | jq -r '.[0:1]
                | .[]
                | .tag_name
          '
    )
    if $VERBOSE
    then
      echo "latest_version: $latest_version"
    fi
    version="$latest_version"
  fi

  cat "$ASSET_CLASH_RELEASES_JSON" \
    | jq --arg VERSION "$version"  \
          -r '.[]
            | { tag_name, published_at, html_url, body, prerelease }
            | select(.tag_name | test($VERSION))
            | .tag_name + "\n"
              + "\t" + (.published_at | fromdate | strflocaltime("%Y-%m-%d %H:%M:%S (%Z)")) + "\n"
              + "\t" + .html_url + "\n"
              + "\t" + "pre-release: " + (.prerelease | tostring) + "\n"
              + "\n" + .body + "\n"
    '
}

clash_cli_install_clash__asset() {
  if [ ! -f "$ASSET_CLASH_RELEASES_JSON" ]
  then
    clash_cli_install_clash__fetch
  fi

  version=$1
  if [ -z "$version" ]
  then
    local latest_version=$(
      cat "$ASSET_CLASH_RELEASES_JSON" \
        | jq -r '.[0:1]
                | .[]
                | .tag_name
          '
    )
    if $VERBOSE
    then
      echo "latest_version: $latest_version"
    fi
    version="$latest_version"
  fi

  local assets=$(                      \
      cat "$ASSET_CLASH_RELEASES_JSON" \
    | jq --arg VERSION "$version"      \
          -r '.[]
            | { tag_name, assets }
            | select(.tag_name | test($VERSION))
            | .assets
                | .[]
                | { name, browser_download_url, updated_at, download_count }
                | .browser_download_url + "\n"
                  + "\t" + (.updated_at | fromdate | strflocaltime("%Y-%m-%d %H:%M:%S (%Z)")) + "\n"
                  + "\t" + "download count: " + (.download_count | tostring) + "\n"
      ')

  if $VERBOSE
  then
    echo "$assets"
  else
    echo "$assets" | grep $(filename_pattern)
  fi
}

clash_cli_install_clash__install() {
  if [ -f "$CLASH_BIN" ]
  then
    echo "clash found at $CLASH_BIN"
    echo "override? (y/n)"
    if $YES
    then
      echo "y"
    else
      read -p "" confirm
      if [[ ! $confirm == [yY] ]]
      then
        echo "canceled"
        exit 0
      fi
    fi
  fi

  local verbose=$VERBOSE
  VERBOSE=false
  local asset="$(clash_cli_install_clash__asset)"
  if [ -z "$asset" ]
  then
    echo "cannot auto get bin asset url, please download clash bin manually"
    exit 41
  fi

  VERBOSE=$verbose
  if $VERBOSE
  then
    echo "downloading from $asset"
  fi

  local full_filename="$(basename $asset)"
  local full_filepath="$CLASH_CLI_ASSETS_DIR/$full_filename"
  local filename="${full_filename%.*}"
  local filepath="$CLASH_CLI_ASSETS_DIR/$filename"

  curl -L $asset -o $full_filepath
  gzip -d $full_filepath
  mv $filepath $CLASH_BIN
  chmod +x $CLASH_BIN

  echo "all done"
  echo "installed at $CLASH_BIN"
  $CLASH_BIN -v
}

clash_cli_install_clash__help() {
  echo "clash-cli install {command} {?arguments} {?--verbose|-v} {?--yes|-y}"
  echo "commands:"
  echo "    #none            : install clash bin"
  echo "    fetch            : fetch latest clash release info"
  echo "    list {?count}    : list all versions info"
  echo "    info {?version}  : show specific or latest version detail"
  echo "    asset {?version} : show specific or latest version assets info"
  echo "    help             : show plugin<install-clash> help info"
  echo "    version          : show plugin<install-clash> version info"
}

clash_cli_install_clash() {
  if [ -z "$1" ]
  then
    clash_cli_install_clash__install
    return
  fi

  local command="$1"
  case $command in
    "fetch")
      clash_cli_install_clash__fetch ${@:2}
      ;;
    "list")
      clash_cli_install_clash__list ${@:2}
      ;;
    "info")
      clash_cli_install_clash__info ${@:2}
      ;;
    "asset")
      clash_cli_install_clash__asset ${@:2}
      ;;
    "help")
      clash_cli_install_clash__help
      ;;
    "version")
      print_version "Install-Clash" "$PLUGIN_INSTALL_CLASH_VERSION"
      ;;
    *)
      echo "command \"$command\" not found"
      clash_cli_install_clash__help
      exit 2
      ;;
  esac
}

clash_cli_install_clash "$@"