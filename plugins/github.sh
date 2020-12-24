#!/bin/bash

URL_GITHUB_RATE_LIMIT="https://api.github.com/rate_limit"
ASSET_GITHUB_RATE_LIMIT_JSON="$CLASH_CLI_ASSETS_DIR/github-status.json"

dependency_check curl "https://curl.haxx.se/download.html"
dependency_check jq   "https://stedolan.github.io/jq/download/"

clash_cli_github__status() {
  local fields="\"core\""
  for field in "$@"
  do
    case $field in
      core|graphql|integration_manifest|search)
        fields+=", \"$field\""
        ;;
    esac
  done

  if $VERBOSE
  then
    echo "fields: $fields"
  fi

  curl -s -o "$ASSET_GITHUB_RATE_LIMIT_JSON" "$URL_GITHUB_RATE_LIMIT"

  cat "$ASSET_GITHUB_RATE_LIMIT_JSON" \
    | jq --arg FIELDS "$fields"       \
          -r '.resources
            | .[]
            |= "\t" + (.remaining | tostring) + " / " + (.limit | tostring) + "\n"
                + "\t" + (.reset | strflocaltime("%Y-%m-%d %H:%M:%S (%Z)"))
            | to_entries
            | .[]
            | select([.key] | inside([$FIELDS]))
            | (.key | tostring) + ":\n"
              + (.value | tostring)
          '
}

clash_cli_github__status $(echo "$@" | xargs)