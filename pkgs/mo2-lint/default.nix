{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  steam-run,
  p7zip,
  procps,
  xdg-utils,
  cabextract,
}:

# PyInstaller one-file bundle: patching the ELF corrupts the appended archive,
# so the binary is left untouched and run inside steam-run's FHS environment.
# Its bundled protontricks runs Proton's 32-bit wine and /bin/bash scripts directly,
# which is why nixpkgs' protontricks is patched to go through steam-run too.
let
  # the Steam Runtime can't be used on NixOS, same as nixpkgs' protontricks
  wrapperArgs = lib.escapeShellArgs [
    "--set"
    "STEAM_RUNTIME"
    "0"
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      p7zip # otherwise its archive extraction falls back to unar, which nests multi-root archives
      procps
      xdg-utils
      cabextract
    ])
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mo2-lint";
  version = "7.0.0";

  src = fetchurl {
    url = "https://github.com/Furglitch/modorganizer2-linux-installer/releases/download/${finalAttrs.version}/mo2-lint";
    hash = "sha256-bNc1VKVSe9u7zwLlcm0LTaDl/hJXVImd+rWuMp66NBc=";
  };

  dontUnpack = true;
  dontStrip = true;
  dontPatchELF = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/libexec/mo2-lint
    makeWrapper ${lib.getExe steam-run} $out/bin/mo2-lint \
      --add-flags $out/libexec/mo2-lint \
      ${wrapperArgs}

    # the NXM handler is downloaded by `mo2-lint install` and runs protontricks too
    makeWrapper ${lib.getExe steam-run} $out/bin/mo2-nxm-handler \
      --add-flags '"$HOME/.local/share/mo2-lint/nxm-handler"' \
      ${wrapperArgs}
    runHook postInstall
  '';

  meta = {
    description = "Mod Organizer 2 installer for Linux";
    homepage = "https://github.com/Furglitch/modorganizer2-linux-installer";
    license = lib.licenses.gpl3Only;
    mainProgram = "mo2-lint";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
