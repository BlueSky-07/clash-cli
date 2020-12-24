clash_cli_runtime__proxy_groups() {
  local group_name="$1"

  local json=$(clash_cli_runtime__curl "GET" $URL_PROXIES |
    jq -r '
      .proxies
      | map(
        select(.type | inside("URLTest", "Fallback", "Selector"))
      )
      | map({ (.name): . })
      | add
    '
  )

  if ! $VERBOSE
  then
    json=$(echo $json | jq 'map_values(.now)')
  fi

  if [ ! -z "$group_name" ]
  then
    echo $json | jq ".$group_name"
  else
    echo $json | jq
  fi
}

clash_cli_runtime__proxy_groups $(echo "$@" | xargs)