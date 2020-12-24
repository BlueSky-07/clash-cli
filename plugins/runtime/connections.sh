clash_cli_runtime_connections() {
  clash_cli_runtime__curl "GET" $URL_CONNECTIONS | jq
}

clash_cli_runtime_connections $(echo "$@" | xargs)