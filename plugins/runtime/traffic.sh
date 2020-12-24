clash_cli_runtime_traffic() {
  clash_cli_runtime__curl "GET" $URL_TRAFFIC
}

clash_cli_runtime_traffic $(echo "$@" | xargs)