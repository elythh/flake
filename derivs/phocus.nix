{
  stdenvNoCC,
  fetchFromGitHub,
  nodePackages,
  config,
}: let
  colors = config.colorscheme.palette;
in
  stdenvNoCC.mkDerivation rec {
    pname = "phocus";
    version = "d77ea2472d59c134c7748818f72ad26b6ef9c026";

    src = fetchFromGitHub {
      owner = "phocus";
      repo = "gtk";
      rev = version;
      sha256 = "sha256-RvqcjJmz354ukKJhgYP/A5Dn1urt20L+LKbRk0C8Nhs=";
    };

    patches = [
      ../patches/npm.diff
      ../patches/gradients.diff
      ../patches/substitute.diff
    ];

    postPatch = ''
      substituteInPlace scss/gtk-3.0/_colors.scss \
        --replace "@fg@" "#${colors.foreground}" \
        --replace "@fg2@" "#${colors.color7}" \
        --replace "@bg0@" "#${colors.darker}" \
        --replace "@bg1@" "#${colors.background}" \
        --replace "@bg2@" "#${colors.mbg}"\
        --replace "@bg3@" "#${colors.mbg}" \
        --replace "@bg4@" "#${colors.color0}" \
        --replace "@red@" "#${colors.color1}" \
        --replace "@lred@" "#${colors.color9}" \
        --replace "@orange@" "#${colors.color3}" \
        --replace "@lorange@" "#${colors.color11}" \
        --replace "@yellow@" "#${colors.color3}" \
        --replace "@lyellow@" "#${colors.color11}" \
        --replace "@green@" "#${colors.color2}" \
        --replace "@lgreen@" "#${colors.color10}" \
        --replace "@cyan@" "#${colors.color6}" \
        --replace "@lcyan@" "#${colors.color15}" \
        --replace "@blue@" "#${colors.color4}" \
        --replace "@lblue@" "#${colors.color12}" \
        --replace "@purple@" "#${colors.color5}" \
        --replace "@lpurple@" "#${colors.color14}" \
        --replace "@pink@" "#${colors.color5}" \
        --replace "@lpink@" "#${colors.color14}" \
        --replace "@primary@" "#${colors.foreground}" \
        --replace "@secondary@" "#${colors.color15}"
    '';
    nativeBuildInputs = [nodePackages.sass];
    installFlags = ["DESTDIR=$(out)" "PREFIX="];
  }
