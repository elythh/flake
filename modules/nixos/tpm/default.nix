{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meadow.services.tpm;
in
{
  options.meadow.services = {
    tpm.enable = mkEnableOption "pipewire";
  };
  config = mkIf cfg.enable {
    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
    users.users.sarw.extraGroups = [ "tss" ]; # tss group has access to TPM devices
  };
}
