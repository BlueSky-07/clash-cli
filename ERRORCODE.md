# Clash Command-Line Interface ErrorCode

## `1`

**location**: `clash-cli.sh`

**plugin**:   *ANY*

**command**:  *ANY*


clash not found, you should download latest clash from [https://github.com/Dreamacro/clash/releases](https://github.com/Dreamacro/clash/releases), and unpack bin from zip/tar, copy to `~/.clash-cli/clash`

## `2`

**location**: `clash-cli.sh`

**plugin**:   *ANY*

**command**:  *ANY*

command not found, execute `clash-cli help` will show all available commands

## `9`

**location**: `clash-cli.sh`

**plugin**:   *ANY*

**command**:  *ANY*

missing one or more dependencies to continue

## `11`

**location**: `clash-cli.sh`

**plugin**:   *NONE*

**command**:  `clash-cli restart {manager}`

input `$manager` is an invalid argument, allowed: screen|systemctl

## `12`

**location**: `clash-cli.sh`

**plugin**:   *NONE*

**command**:  `clash-cli restart`

failed to restart clash, check your config file: `~/.config/clash/config.yaml`, execute `~/.clash-cli/clash` will show error message

## `31`

**location**: `clash-cli.sh`

**plugin**:   *NONE*

**command**:  `clash-cli config {config_filename}`

`$config_filename` is a required argument

## `41`

**location**: `plugins/install-clash.sh`

**plugin**:   `install-clash`

**command**:  `clash-cli install`

cannot auto get bin asset url, please download clash bin manually
