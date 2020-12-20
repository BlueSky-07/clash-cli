<h1 align="center">
  <img src="https://github.com/BlueSky-07/clash-cli/raw/master/logo.png" alt="Clash" width="200">
  <br>Clash-CLI<br>
</h1>

<h4 align="center">A Command-Line Interface for Clash.</h4>
<h6 align="center">v0.3 2020/12/20</h4>

# Features

1. an easy way to manage clash and config files
1. support Linux / macOS
1. clash download helper

# Install

```bash
rm -rf ~/.clash-cli
git clone https://github.com/BlueSky-07/clash-cli ~/.clash-cli --depth=1
sudo ln -s ~/.clash-cli/clash-cli.sh /usr/local/bin/clash-cli

# install clash
clash-cli install
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
1. `clash-cli configs`
    - **description**: scan clash config files located at `~/.config/clash`
    - **note**: `~/.config/clash/config.yaml` will be ignored
1. `clash-cli config {config_filename}`
    - **description**: use specific config file located at `~/.config/clash`
    - **arguments**:
      - `{config_filename}`: specific config filename without extension
1. `clash-cli help`
    - **description**: show help info
1. `clash-cli version`
    - **description**: show version info

# Plugins

## install-clash

1. `clash-cli install`
    - **description**: download clash bin at `~/.clash-cli/clash`
1. `clash-cli install fetch`
    - **description**: fetch latest clash release info, located at `~/.clash-cli/assets/clash-releases.json`
1. `clash-cli install list`
    - **description**: list all versions info
1. `clash-cli install help`
    - **description**: show plugin<install-clash> help info
1. `clash-cli install version`
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