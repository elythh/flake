{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libgbm,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  systemdLibs,
}:

let
  pname = "teleport-connect";
  version = "18.10.4";
  sourceRoot = "teleport-connect-${version}-x64";

  meta = {
    description = "Desktop client for Teleport, providing secure access to servers, Kubernetes, databases and more";
    homepage = "https://goteleport.com/download/client-tools/";
    license = lib.licenses.unfree;
    mainProgram = "teleport-connect";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  desktopItem = makeDesktopItem {
    name = "teleport-connect";
    desktopName = "Teleport Connect";
    genericName = "Secure access client";
    exec = "teleport-connect %U";
    icon = "teleport-connect";
    comment = meta.description;
    categories = [
      "Network"
      "RemoteAccess"
    ];
    startupWMClass = "teleport-connect";
    mimeTypes = [ "x-scheme-handler/teleport-connect" ];
  };

  libPath = lib.makeLibraryPath [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    systemdLibs
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];
in
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    sourceRoot
    meta
    desktopItem
    ;

  desktopItems = [ desktopItem ];

  src = fetchurl {
    url = "https://cdn.teleport.dev/teleport-connect-${version}-x64.tar.gz";
    hash = "sha256-DrKzfFf+Ko8VdTzmPYA/GxBZJBnY8loa1IlJ47vAc3c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    # Resolve the app's ELF dependencies during auto-patching
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    systemdLibs
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    # pty.node needs libstdc++, which autoPatchelfHook resolves via stdenv.cc.cc
    stdenv.cc.cc
  ];

  autoPatchelfIgnoreMissingDeps = [
    # The main binary dlopens these at runtime; they are resolved via libPath
    "libnotify.so.4"
    "libXss.so.1"
    "libXtst.so.6"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/teleport-connect $out/share
    cp -r . $out/lib/teleport-connect

    chmod +x $out/lib/teleport-connect/teleport-connect

    makeWrapper $out/lib/teleport-connect/teleport-connect $out/bin/teleport-connect \
      --prefix LD_LIBRARY_PATH : "${libPath}:$out/lib/teleport-connect" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -Dm644 ${./teleport-connect.png} \
      $out/share/icons/hicolor/512x512/apps/teleport-connect.png

    runHook postInstall
  '';
})
