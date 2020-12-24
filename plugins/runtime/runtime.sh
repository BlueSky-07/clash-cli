#!/bin/bash

dependency_check curl "https://curl.haxx.se/download.html"
dependency_check jq   "https://stedolan.github.io/jq/download/"

# Url
# https://github.com/Dreamacro/clash/blob/e6aa452b5193d61e7d84ba9c4aae6ee6cbb20d5d/hub/route/server.go#L63
URL_HELLO="/"
URL_LOGS="/logs"
URL_TRAFFIC="/traffic"
URL_VERSION="/version"
URL_CONFIGS="/configs"
URL_PROXIES="/proxies"
URL_RULES="/rules"
URL_CONNECTIONS="/connections"
URL_PROVIDERS_PROXIES="/providers/proxies"

# Directory
PLUGIN_RUNTIME_DIR="$CLASH_CLI_PLUGINS_DIR/runtime"

# File
PLUGIN_RUNTIME_LOG="$CLASH_CLI_LOGS_DIR/runtime.log"

# Component
PLUGIN_RUNTIME_HELLO_SH="$PLUGIN_RUNTIME_DIR/hello.sh"
PLUGIN_RUNTIME_LOGS_SH="$PLUGIN_RUNTIME_DIR/logs.sh"
PLUGIN_RUNTIME_TRAFFIC_SH="$PLUGIN_RUNTIME_DIR/traffic.sh"
PLUGIN_RUNTIME_VERSION_SH="$PLUGIN_RUNTIME_DIR/version.sh"
PLUGIN_RUNTIME_CONFIGS_SH="$PLUGIN_RUNTIME_DIR/configs.sh"
PLUGIN_RUNTIME_PROXIES_SH="$PLUGIN_RUNTIME_DIR/proxies.sh"
PLUGIN_RUNTIME_RULES_SH="$PLUGIN_RUNTIME_DIR/rules.sh"
PLUGIN_RUNTIME_CONNECTIONS_SH="$PLUGIN_RUNTIME_DIR/connections.sh"
PLUGIN_RUNTIME_PROVIDERS_PROXIES_SH="$PLUGIN_RUNTIME_DIR/providers-proxies.sh"
PLUGIN_RUNTIME_PROXY_GROUPS_SH="$PLUGIN_RUNTIME_DIR/proxy-groups.sh"

clash_cli_runtime__external_controller() {
  local external_controller="$(cat $CLASH_CONFIG_FILE | grep ^external-controller)"
  if [ ! -z "$external_controller" ]
  then
    echo "${external_controller##external-controller:}" | xargs
  fi
}

clash_cli_runtime__secret() {
  local secret="$(cat $CLASH_CONFIG_FILE | grep ^secret)"
  if [ ! -z "$secret" ]
  then
    echo "${secret##secret:}" | xargs
  fi
}

clash_cli_runtime__curl() {
  local method="$1"
  if [ -z "$method" ]
  then
    echo "no method"
    exit 999
  fi

  local url="$2"
  if [ -z "$url" ]
  then
    echo "no url"
    exit 999
  fi

  echo "[$(date '+%Y/%m/%d %H:%M:%S')] [$method] $url" >> "$PLUGIN_RUNTIME_LOG"

  curl \
    -s \
    -X "$method" \
    -H "Authorization: Bearer $(clash_cli_runtime__secret)" \
    "$(clash_cli_runtime__external_controller)$url"
}

clash_cli_runtime__help() {
  echo "clash-cli runtime {command} {?arguments} {?--verbose|-v}"
  echo ""
  echo "configs from $CLASH_CONFIG_FILE"
  echo "  external-controller            : $(clash_cli_runtime__external_controller)"
  echo "  secret                         : $(clash_cli_runtime__secret)"
  echo ""
  echo "commands:"
  echo "    hello                        : show hello message"
  echo "    logs {?level}                : show logs"
  echo "    traffic                      : show traffic info"
  echo "    version                      : show version info"
  # todo: configs
  echo "    configs {?command}           : "
  # todo: proxies
  echo "    proxies {?command}           : "
  echo "    rules                        : show rules info"
  # todo: connections
  echo "    connections {?command}       : "
  # todo: providers-proxies
  echo "    providers-proxies {?command} : "
  echo "    proxy-groups {?name}         : show proxy-groups info"
  echo "    help                         : show plugin<runtime> help info"
  echo "    version                      : show plugin<runtime> version info"
}

clash_cli_runtime() {
  if [ -z "$1" ]
  then
    clash_cli_runtime__help
    return
  fi

  local command="$1"
  case $command in
    "help")
      clash_cli_runtime__help
      ;;
    "version")
      print_version "Clash-Runtime" "$PLUGIN_RUNTIME_VERSION"
      # source $PLUGIN_RUNTIME_VERSION_SH "${@:2} "
      ;;
    "proxy-groups")
      source $PLUGIN_RUNTIME_PROXY_GROUPS_SH "${@:2} "
      ;;
    "hello")
      source $PLUGIN_RUNTIME_HELLO_SH "${@:2} "
      ;;
    "logs")
      source $PLUGIN_RUNTIME_LOGS_SH "${@:2} "
      ;;
    "traffic")
      source $PLUGIN_RUNTIME_TRAFFIC_SH "${@:2} "
      ;;
    "configs")
      source $PLUGIN_RUNTIME_CONFIGS_SH "${@:2} "
      ;;
    "proxies")
      source $PLUGIN_RUNTIME_PROXIES_SH "${@:2} "
      ;;
    "rules")
      source $PLUGIN_RUNTIME_RULES_SH "${@:2} "
      ;;
    "connections")
      source $PLUGIN_RUNTIME_CONNECTIONS_SH "${@:2} "
      ;;
    "providers-proxies")
      source $PLUGIN_RUNTIME_PROVIDERS_PROXIES_SH "${@:2} "
      ;;
    *)
      echo "command \"$command\" not found"
      clash_cli_runtime__help
      exit 2
      ;;
  esac
}

clash_cli_runtime $(echo "$@" | xargs)