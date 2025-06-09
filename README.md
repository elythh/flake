<h1 align=center>caelestia-shell</h1>

<div align=center>

![GitHub last commit](https://img.shields.io/github/last-commit/caelestia-dots/shell?style=for-the-badge&labelColor=101418&color=9ccbfb)
![GitHub Repo stars](https://img.shields.io/github/stars/caelestia-dots/shell?style=for-the-badge&labelColor=101418&color=b9c8da)
![GitHub repo size](https://img.shields.io/github/repo-size/caelestia-dots/shell?style=for-the-badge&labelColor=101418&color=d3bfe6)
![Ko-Fi donate](https://img.shields.io/badge/donate-kofi?style=for-the-badge&logo=ko-fi&logoColor=ffffff&label=ko-fi&labelColor=101418&color=f16061&link=https%3A%2F%2Fko-fi.com%2Fsoramane)

</div>

https://github.com/user-attachments/assets/0840f496-575c-4ca6-83a8-87bb01a85c5f

## Components

- Widgets: [`Quickshell`](https://quickshell.outfoxxed.me)
- Window manager: [`Hyprland`](https://hyprland.org)
- Dots: [`caelestia`](https://github.com/caelestia-dots)

## Installation

### Automated installation (recommended)

Install [`caelestia-scripts`](https://github.com/caelestia-dots/scripts) and run `caelestia install shell`.

### Manual installation

Install all [dependencies](https://github.com/caelestia-dots/scripts/blob/main/install/shell.fish#L10), then
clone this repo into `$XDG_CONFIG_HOME/quickshell/caelestia` and run `qs -c caelestia`.

## Usage

The shell can be started in two ways: via systemd or manually running `caelestia shell`.

### Via systemd

The install script creates and enables the systemd service `caelestia-shell.service` which should automatically start the
shell on login.

### Via command

If not on a system that uses systemd, you can manually start the shell via `caelestia-shell`.
To autostart it on login, you can use an `exec-once` rule in your Hyprland config:
```
exec-once = caelestia shell
```

### Shortcuts/IPC

All keybinds are accessible via Hyprland [global shortcuts](https://wiki.hyprland.org/Configuring/Binds/#dbus-global-shortcuts).
For a preconfigured setup, install [`caelestia-hypr`](https://github.com/caelestia-dots/hypr) via `caelestia install hypr` or see
[this file](https://github.com/caelestia-dots/hypr/blob/main/hyprland/keybinds.conf#L1-L29) for an example on how to use global
shortcuts.

All IPC commands can be accessed via `caelestia shell ...`. For example
```sh
caelestia shell mpris getActive trackTitle
```

The list of IPC commands can be shown via `caelestia shell help`:
```
> caelestia shell help
target mpris
  function stop(): void
  function play(): void
  function next(): void
  function getActive(prop: string): string
  function list(): string
  function playPause(): void
  function pause(): void
  function previous(): void
target drawers
  function list(): string
  function toggle(drawer: string): void
target wallpaper
  function list(): string
  function get(): string
  function set(path: string): void
target notifs
  function clear(): void
```

## Credits

Thanks to the Hyprland discord community (especially the homies in #rice-discussion) for all the help and suggestions
for improving these dots!

A special thanks to [@outfoxxed](https://github.com/outfoxxed) for making Quickshell and the effort put into fixing issues
and implementing various feature requests.

Another special thanks to [@end_4](https://github.com/end-4) for his [config](https://github.com/end-4/dots-hyprland)
which helped me a lot with learning how to use Quickshell.

Finally another thank you to all the configs I took inspiration from (only one for now):
- [Axenide/Ax-Shell](https://github.com/Axenide/Ax-Shell)

## Stonks 📈

<a href="https://www.star-history.com/#caelestia-dots/shell&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=caelestia-dots/shell&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=caelestia-dots/shell&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=caelestia-dots/shell&type=Date" />
 </picture>
</a>
