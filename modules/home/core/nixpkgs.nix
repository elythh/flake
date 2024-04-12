{
  nixpkgs.config = {
    permittedInsecurePackages = ["electron-25.9.0"];
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
    packageOverrides = pkgs: rec {
      electron_28 =
        pkgs.electron_28.overrideAttrs
        (oldAttrs: rec {
          buildCommand = let
            electron-unwrapped = pkgs.electron_28.passthru.unwrapped.overrideAttrs (oldAttrs: rec {
              postPatch = builtins.replaceStrings ["--exclude='src/third_party/blink/web_tests/*'"] ["--exclude='src/third_party/blink/web_tests/*' --exclude='src/content/test/data/*'"] oldAttrs.postPatch;
            });
          in ''
            gappsWrapperArgsHook
            mkdir -p $out/bin
            makeWrapper "${electron-unwrapped}/libexec/electron/electron" "$out/bin/electron" \
              "''${gappsWrapperArgs[@]}" \
              --set CHROME_DEVEL_SANDBOX $out/libexec/electron/chrome-sandbox

            ln -s ${electron-unwrapped}/libexec $out/libexec
          '';
        });
      electron =
        pkgs.electron.overrideAttrs
        (oldAttrs: rec {
          buildCommand = let
            electron-unwrapped = pkgs.electron.passthru.unwrapped.overrideAttrs (oldAttrs: rec {
              postPatch = builtins.replaceStrings ["--exclude='src/third_party/blink/web_tests/*'"] ["--exclude='src/third_party/blink/web_tests/*' --exclude='src/content/test/data/*'"] oldAttrs.postPatch;
            });
          in ''
            gappsWrapperArgsHook
            mkdir -p $out/bin
            makeWrapper "${electron-unwrapped}/libexec/electron/electron" "$out/bin/electron" \
              "''${gappsWrapperArgs[@]}" \
              --set CHROME_DEVEL_SANDBOX $out/libexec/electron/chrome-sandbox

            ln -s ${electron-unwrapped}/libexec $out/libexec
          '';
        });
    };
  };
}
