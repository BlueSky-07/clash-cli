clash_cli_runtime_configs() {
  clash_cli_runtime__curl "GET" $URL_CONFIGS | jq
}

clash_cli_runtime_configs $(echo "$@" | xargs)