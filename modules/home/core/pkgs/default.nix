{
  inputs,
  config,
  pkgs,
  ...
}:
let
  pythonWithGitFilterRepo = pkgs.python312.withPackages (ps: [ ps.git-filter-repo ]);
  pruneLargeGitObjects = pkgs.writeShellApplication {
    name = "prune-large-git-objects.sh";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      git
      gnugrep
      pythonWithGitFilterRepo
    ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      usage() {
        cat <<'EOF'
      Usage:
        prune-large-git-objects.sh [--threshold 20M] [--apply] [--yes]

      Finds files that have blob versions >= threshold in Git history, prints them,
      and rewrites history to remove those paths.

      Options:
        --threshold SIZE   Size threshold (default: 20M). Examples: 50M, 500K, 1G
        --apply            Actually rewrite history (without this, it's a dry run)
        --yes              Skip confirmation prompt (only meaningful with --apply)
        -h, --help         Show this help
      EOF
      }

      threshold_human="20M"
      apply=false
      yes=false

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --threshold)
            threshold_human="''${2:-}"
            [[ -n "$threshold_human" ]] || { echo "Missing value for --threshold" >&2; exit 1; }
            shift 2
            ;;
          --apply)
            apply=true
            shift
            ;;
          --yes)
            yes=true
            shift
            ;;
          -h|--help)
            usage
            exit 0
            ;;
          *)
            echo "Unknown argument: $1" >&2
            usage
            exit 1
            ;;
        esac
      done

      git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
        echo "Not inside a git repository." >&2
        exit 1
      }

      if ! command -v git-filter-repo >/dev/null 2>&1; then
        echo "git-filter-repo is required but not found in PATH." >&2
        exit 1
      fi

      threshold_bytes="$(numfmt --from=iec "$threshold_human" 2>/dev/null || true)"
      if [[ -z "''${threshold_bytes:-}" ]]; then
        echo "Invalid threshold: $threshold_human" >&2
        exit 1
      fi

      tmp_dir="$(mktemp -d)"
      cleanup() { rm -rf "$tmp_dir"; }
      trap cleanup EXIT

      paths_file="$tmp_dir/paths.txt"
      report_file="$tmp_dir/report.txt"

      git rev-list --objects --all \
      | git cat-file --batch-check='%(objectname) %(objecttype) %(objectsize) %(rest)' \
      | awk -v min="$threshold_bytes" '
          $2=="blob" && $3>=min && $4!="" {
            path=$4
            size=$3
            if (size > max[path]) {
              max[path]=size
            }
          }
          END {
            for (p in max) {
              print max[p] "\t" p
            }
          }
        ' \
      | sort -nr > "$report_file"

      if [[ ! -s "$report_file" ]]; then
        echo "No files in history at or above $threshold_human."
        exit 0
      fi

      awk -F '\t' '{print $2}' "$report_file" > "$paths_file"

      echo "Files with blob versions >= $threshold_human:"
      awk -F '\t' '{printf "%10s  %s\n", $1, $2}' "$report_file" | numfmt --to=iec --field=1
      echo
      echo "Total paths to remove: $(wc -l < "$paths_file" | tr -d ' ')"

      if [[ "$apply" != true ]]; then
        echo
        echo "Dry run only. Re-run with --apply to rewrite history."
        exit 0
      fi

      if [[ "$yes" != true ]]; then
        read -r -p "Rewrite git history and delete these paths from all commits? [y/N] " reply
        case "$reply" in
          y|Y|yes|YES) ;;
          *) echo "Aborted."; exit 1 ;;
        esac
      fi

      args=(--force)
      while IFS= read -r path; do
        args+=(--path "$path" --invert-paths)
      done < "$paths_file"

      git filter-repo "''${args[@]}"
      git reflog expire --expire=now --all
      git gc --prune=now --aggressive

      echo
      echo "History rewritten. Local repository compacted."
      echo "If this repository has remotes, publish rewritten history with:"
      echo "  git push --force --all"
      echo "  git push --force --tags"
    '';
  };
in
{
  meadow.style.wallpaper = "${inputs.self}/home/shared/walls/${config.meadow.style.theme}.jpg";

  home = {
    username = "gwen";
    homeDirectory = "/home/gwen";
    stateVersion = "25.11";

    packages = with pkgs; [
      inputs.zen-browser.packages.${system}.default
      inputs.slk.packages.${system}.default

      app2unit
      asciinema_3
      bitwarden-desktop
      bore-cli
      bruno
      charm
      charm-freeze
      chromium
      circumflex
      clipse
      colordiff
      crush
      deadnix
      delta
      docker-compose
      doggo
      eza
      fd
      feh
      fx
      fzf
      gcc
      gh
      git-absorb
      gitmoji-cli
      glab
      glow
      gnumake
      go
      google-chrome
      gping
      grimblast
      gum
      helmfile
      httpie
      imagemagick
      inotify-tools
      jq
      jqp
      just
      k9s
      keybase
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      magic-wormhole
      material-symbols
      mods
      navi
      nemo
      networkmanagerapplet
      nh
      nix-fast-build
      nix-inspect
      nix-output-monitor
      nix-search-tv
      nix-update
      nixfmt
      obsidian
      onefetch
      opencode
      openssl
      openvpn
      opkssh
      pavucontrol
      pfetch
      pgcli
      pinentry-gnome3
      playerctl
      pre-commit
      pruneLargeGitObjects
      presenterm
      python312Packages.gst-python
      python312Packages.materialyoucolor
      python312Packages.pillow
      python312Packages.pip
      python312Packages.pygobject3
      python312Packages.setuptools
      python312Packages.virtualenv
      satty
      slides
      sops
      starship
      stern
      syncthing
      teams-for-linux
      telegram-desktop
      television
      tldr
      up
      vegeta
      viddy
      vlc
      wireplumber
      xdotool
      xwayland
    ];
  };
}
