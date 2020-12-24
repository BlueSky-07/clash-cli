clash_cli_runtime__logs() {
  local level="$1"
  clash_cli_runtime__curl "GET" "$URL_LOGS?level=$level"
}

clash_cli_runtime__logs $(echo "$@" | xargs)