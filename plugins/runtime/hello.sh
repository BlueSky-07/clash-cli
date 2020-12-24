clash_cli_runtime_hello() {
  clash_cli_runtime__curl "GET" $URL_HELLO | jq
}

clash_cli_runtime_hello $(echo "$@" | xargs)