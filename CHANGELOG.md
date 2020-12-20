# Clash Command-Line Interface ChangeLog
## v0.3 2020/12/20

1. commands updated:
    - `configs`               : renamed from `scan`
    - `config`                : renamed from `use`
1. plugins updated:
    - `install`               : install clash bin
    - `install {?command}`    : renamed to `install-cli`
1. error codes added:
    - `41`: cannot auto get bin asset url

## v0.2 2020/08/28

1. plugins added:
    - `install-clash fetch`   : fetch latest clash release info
    - `install-clash list`    : list all versions info
    - `install-clash help`    : show plugin<install-clash> help info
    - `install-clash version` : show plugin<install-clash> version info
1. doc added:
    - Error Code: [ERRORCODE](ERRORCODE.md)
1. error codes added:
    - `9`: missing dependencies

## v0.1 2020/08/27

1. commands added:
    - `restart {?screen|systemctl}` : restart clash client
    - `scan`                        : scan clash config files
    - `use {config_filename}`       : use specific config file
    - `help`                        : show help info
    - `version`                     : show version info
1. error codes added:
    - `1`: clash bin not found
    - `2`: command not found
    - `11`: `clash-cli restart {manager}` found invalid `$manager` argument
    - `12`: failed to restart clash
    - `31`: `clash-cli use {config_filename}` missed `$config_filename` argument