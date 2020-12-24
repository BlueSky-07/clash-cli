clash_cli_runtime_providers_proxies() {
  clash_cli_runtime__curl "GET" $URL_PROVIDERS_PROXIES | jq
}

clash_cli_runtime_providers_proxies $(echo "$@" | xargs)