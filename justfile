set shell := ["bash", "-euo", "pipefail", "-c"]

check:
    nix flake check --keep-going

check-host host:
    nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel

check-voidling:
    just check-host voidling

check-grovetender:
    just check-host grovetender

check-aurelionite:
    just check-host aurelionite
