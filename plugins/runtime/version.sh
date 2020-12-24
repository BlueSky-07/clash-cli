clash_cli_runtime_version() {
  clash_cli_runtime__curl "GET" $URL_VERSION | jq
}

clash_cli_runtime_version $(echo "$@" | xargs)