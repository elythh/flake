{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, hicolor-icon-theme
, jdupes
, boldPanelIcons ? false
, blackPanelIcons ? false
, alternativeIcons ? false
, themeVariants ? [ ]
}:

let pname = "Reversal-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants" [
  "default"
  "purple"
  "pink"
  "red"
  "orange"
  "yellow"
  "green"
  "grey"
  "nord"
  "all"
]
  themeVariants

  stdenvNoCC.mkDerivation
rec {
  inherit pname;

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = pname;
    rev = "bdae2ea365731b25a869fc2c8c6a1fb849eaf5b2";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  buildInputs = [ hicolor-icon-theme ];

  # These fixup steps are slow and unnecessary
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh --dest $out/share/icons \
      --name WhiteSur \
      --theme ${builtins.toString themeVariants} \
      ${lib.optionalString alternativeIcons "--alternative"} \
      ${lib.optionalString boldPanelIcons "--bold"} \
      ${lib.optionalString blackPanelIcons "--black"}
    jdupes --link-soft --recurse $out/share
    runHook postInstall
  '';

  meta = with lib; {
    description = "Reversal style icon theme for Linux desktops";
    homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-thought ];
  };

}
