#!/bin/bash
source "$HOME/.clash-cli/bootstrap.sh"

echo "[$(date '+%Y/%m/%d %H:%M:%S')] $@" >> "$CLASH_CLI_LOGS_DIR/history.log"

export VERBOSE=false
export YES=false

clash_cli__restart() {
  check_bin

  local STORE_FILE_PATH="$CLASH_CLI_CONFIGS_DIR/LAST_RESTART_MANAGER"

  local manager="$1"
  if [ -z "$manager" ]
  then
    if [ -f "$STORE_FILE_PATH" ]
    then
      local LAST_RESTART_MANAGER="$(cat $STORE_FILE_PATH | awk '{$1=$1};1')"
      if [ -z "$LAST_RESTART_MANAGER" ]
      then
        manager="screen"
      else
        if $VERBOSE
        then
          printf "$STORE_FILE_PATH: \"\e[31m$LAST_RESTART_MANAGER\e[0m\"\n"
        fi
        manager="$LAST_RESTART_MANAGER"
      fi
    else
    manager="screen"
    fi
  fi

  if $VERBOSE
  then
    echo "using $manager"
  fi

  local exit_code=0
  case $manager in
    "screen")
      dependency_check screen "https://www.gnu.org/software/screen/"
      local last="$(screen -ls | grep clash | awk '{$1=$1};1')"
      if [ ! -z "$last" ]
      then
        screen -S clash -X quit
      fi
      screen -S clash -dm bash -c "$CLASH_BIN"
      screen -ls > /dev/null
      local now="$(screen -ls | grep clash | awk '{$1=$1};1')"
      if [ -z "$now" ]
      then
        exit_code=1
      else
        if $VERBOSE
        then
          echo "$last => $now"
        fi
      fi
      ;;
    "systemctl")
      sudo systemctl restart clash
      exit_code=$?
      ;;
    *)
      echo "\"$manager\" is an invalid argument, allowed: screen|systemctl"
      exit 11
      ;;
  esac

  if [ $exit_code -eq 0 ]
  then
    echo "restart clash successfully"
    echo "$manager" > "$STORE_FILE_PATH"
  else
    echo "failed to restart clash, check your config file: $CLASH_CONFIG_DIR/config.yaml"
    echo "execute \"$CLASH_BIN\" to show error message"
    exit 12
  fi
}

clash_cli__scan_config_files() {
  local verbose=false
  if [[ "$1" =~ ^-*(verbose|v)$ ]]
  then
    verbose=true
  fi

  local files="$(find $CLASH_CONFIG_DIR | grep -v 'config.yaml\>' | grep 'yaml\>')"

  for file in $(echo "$files")
  do
    local filename="${file/*\//}"
    local dirname="${file/$filename/}"
    local filename_without_extension="${filename/.yaml/}"

    if $VERBOSE
    then
      printf "$dirname\e[31m%s\e[0m.yaml\n" "$filename_without_extension"
    else
      echo "$filename_without_extension"
    fi
  done
}

clash_cli__use_config_file() {
  local input="$1"
  if [ -z "$input" ]
  then
    echo "ussage: clash-cli config {config_filename}"
    echo "config files:"
    clash_cli__scan_config_files
    exit 31
  fi
  local target="$(find $CLASH_CONFIG_DIR | grep $CLASH_CONFIG_DIR/$input.yaml)"
  if [ -z "$target" ]
  then
    printf "config file not found: $CLASH_CONFIG_DIR/\e[31m$input\e[0m.yaml\n"
    echo "config files:"
    clash_cli__scan_config_files
    return
  else
    printf "applying $CLASH_CONFIG_DIR/\e[31m$input\e[0m.yaml\n"
  fi
  cp $target $CLASH_CONFIG_DIR/config.yaml
  clash_cli__restart
}

clash_cli__help() {
  echo "ussage: clash-cli {?plugin} {command} {?arguments} {?--verbose|-v}"
  echo "commands:"
  echo "    restart {?screen|systemctl} : restart clash"
  echo "    configs                     : scan clash config files"
  echo "    config  {config_filename}   : use specific config file"
  echo "    help                        : show help info"
  echo "    version                     : show version info"
  echo "plugins:"
  echo "    install                     : install clash"
}

clash_cli() {
  if [ -z "$1" ]
  then
    clash_cli__help
    return
  fi

  local command="$1"
  case $command in
    "restart")
      clash_cli__restart ${@:2}
      ;;
    "configs")
      clash_cli__scan_config_files ${@:2}
      ;;
    "config")
      clash_cli__use_config_file ${@:2}
      ;;
    "help")
      clash_cli__help
      ;;
    "version")
      print_version
      ;;
    "github")
      $PLUGIN_GITHUB_SH ${@:2}
      ;;
    "install")
      $PLUGIN_INSTALL_CLASH_SH ${@:2}
      ;;
    *)
      echo "command \"$command\" not found"
      clash_cli__help
      exit 2
      ;;
  esac
}

arguments=()
for arg in "$@"
do
  if [[ "$arg" =~ ^-+(verbose|v)$ ]]
  then
    VERBOSE=true
  elif [[ "$arg" =~ ^-+(yes|y)$ ]]
  then
    YES=true
  else
    arguments+=("$arg")
  fi
done

clash_cli "${arguments[@]}"
