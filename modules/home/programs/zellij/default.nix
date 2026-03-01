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

  cfg = config.meadow.programs.zellij;
in
{
  options.meadow.programs.zellij.enable = mkEnableOption "zellij";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.tmate
      sesh
    ];

    programs.zellij = {
      enable = true;
      enableFishIntegration = true;
    };

    home.file.".config/zellij/config.kdl".text = ''
      keybinds clear-defaults=true {
          normal {
              bind "h" { MoveFocus "left"; }
              bind "j" { MoveFocus "down"; }
              bind "k" { MoveFocus "up"; }
              bind "l" { MoveFocus "right"; }
              bind "J" { GoToNextTab; }
              bind "K" { GoToPreviousTab; }
              bind "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
              bind "=" { Resize "Increase"; }

              bind "Shift S" { NewPane "down"; SwitchToMode "locked"; }
              bind "Shift V" { NewPane "right"; SwitchToMode "locked"; }
              bind "v" { SwitchToMode "pane"; }

              bind "?" {
                  LaunchOrFocusPlugin "zj-forgot" { floating true; }
                  SwitchToMode "locked"
              }
          }
          locked {
              bind "Ctrl space" { SwitchToMode "normal"; }
          }
          shared_among "normal" "locked" {
              bind "Ctrl /" { ToggleFloatingPanes; }
              bind "Ctrl Alt '" { GoToPreviousTab; } // Ctrl Alt '
              bind "Ctrl Alt ;" { GoToNextTab; } // Ctrl Alt ;
              bind "Alt i" { MoveTab "left"; } // Ctrl Alt "
              bind "Alt o" { MoveTab "right"; } // Ctrl Alt :
              bind "Ctrl Alt Enter" { NewTab { name ""; }; SwitchToMode "locked"; } // Ctrl Alt Enter
              bind "Ctrl 1"  { GoToTab 1; } // Ctrl Alt Shift 1
              bind "Ctrl 2"  { GoToTab 2; } // Ctrl Alt Shift 2
              bind "Ctrl 3"  { GoToTab 3; } // Ctrl Alt Shift 3
              bind "Ctrl 4"  { GoToTab 4; } // Ctrl Alt Shift 4
              bind "Ctrl 5"  { GoToTab 5; } // Ctrl Alt Shift 5

              // bind "Alt Shift A" { FocusPreviousPane; }
              bind "Ü" { ToggleTab; }

              bind "Alt Shift J" { MoveFocus "down"; }
              bind "Alt Shift K" { MoveFocus "up"; }
              bind "Alt Shift L" { MoveFocus "right"; }
              bind "Alt Shift H" { MoveFocus "left"; }
          }
          pane {
              bind "left" { MoveFocus "left"; }
              bind "down" { MoveFocus "down"; }
              bind "up" { MoveFocus "up"; }
              bind "right" { MoveFocus "right"; }
              bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
              bind "d" { NewPane "down"; SwitchToMode "locked"; }
              bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
              bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
              bind "h" { MoveFocus "left"; }
              bind "i" { TogglePanePinned; SwitchToMode "locked"; }
              bind "j" { MoveFocus "down"; }
              bind "k" { MoveFocus "up"; }
              bind "l" { MoveFocus "right"; }
              bind "n" { NewPane; SwitchToMode "locked"; }
              bind "p" { SwitchToMode "normal"; }
              bind "r" { NewPane "right"; SwitchToMode "locked"; }
              bind "v" { NewPane "right"; SwitchToMode "locked"; }
              bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
              bind "x" { CloseFocus; SwitchToMode "locked"; }
              bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
              bind "tab" { SwitchFocus; }
          }
          tab {
              bind "left" { GoToPreviousTab; }
              bind "down" { GoToNextTab; }
              bind "up" { GoToPreviousTab; }
              bind "right" { GoToNextTab; }
              bind "1" { GoToTab 1; SwitchToMode "locked"; }
              bind "2" { GoToTab 2; SwitchToMode "locked"; }
              bind "3" { GoToTab 3; SwitchToMode "locked"; }
              bind "4" { GoToTab 4; SwitchToMode "locked"; }
              bind "5" { GoToTab 5; SwitchToMode "locked"; }
              bind "6" { GoToTab 6; SwitchToMode "locked"; }
              bind "7" { GoToTab 7; SwitchToMode "locked"; }
              bind "8" { GoToTab 8; SwitchToMode "locked"; }
              bind "9" { GoToTab 9; SwitchToMode "locked"; }
              bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
              bind "]" { BreakPaneRight; SwitchToMode "locked"; }
              bind "b" { BreakPane; SwitchToMode "locked"; }
              bind "h" { GoToPreviousTab; }
              bind "j" { GoToNextTab; }
              bind "k" { GoToPreviousTab; }
              bind "l" { GoToNextTab; }
              bind "n" { NewTab; SwitchToMode "locked"; }
              bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
              bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
              bind "t" { SwitchToMode "normal"; }
              bind "x" { CloseTab; SwitchToMode "locked"; }
              bind "tab" { ToggleTab; }
          }
          resize {
              bind "left" { Resize "Increase left"; }
              bind "down" { Resize "Increase down"; }
              bind "up" { Resize "Increase up"; }
              bind "right" { Resize "Increase right"; }
              bind "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
              bind "=" { Resize "Increase"; }
              bind "H" { Resize "Decrease left"; }
              bind "J" { Resize "Decrease down"; }
              bind "K" { Resize "Decrease up"; }
              bind "L" { Resize "Decrease right"; }
              bind "h" { Resize "Increase left"; }
              bind "j" { Resize "Increase down"; }
              bind "k" { Resize "Increase up"; }
              bind "l" { Resize "Increase right"; }
              bind "r" { SwitchToMode "normal"; }
          }
          move {
              bind "left" { MovePane "left"; }
              bind "down" { MovePane "down"; }
              bind "up" { MovePane "up"; }
              bind "right" { MovePane "right"; }
              bind "h" { MovePane "left"; }
              bind "j" { MovePane "down"; }
              bind "k" { MovePane "up"; }
              bind "l" { MovePane "right"; }
              bind "m" { SwitchToMode "normal"; }
              bind "n" { MovePane; }
              bind "p" { MovePaneBackwards; }
              bind "tab" { MovePane; }
          }
          scroll {
              bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
              bind "Alt down" { MoveFocus "down"; SwitchToMode "locked"; }
              bind "Alt up" { MoveFocus "up"; SwitchToMode "locked"; }
              bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
              bind "e" { EditScrollback; SwitchToMode "locked"; }
              bind "f" { SwitchToMode "entersearch"; SearchInput 0; }
              bind "/" { SwitchToMode "entersearch"; SearchInput 0; }
              bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
              bind "Alt j" { MoveFocus "down"; SwitchToMode "locked"; }
              bind "Alt k" { MoveFocus "up"; SwitchToMode "locked"; }
              bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
              bind "s" { NewPane "down"; SwitchToMode "locked"; } // Tmux muscle memory
          }
          entersearch {
              bind "Ctrl c" { SwitchToMode "scroll"; }
              bind "esc" { SwitchToMode "scroll"; }
              bind "enter" { SwitchToMode "search"; }
          }
          search {
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "n" { Search "down"; }
              bind "N" { Search "up"; }
              bind "o" { SearchToggleOption "WholeWord"; }
              bind "w" { SearchToggleOption "Wrap"; }
          }
          session {
              bind "a" {
                  LaunchOrFocusPlugin "zellij:about" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "c" {
                  LaunchOrFocusPlugin "configuration" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "d" { Detach; }
              bind "o" { SwitchToMode "normal"; }
              bind "p" {
                  LaunchOrFocusPlugin "plugin-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "w" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "q" {
                  LaunchOrFocusPlugin "zj-quit" {
                      floating true
                  }
                  SwitchToMode "locked"
              }
          }
          shared_except "locked" "renametab" "renamepane" {
              bind "Ctrl space" { SwitchToMode "locked"; }
          }
          shared_except "locked" "entersearch" {
              bind "enter" { SwitchToMode "locked"; }
          }
          shared_except "locked" "entersearch" "renametab" "renamepane" {
              bind "esc" { SwitchToMode "locked"; }
          }
          shared_except "locked" "entersearch" "renametab" "renamepane" "move" {
              bind "m" { SwitchToMode "move"; }
          }
          shared_except "locked" "entersearch" "search" "renametab" "renamepane" "session" {
              bind "o" { SwitchToMode "session"; }
          }
          shared_except "locked" "tab" "entersearch" "renametab" "renamepane" {
              bind "t" { SwitchToMode "tab"; }
          }
          shared_except "locked" "tab" "scroll" "entersearch" "renametab" "renamepane" {
              bind "s" { SwitchToMode "scroll"; }
          }
          shared_among "normal" "resize" "tab" "scroll" "prompt" "tmux" {
              bind "p" { SwitchToMode "pane"; }
          }
          shared_except "locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane" {
              bind "r" { SwitchToMode "resize"; }
          }
          shared_among "scroll" "search" {
              bind "PageDown" { PageScrollDown; }
              bind "PageUp" { PageScrollUp; }
              bind "left" { PageScrollUp; }
              bind "down" { ScrollDown; }
              bind "up" { ScrollUp; }
              bind "right" { PageScrollDown; }
              bind "Ctrl b" { PageScrollUp; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
              bind "d" { HalfPageScrollDown; }
              bind "Ctrl f" { PageScrollDown; }
              bind "h" { PageScrollUp; }
              bind "j" { ScrollDown; }
              bind "k" { ScrollUp; }
              bind "l" { PageScrollDown; }
              bind "u" { HalfPageScrollUp; }
          }
          renametab {
              bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
          }
          shared_among "renametab" "renamepane" {
              bind "Ctrl c" { SwitchToMode "locked"; }
          }
          renamepane {
              bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
          }
      }

      plugins {
          // Built-in
          about location="zellij:about"
          compact-bar location="zellij:compact-bar"
          configuration location="zellij:configuration"
          filepicker location="zellij:strider" {
              cwd "/"
          }
          plugin-manager location="zellij:plugin-manager"
          session-manager location="zellij:session-manager"
          strider location="zellij:strider"
          welcome-screen location="zellij:session-manager" {
              welcome_screen true
          }

          // User
          zj-quit location="https://github.com/cristiand391/zj-quit/releases/download/0.3.1/zj-quit.wasm" {
              confirm_key "y"
              cancel_key "Esc"
          }
          zj-forgot location="https://github.com/karimould/zellij-forgot/releases/download/0.4.2/zellij_forgot.wasm"
          zjstatus location="https://github.com/dj95/zjstatus/releases/download/v0.20.2/zjstatus.wasm"
          zjstatus-hints location="https://github.com/b0o/zjstatus-hints/releases/latest/download/zjstatus-hints.wasm" {
              max_length "0"
              overflow_str ""
              pipe_name "zjstatus_hints"
          }
      }

      load_plugins {
          zjstatus-hints
      }

      ui {
          pane_frames {
              rounded_corners true
          }
      }

      theme "lavi"
      default_mode "locked"
      default_cwd "~"
      scroll_buffer_size 20000
      show_startup_tips false
      session_name "default"
      attach_to_session true
    '';

    home.file.".config/zellij/layouts/default.kdl".text = ''
      layout {
          default_tab_template {
              children
              pane size=1 borderless=true {
                  plugin location="zjstatus" {
                      format_left   "{mode} {tabs}"
                      format_center ""
                      format_right  "{pipe_zjstatus_hints}{datetime}#[bg=#6e5fb7,fg=#ffffff,bold] {session} "
                      format_space  ""

                      pipe_zjstatus_hints_format "{output}"

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#4C435C]{char}"
                      border_position "top"

                      hide_frame_for_single_pane "true"

                      mode_locked      "#[bg=#6e5fb7,fg=#ffffff,bold] ❤ "
                      mode_normal      "#[bg=#aa87fe,fg=#3c01cd,bold] ❤ NORMAL "
                      mode_resize      "#[bg=#ff9969,fg=#7f3513,bold] ❤ RESIZE "
                      mode_pane        "#[bg=#9FFBB6,fg=#30563a,bold] ❤ PANE "
                      mode_move        "#[bg=#FFD896,fg=#905b00,bold] ❤ MOVE "
                      mode_tab         "#[bg=#80BDFF,fg=#0051a8,bold] ❤ TAB "
                      mode_scroll      "#[bg=#412da2,fg=#c9c0ff,bold] ❤ SCROLL "
                      mode_search      "#[bg=#e28e00,fg=#ffe9c4,bold] ❤ SEARCH "
                      mode_entersearch "#[bg=#e28e00,fg=#ffe9c4,bold] ❤ ENTER SEARCH "
                      mode_renametab   "#[bg=#0051a8,fg=#80BDFF,bold] ❤ RENAME TAB "
                      mode_renamepane  "#[bg=#30563a,fg=#9FFBB6,bold] ❤ RENAME PANE "
                      mode_session     "#[bg=#FF87A5,fg=#7d001f,bold] ❤ SESSION "
                      mode_tmux        "#[bg=#c9c0ff,fg=#412da2,bold] ❤ TMUX "

                      tab_active              "#[bg=#9c73fe,fg=#f2ecff,bold] {index} {name} "
                      tab_active_fullscreen   "#[bg=#9c73fe,fg=#f2ecff,bold] {fullscreen_indicator} {index} {name} "
                      tab_active_sync         "#[bg=#9c73fe,fg=#f2ecff,bold] {sync_indicator} {index} {name} "

                      tab_normal              "#[fg=#7a6c94,bold] {index} {name} "
                      tab_normal_fullscreen   "#[fg=#7a6c94,bold] {fullscreen_indicator} {index} {name} "
                      tab_normal_sync         "#[fg=#7a6c94,bold] {sync_indicator} {index} {name} "

                      tab_separator " "

                      tab_sync_indicator       "󰓦"
                      tab_fullscreen_indicator "󰊓"
                      tab_floating_indicator   "⬚"

                      tab_rename              "#[bg=#80BDFF,fg=#0051a8,bold] {index} {name} {floating_indicator} "

                      tab_display_count         "9"
                      tab_truncate_start_format "#[fg=#FFD080]  +{count}  "
                      tab_truncate_end_format   "#[fg=#FFD080]   +{count} "

                      datetime        "#[fg=#7a6c94,bold] {format} "
                      datetime_format "%H:%M:%S"
                      datetime_timezone "Europe/Paris"
                  }
              }
          }
          tab name=""
      }

    '';
    home.file.".config/zellij/themes/lavi.kdl".text = ''
            themes {
          lavi {
              bg "#25213B"
              fg "#FFF1E0"
              red "#F2637E"
              green "#7CF89C"
              blue "#7583FF"
              yellow "#FFD080"
              magenta "#DC91FF"
              orange "#ff9969"
              cyan "#2BEDC0"
              black "#25213B"
              white "#FFF1E0"

              text_unselected {
                  base "#FFF1E0"
                  background "#25213B"
                  emphasis_0 "#ff9969"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#7583FF"
              }
              text_selected {
                  base "#FFFFFF"
                  background "#4C435C"
                  emphasis_0 "#FF87A5"
                  emphasis_1 "#9FFBB6"
                  emphasis_2 "#FFD896"
                  emphasis_3 "#80BDFF"
              }
              ribbon_unselected {
                  base "#DED4FD"
                  background "#38265A"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#7583FF"
              }
              ribbon_selected {
                  base "#25213B"
                  background "#dbffb3"
                  emphasis_0 "#FF87A5"
                  emphasis_1 "#9FFBB6"
                  emphasis_2 "#FFD896"
                  emphasis_3 "#80BDFF"
              }
              table_title {
                  base "#FFFFFF"
                  background "#483270"
                  emphasis_0 "#DC91FF"
                  emphasis_1 "#2BEDC0"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#7583FF"
              }
              table_cell_unselected {
                  base "#A89CCF"
                  background "#25213B"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#80BDFF"
              }
              table_cell_selected {
                  base "#FFFFFF"
                  background "#564D82"
                  emphasis_0 "#FF87A5"
                  emphasis_1 "#9FFBB6"
                  emphasis_2 "#FFD896"
                  emphasis_3 "#80BDFF"
              }
              list_unselected {
                  base "#DED4FD"
                  background "#25213B"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#80BDFF"
              }
              list_selected {
                  base "#FFFFFF"
                  background "#564D82"
                  emphasis_0 "#FF87A5"
                  emphasis_1 "#9FFBB6"
                  emphasis_2 "#FFD896"
                  emphasis_3 "#80BDFF"
              }
              frame_unselected {
                  base "#79639c"
                  background "#25213B"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#B891FF"
                  emphasis_3 "#80BDFF"
              }
              frame_selected {
                  base "#6f6dc9"
                  background "#25213B"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#B891FF"
                  emphasis_3 "#80BDFF"
              }
              frame_highlight {
                  base "#dbffb3"
                  background "#2F2A38"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#80BDFF"
              }
              exit_code_success {
                  base "#7CF89C"
                  background "#25213B"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#2BEDC0"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#80BDFF"
              }
              exit_code_error {
                  base "#FF87A5"
                  background "#25213B"
                  emphasis_0 "#F2637E"
                  emphasis_1 "#7CF89C"
                  emphasis_2 "#FFD080"
                  emphasis_3 "#80BDFF"
              }
              multiplayer_user_colors {
                  player_1 "#7583FF"
                  player_2 "#A872FB"
                  player_3 "#FFD080"
                  player_4 "#2BEDC0"
                  player_5 "#ff9969"
                  player_6 "#F2637E"
                  player_7 "#7CF89C"
                  player_8 "#DC91FF"
                  player_9 "#3FC4C4"
                  player_10 "#B891FF"
              }
          }
      }
    '';
  };
}
