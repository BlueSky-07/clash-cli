# Clash Command-Line Interface

v0.2 2020/08/28

# Features

1. an easy way to manage clash and config files
1. support Linux / macOS
1. clash download helper

# Install

```bash
rm -rf ~/.clash-cli
git clone https://github.com/BlueSky-07/clash-cli ~/.clash-cli --depth=1
# download latest clash from https://github.com/Dreamacro/clash/releases
# unpack bin from zip/gz, copy to ~/.clash-cli/clash
sudo ln -s ~/.clash-cli/clash-cli.sh /usr/local/bin/clash-cli
```

# Upgrade

```bash
cd ~/.clash-cli
git pull
```

# Uninstall

```bash
rm -rf ~/.clash-cli
sudo rm /usr/bin/clash-cli
```

# Ussage

`clash-cli {?plugin} {command} {?arguments} {?--verbose|-v}`

1. `clash-cli restart {?screen|systemctl}`
    - **description**: restart clash
    - **arguments**:
      - `{?screen|systemctl}`: decide which manager to restart
        - `screen`: available on Linux / macOS, need [Screen](https://www.gnu.org/software/screen/) to be installed
        - `systemctl`: available on Linux, need service called `clash` to be enabled
1. `clash-cli scan`
    - **description**: scan clash config files located at `~/.config/clash`
    - **note**: `~/.config/clash/config.yaml` will be ignored
1. `clash-cli use {config_filename}`
    - **description**: use specific config file located at `~/.config/clash`
    - **arguments**:
      - `{config_filename}`: specific config filename without extension
1. `clash-cli help`
    - **description**: show help info
1. `clash-cli version`
    - **description**: show version info

# Plugins

## install-clash

1. `clash-cli install-clash fetch`
    - **description**: fetch latest clash release info, located at `~/.clash-cli/assets/clash-releases.json`
1. `clash-cli install-clash list`
    - **description**: list all versions info
1. `clash-cli install-clash help`
    - **description**: show plugin<install-clash> help info
1. `clash-cli install-clash version`
    - **description**: show plugin<install-clash> version info

*coming soon...*

# Changelog

See [CHANGELOG](CHANGELOG.md)

# Error Code

See [ERRORCODE](ERRORCODE.md)

# License

This software is released under the GPL-3.0 license.

# Acknowledgements

- [Dreamacro/clash](https://github.com/Dreamacro/clash): A rule-based tunnel in Go