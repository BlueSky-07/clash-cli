#!/bin/bash

# Version
MAIN_VERSION="v0.3"
PLUGIN_GITHUB_VERSION="v0.1"
PLUGIN_INSTALL_CLASH_VERSION="v0.2"
PLUGIN_INSTALL_CLASH_CLI_VERSION="v0.1"
PLUGIN_RUNTIME_VERSION="v0.1"

# Directory
CLASH_CONFIG_DIR="$HOME/.config/clash"
CLASH_CONFIG_FILE="$CLASH_CONFIG_DIR/config.yaml"
CLASH_CLI_DIR="$HOME/.clash-cli"
CLASH_BIN="$CLASH_CLI_DIR/clash"
CLASH_CLI_PLUGINS_DIR="$CLASH_CLI_DIR/plugins"
CLASH_CLI_LOGS_DIR="$CLASH_CLI_DIR/logs"
CLASH_CLI_CONFIGS_DIR="$CLASH_CLI_DIR/configs"
CLASH_CLI_ASSETS_DIR="$CLASH_CLI_DIR/assets"
CLASH_CLI_CACHES_DIR="$CLASH_CLI_DIR/caches"

# File
CLASH_CLI_LOG="$CLASH_CLI_LOGS_DIR/history.log"

# Plugin
PLUGIN_GITHUB_SH="$CLASH_CLI_PLUGINS_DIR/github.sh"
PLUGIN_INSTALL_CLASH_SH="$CLASH_CLI_PLUGINS_DIR/install-clash.sh"
PLUGIN_INSTALL_CLASH_CLI_SH="$CLASH_CLI_PLUGINS_DIR/install-clash-cli.sh"
PLUGIN_RUNTIME_SH="$CLASH_CLI_PLUGINS_DIR/runtime/runtime.sh"

# Preparation
mkdir -p "$CLASH_CLI_LOGS_DIR"
mkdir -p "$CLASH_CLI_CONFIGS_DIR"
mkdir -p "$CLASH_CLI_ASSETS_DIR"
mkdir -p "$CLASH_CLI_CACHES_DIR"

check_bin() {
  if [ ! -f "$CLASH_BIN" ]
  then
    echo "clash not found"
    echo "download latest clash from https://github.com/Dreamacro/clash/releases"
    echo "unpack bin from zip/tar, copy to $CLASH_BIN"
    exit 1
  fi
}

dependency_check() {
  local dependency=$1
  if [ -z $(command -v $dependency) ]
  then
    echo "missing dependency: $dependency"
    case $(uname) in
    "Linux")
      echo "try apt(-get)/dnf/zypper/pacman install $dependency"
      ;;
    "Darwin")
      echo "try brew/port install $dependency"
    esac
    local homepage=$2
    if [ ! -z $homepage ]
    then
      echo "visit $homepage for more info"
    fi
    exit 9
  fi
}

print_version() {
  echo "Clash Command-Line Interface $MAIN_VERSION @BlueSky-07"
  if [ ! -z $1 ] && [ ! -z $2 ]
  then
    echo "Plugin - $1 $2"
  fi
  echo "visit https://github.com/BlueSky-07/clash-cli for more information"
  $CLASH_BIN -v
}