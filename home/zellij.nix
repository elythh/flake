{
  config,
  pkgs,
  ...
}:
let
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
  colors = scheme: {
    inherit (scheme)
      bg
      fg
      black
      red
      green
      yellow
      blue
      magenta
      cyan
      white
      orange
      ;
  };

in
{

  config = {

    home.packages = [
      pkgs.tmate
      sesh
    ];

    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        themes = {
          "default" = colors (import ./colors.nix { scheme = "dark"; });
        };
      };
    };

    xdg.configFile."zellij/config.kdl".text = with config.programs.zellij.settings.themes.default; ''
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
                              LaunchPlugin "https://github.com/laperlej/zellij-choose-tree/releases/download/v0.4.2/zellij-choose-tree.wasm"{
                                    floating true
                                    move_to_focused_tab true
                                    show_plugins false
                              };
                              SwitchToMode "Normal"
                      }
                      bind "Alt g" { LaunchOrFocusPlugin "https://github.com/laperlej/zellij-sessionizer/releases/download/v0.4.3/zellij-sessionizer.wasm" {
                              floating true
                              move_to_focused_tab true
                              cwd "/"
                              root_dirs "/home/gwen/workspace/rf/struktur;/etc/nixos/;/home/gwen/workspace/gh"
                          }; 
                          SwitchToMode "Normal";
                      }
                      bind "Ctrl f" {
                              LaunchOrFocusPlugin "https://github.com/imsnif/monocle/releases/download/v0.100.2/monocle.wasm" {
                                      floating true
                              }
                              SwitchToMode "Normal"
                      }
                    bind "Alt 1" { GoToTab 1;}
                    bind "Alt 2" { GoToTab 2;}
                    bind "Alt 3" { GoToTab 3;}
                    bind "Alt 4" { GoToTab 4;}
              }

            unbind "Ctrl b" "Ctrl q" 
          }

      plugins {
              zjstatus location="https://github.com/dj95/zjstatus/releases/download/v0.20.1/zjstatus.wasm" {
                      format_left   "{mode}#[bg=${bg}] {tabs}"
                      format_center ""
                      format_right  "#[bg=${blue},fg=${bg},bold]  #[bg=${bg},fg=${blue},bold] {session} #[bg=${bg},fg=${blue},bold]"
                      format_space  ""
                      format_hide_on_overlength "true"
                      format_precedence "crl"

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#6C7086]{char}"
                      border_position "top"

                      mode_normal        "#[bg=${blue},fg=${fg},bold] NORMAL#[bg=${bg},fg=${fg}]█"
                      mode_locked        "#[bg=#6e738d,fg=${bg},bold] LOCKED #[bg=${bg},fg=#6e738d]█"
                      mode_resize        "#[bg=#f38ba8,fg=${bg},bold] RESIZE#[bg=${bg},fg=#f38ba8]█"
                      mode_pane          "#[bg=${orange},fg=${bg},bold] PANE#[bg=${bg},fg=${fg}]█"
                      mode_tab           "#[bg=${red},fg=${bg},bold] TAB#[bg=${bg},fg=${fg}]█"
                      mode_scroll        "#[bg=#f9e2af,fg=${bg},bold] SCROLL#[bg=${bg},fg=#f9e2af]█"
                      mode_enter_search  "#[bg=#8aadf4,fg=${bg},bold] ENT-SEARCH#[bg=${bg},fg=#8aadf4]█"
                      mode_search        "#[bg=#8aadf4,fg=${bg},bold] SEARCHARCH#[bg=${bg},fg=#8aadf4]█"
                      mode_rename_tab    "#[bg=#b4befe,fg=${bg},bold] RENAME-TAB#[bg=${bg},fg=#b4befe]█"
                      mode_rename_pane   "#[bg=#89b4fa,fg=${bg},bold] RENAME-PANE#[bg=${bg},fg=#89b4fa]█"
                      mode_session       "#[bg=${magenta},fg=${bg},bold] SESSION#[bg=${bg},fg=${fg}]█"
                      mode_move          "#[bg=#f5c2e7,fg=${bg},bold] MOVE#[bg=${bg},fg=#f5c2e7]█"
                      mode_prompt        "#[bg=#8aadf4,fg=${bg},bold] PROMPT#[bg=${bg},fg=#8aadf4]█"
                      mode_tmux          "#[bg=#f5a97f,fg=${bg},bold] TMUX#[bg=${bg},fg=#f5a97f]█"

                      // formatting for inactive tabs
                      tab_normal              "#[bg=${bg},fg=${fg}]█#[bg=${fg},fg=${bg},bold]{index} #[bg=${bg},fg=${fg},bold] {name}{floating_indicator}#[bg=${bg},fg=${bg},bold]█"
                      tab_normal_fullscreen   "#[bg=${bg},fg=${fg}]█#[bg=${fg},fg=${bg},bold]{index} #[bg=${bg},fg=${fg},bold] {name}{fullscreen_indicator}#[bg=${bg},fg=${bg},bold]█"
                      tab_normal_sync         "#[bg=${bg},fg=${fg}]█#[bg=${fg},fg=${bg},bold]{index} #[bg=${bg},fg=${fg},bold] {name}{sync_indicator}#[bg=${bg},fg=${bg},bold]█"

                      // formatting for the current active tab
                      tab_active_sync         "#[bg=${red},fg=${red}]█#[bg=${red},fg=${bg},bold]{index} #[bg=${bg},fg=${red},bold] {name}{sync_indicator}#[bg=${bg},fg=${bg},bold]█"
                      tab_active              "#[bg=${red},fg=${red}]█#[bg=${red},fg=${bg},bold]{index} #[bg=${bg},fg=${red},bold] {name}{floating_indicator}#[bg=${bg},fg=${bg},bold]█"
                      tab_active_fullscreen   "#[bg=${red},fg=${red}]█#[bg=${red},fg=${bg},bold]{index} #[bg=${bg},fg=${red},bold] {name}{fullscreen_indicator}#[bg=${bg},fg=${bg},bold]█"

                      // separator between the tabs
                      tab_separator           "#[bg=${bg}] "

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
    '';

    xdg.configFile."zellij/layouts/default.kdl".text = ''
      layout {
        default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="zjstatus"
            }
        }
      }
    '';

  };
}
