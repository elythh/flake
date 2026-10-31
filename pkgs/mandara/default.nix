{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libxkbcommon,
  libGL,
  wayland,
  vulkan-loader,
  fontconfig,
  freetype,
  pam,
}:

# Prebuilt release: the source build pins a patched Zed GPUI and needs network access for git deps
stdenv.mkDerivation (finalAttrs: {
  pname = "mandara";
  version = "0.3.4";

  src = fetchurl {
    url = "https://github.com/theHamdiz/mandara/releases/download/v${finalAttrs.version}/mandara-${finalAttrs.version}-x86_64-linux-gnu.tar.gz";
    hash = "sha256-nwzxEFra+kbbi+cn9dH/k9jTwjt8r5Fka7gWMPzBKfw=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    libxkbcommon
    stdenv.cc.cc.lib
  ];

  # dlopen'd by GPUI / wgpu and the lock screen
  runtimeDependencies = [
    libGL
    wayland
    vulkan-loader
    fontconfig
    freetype
    pam
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/mandara -t $out/bin
    install -Dm644 share/applications/org.mandara.studio.desktop -t $out/share/applications
    install -Dm644 share/icons/hicolor/scalable/apps/org.mandara.studio.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 share/pam.d/mandara-lock -t $out/etc/pam.d
    runHook postInstall
  '';

  meta = {
    description = "GPU-accelerated Wayland desktop shell for MangoWM, Niri and Hyprland";
    homepage = "https://github.com/theHamdiz/mandara";
    license = lib.licenses.gpl3Plus;
    mainProgram = "mandara";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
