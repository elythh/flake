{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  sesh = pkgs.writeScriptBin "sesh" ''
    #! /usr/bin/env sh

    # Taken from https://github.com/zellij-org/zellij/issues/884#issuecomment-1851136980
    # select a directory using zoxide
    ZOXIDE_RESULT=$(zoxide query --interactive)
    # checks whether a directory has been selected
    if [[ -z "$ZOXIDE_RESULT" ]]; then
    	# if there was no directory, select returns without executing
    	exit 0
    fi
    # extracts the directory name from the absolute path
    SESSION_TITLE=$(echo "$ZOXIDE_RESULT" | sed 's#.*/##')

    # get the list of sessions
    SESSION_LIST=$(zellij list-sessions -n | awk '{print $1}')

    # checks if SESSION_TITLE is in the session list
    if echo "$SESSION_LIST" | grep -q "^$SESSION_TITLE$"; then
    	# if so, attach to existing session
    	zellij attach "$SESSION_TITLE"
    else
    	# if not, create a new session
    	echo "Creating new session $SESSION_TITLE and CD $ZOXIDE_RESULT"
    	cd $ZOXIDE_RESULT
    	zellij attach -c "$SESSION_TITLE"
    fi
  '';

  cfg = config.opt.shell.zellij;
in
{
  options.opt.shell.zellij.enable = mkEnableOption "zellij";

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.tmate
      sesh
    ];

    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
    };

    xdg.configFile."zellij/config.kdl".text = ''
      default_layout "default"
      mouse_mode true
      copy_on_select true
      copy_command "wl-copy"
      simplified_ui  false
      scrollback_editor "/home/gwen/.nix-profile/bin/nvim"
      pane_frames false
      on_force_close "detach"

      ui {
        pane_frames {
          rounded_corners false
        }
      }

      keybinds {
              normal {
                      bind "Alt f" {
                              LaunchPlugin "https://github.com/laperlej/zellij-choose-tree/releases/download/v0.4.0/zellij-choose-tree.wasm"{
                                    floating true
                                    move_to_focused_tab true
                                    show_plugins false
                              };
                              SwitchToMode "Normal"
                      }
                      bind "Alt g" { LaunchOrFocusPlugin "https://github.com/laperlej/zellij-sessionizer/releases/download/v0.3.0/zellij-sessionizer.wasm" {
                              floating true
                              move_to_focused_tab true
                              cwd "/"
                              root_dirs "/home/gwen/workspace/rf/struktur;/etc/nixos/;/home/gwen/workspace/gh"
                          }; 
                          SwitchToMode "Normal";
                      }
                      bind "Ctrl f" {
                              LaunchOrFocusPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                      floating true
                              }
                              SwitchToMode "Normal"
                      }
                    bind "Alt 1" { GoToTab 1;}
                    bind "Alt 2" { GoToTab 2;}
                    bind "Alt 3" { GoToTab 3;}
                    bind "Alt 4" { GoToTab 4;}
              }

            unbind "Ctrl b" "Ctrl h" "Alt j" "Alt l" "Alt h" "Alt k" "Ctrl j" "Ctrl k" "Ctrl l"
          }
    '';

    xdg.configFile."zellij/layouts/default.kdl".text = with config.lib.stylix.colors; ''
      layout {
          swap_tiled_layout name="vertical" {
              tab max_panes=5 {
                  pane split_direction="vertical" {
                      pane
                      pane { children; }
                  }
              }
              tab max_panes=8 {
                  pane split_direction="vertical" {
                      pane { children; }
                      pane { pane; pane; pane; pane; }
                  }
              }
              tab max_panes=12 {
                  pane split_direction="vertical" {
                      pane { children; }
                      pane { pane; pane; pane; pane; }
                      pane { pane; pane; pane; pane; }
                  }
              }
          }

          swap_tiled_layout name="horizontal" {
              tab max_panes=5 {
                  pane
                  pane
              }
              tab max_panes=8 {
                  pane {
                      pane split_direction="vertical" { children; }
                      pane split_direction="vertical" { pane; pane; pane; pane; }
                  }
              }
              tab max_panes=12 {
                  pane {
                      pane split_direction="vertical" { children; }
                      pane split_direction="vertical" { pane; pane; pane; pane; }
                      pane split_direction="vertical" { pane; pane; pane; pane; }
                  }
              }
          }

          swap_tiled_layout name="stacked" {
              tab min_panes=5 {
                  pane split_direction="vertical" {
                      pane
                      pane stacked=true { children; }
                  }
              }
          }

          swap_floating_layout name="staggered" {
              floating_panes
          }

          swap_floating_layout name="enlarged" {
              floating_panes max_panes=10 {
                  pane { x "5%"; y 1; width "90%"; height "90%"; }
                  pane { x "5%"; y 2; width "90%"; height "90%"; }
                  pane { x "5%"; y 3; width "90%"; height "90%"; }
                  pane { x "5%"; y 4; width "90%"; height "90%"; }
                  pane { x "5%"; y 5; width "90%"; height "90%"; }
                  pane { x "5%"; y 6; width "90%"; height "90%"; }
                  pane { x "5%"; y 7; width "90%"; height "90%"; }
                  pane { x "5%"; y 8; width "90%"; height "90%"; }
                  pane { x "5%"; y 9; width "90%"; height "90%"; }
                  pane focus=true { x 10; y 10; width "90%"; height "90%"; }
              }
          }

          swap_floating_layout name="spread" {
              floating_panes max_panes=1 {
                  pane {y "50%"; x "50%"; }
              }
              floating_panes max_panes=2 {
                  pane { x "1%"; y "25%"; width "45%"; }
                  pane { x "50%"; y "25%"; width "45%"; }
              }
              floating_panes max_panes=3 {
                  pane focus=true { y "55%"; width "45%"; height "45%"; }
                  pane { x "1%"; y "1%"; width "45%"; }
                  pane { x "50%"; y "1%"; width "45%"; }
              }
              floating_panes max_panes=4 {
                  pane { x "1%"; y "55%"; width "45%"; height "45%"; }
                  pane focus=true { x "50%"; y "55%"; width "45%"; height "45%"; }
                  pane { x "1%"; y "1%"; width "45%"; height "45%"; }
                  pane { x "50%"; y "1%"; width "45%"; height "45%"; }
              }
          }

          default_tab_template {
              pane size=2 borderless=true {
                  plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
                      format_left   "{mode}#[bg=#181926] {tabs}"
                      format_center ""
                      format_right  "#[bg=#${base0D},fg=#${base01},bold]  #[bg=#${base01},fg=#${base0D},bold] {session} #[bg=#${base01},fg=#${base0D},bold]"
                      format_space  ""
                      format_hide_on_overlength "true"
                      format_precedence "crl"

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#6C7086]{char}"
                      border_position "top"

                      mode_normal        "#[bg=#${base0B},fg=#${base01},bold] NORMAL#[bg=#${base01},fg=#${base0B}]█"
                      mode_locked        "#[bg=#6e738d,fg=#${base01},bold] LOCKED #[bg=#${base01},fg=#6e738d]█"
                      mode_resize        "#[bg=#f38ba8,fg=#${base01},bold] RESIZE#[bg=#${base01},fg=#f38ba8]█"
                      mode_pane          "#[bg=#${base0E},fg=#${base01},bold] PANE#[bg=#${base01},fg=#${base0E}]█"
                      mode_tab           "#[bg=#${base0D},fg=#${base01},bold] TAB#[bg=#${base01},fg=#${base0D}]█"
                      mode_scroll        "#[bg=#f9e2af,fg=#${base01},bold] SCROLL#[bg=#${base01},fg=#f9e2af]█"
                      mode_enter_search  "#[bg=#8aadf4,fg=#${base01},bold] ENT-SEARCH#[bg=#${base01},fg=#8aadf4]█"
                      mode_search        "#[bg=#8aadf4,fg=#${base01},bold] SEARCHARCH#[bg=#${base01},fg=#8aadf4]█"
                      mode_rename_tab    "#[bg=#b4befe,fg=#${base01},bold] RENAME-TAB#[bg=#${base01},fg=#b4befe]█"
                      mode_rename_pane   "#[bg=#89b4fa,fg=#${base01},bold] RENAME-PANE#[bg=#${base01},fg=#89b4fa]█"
                      mode_session       "#[bg=#${base0C},fg=#${base01},bold] SESSION#[bg=#${base01},fg=#${base0C}]█"
                      mode_move          "#[bg=#f5c2e7,fg=#${base01},bold] MOVE#[bg=#${base01},fg=#f5c2e7]█"
                      mode_prompt        "#[bg=#8aadf4,fg=#${base01},bold] PROMPT#[bg=#${base01},fg=#8aadf4]█"
                      mode_tmux          "#[bg=#f5a97f,fg=#${base01},bold] TMUX#[bg=#${base01},fg=#f5a97f]█"

                      // formatting for inactive tabs
                      tab_normal              "#[bg=#${base01},fg=#${base0E}]█#[bg=#${base0E},fg=#${base01},bold]{index} #[bg=#${base00},fg=#${base0E},bold] {name}{floating_indicator}#[bg=#${base00},fg=#${base00},bold]█"
                      tab_normal_fullscreen   "#[bg=#${base01},fg=#${base0E}]█#[bg=#${base0E},fg=#${base01},bold]{index} #[bg=#${base00},fg=#${base0E},bold] {name}{fullscreen_indicator}#[bg=#${base00},fg=#${base00},bold]█"
                      tab_normal_sync         "#[bg=#${base01},fg=#${base0E}]█#[bg=#${base0E},fg=#${base01},bold]{index} #[bg=#${base00},fg=#${base0E},bold] {name}{sync_indicator}#[bg=#${base00},fg=#${base00},bold]█"

                      // formatting for the current active tab
                      tab_active              "#[bg=#${base08},fg=#${base08}]█#[bg=#${base08},fg=#${base01},bold]{index} #[bg=#${base01},fg=#${base08},bold] {name}{floating_indicator}#[bg=#${base00},fg=#${base01},bold]█"
                      tab_active_fullscreen   "#[bg=#${base08},fg=#${base08}]█#[bg=#${base08},fg=#${base01},bold]{index} #[bg=#${base01},fg=#${base08},bold] {name}{fullscreen_indicator}#[bg=#${base00},fg=#${base01},bold]█"
                      tab_active_sync         "#[bg=#${base08},fg=#${base08}]█#[bg=#${base08},fg=#${base01},bold]{index} #[bg=#${base01},fg=#${base08},bold] {name}{sync_indicator}#[bg=#${base00},fg=#${base01},bold]█"

                      // separator between the tabs
                      tab_separator           "#[bg=#${base00}] "

                      // indicators
                      tab_sync_indicator       " "
                      tab_fullscreen_indicator " 󰊓"
                      tab_floating_indicator   " 󰹙"

                      command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                      command_git_branch_format      "#[fg=blue] {stdout} "
                      command_git_branch_interval    "10"
                      command_git_branch_rendermode  "static"

                      datetime        "#[fg=#6C7086,bold] {format} "
                      datetime_format "%A, %d %b %Y %H:%M"
                      datetime_timezone "Europe/London"
                  }
              }
              children
          }
      }
    '';

  };
}
