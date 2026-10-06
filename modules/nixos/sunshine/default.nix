{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;

  hyprctl = "${config.programs.hyprland.package}/bin/hyprctl --instance 0";
  jq = getExe pkgs.jq;
  output = "SUNSHINE";
  state = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/sunshine-monitors";

  lua = code: ''${hyprctl} eval "${code}" >/dev/null'';
  dispatch = dsp: lua "hl.dispatch(hl.dsp.${dsp})";
  physicalMonitors = ''$(${hyprctl} monitors -j | ${jq} -r '.[].name | select(. != "${output}")')'';

  # Stream a headless output sized for the client, move every workspace onto it
  # and switch the physical monitors off.
  sessionStart = pkgs.writeShellScript "sunshine-session-start" ''
    mode="''${SUNSHINE_CLIENT_WIDTH:-1920}x''${SUNSHINE_CLIENT_HEIGHT:-1080}@''${SUNSHINE_CLIENT_FPS:-60}"
    physical="${physicalMonitors}"

    # remember which workspace each monitor showed
    ${hyprctl} monitors -j | ${jq} -r '.[] | "\(.name) \(.activeWorkspace.id)"' > "${state}"

    ${hyprctl} output create headless ${output}
    ${lua "hl.monitor({ output = '${output}', mode = '$mode', position = 'auto', scale = 1 })"}

    # every monitor must keep a workspace, park them on empty ones so none of ours stay behind
    for monitor in $physical; do
      ${dispatch "focus({ monitor = '$monitor' })"}
      ${dispatch "focus({ workspace = 'name:parked-$monitor' })"}
    done
    for workspace in $(${hyprctl} workspaces -j | ${jq} -r '.[] | select(.id > 0) | .id'); do
      ${dispatch "workspace.move({ monitor = '${output}', workspace = '$workspace' })"}
    done
    ${dispatch "focus({ monitor = '${output}' })"}

    # Hyprland refuses to disable the last physical monitor, so also turn them all off with DPMS
    for monitor in $physical; do
      ${lua "hl.monitor({ output = '$monitor', disabled = true })"}
    done
    sleep 1
    for monitor in ${physicalMonitors}; do
      ${dispatch "dpms({ action = 'off', monitor = '$monitor' })"}
    done
  '';

  sessionEnd = pkgs.writeShellScript "sunshine-session-end" ''
    for monitor in ${physicalMonitors}; do
      ${dispatch "dpms({ action = 'on', monitor = '$monitor' })"}
    done
    # reloading restores the monitor rules from the config, re-enabling the disabled monitors
    ${hyprctl} reload
    sleep 1
    ${hyprctl} output remove ${output}
    sleep 1

    if [ -f "${state}" ]; then
      while read -r monitor workspace; do
        [ "$monitor" = "${output}" ] && continue
        ${dispatch "workspace.move({ monitor = '$monitor', workspace = '$workspace' })"}
        ${dispatch "focus({ monitor = '$monitor' })"}
        ${dispatch "focus({ workspace = '$workspace' })"}
      done < "${state}"
      rm -f "${state}"
    fi
  '';
in
{
  options.meadow.services.sunshine = {
    enable = mkEnableOption "sunshine";
  };
  config = mkIf config.meadow.services.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        # KMS can't see headless outputs, capture through wlr-screencopy instead
        capture = "wlr";
        output_name = output;
        global_prep_cmd = builtins.toJSON [
          {
            do = "${sessionStart}";
            undo = "${sessionEnd}";
          }
        ];
      };
    };
  };
}
