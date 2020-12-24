clash_cli_runtime_proxies() {
  clash_cli_runtime__curl "GET" $URL_PROXIES | jq
}

clash_cli_runtime_proxies $(echo "$@" | xargs)