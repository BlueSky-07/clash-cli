clash_cli_runtime_rules() {
  clash_cli_runtime__curl "GET" $URL_RULES | jq
}

clash_cli_runtime_rules $(echo "$@" | xargs)