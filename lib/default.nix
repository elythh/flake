lib: pkgs: {
  meadow = with lib; rec {
    mkIfElse =
      p: yes: no:
      mkMerge [
        (mkIf p yes)
        (mkIf (!p) no)
      ];

    readSubdirs =
      basePath:
      let
        dirs = builtins.attrNames (
          attrsets.filterAttrs (v: v: v == "directory") (builtins.readDir basePath)
        );
        dirPaths = map (d: basePath + "/${d}") dirs;
      in
      dirPaths;

    recursiveMerge =
      attrList:
      let
        f =
          attrPath:
          zipAttrsWith (
            n: values:
            if tail values == [ ] then
              head values
            else if all isList values then
              unique (concatLists values)
            else if all isAttrs values then
              f (attrPath ++ [ n ]) values
            else
              last values
          );
      in
      f [ ] attrList;

    enableModules =
      moduleNames:
      builtins.listToAttrs (
        builtins.map (m: {
          name = m;
          value = {
            enable = true;
          };
        }) moduleNames
      );

    flattenAttrs =
      prefix: delim: attrs:
      builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (
            key: value:
            let
              newPrefix = if prefix == "" then key else "${prefix}${delim}${key}";
            in
            if builtins.isAttrs value then flattenAttrs newPrefix delim value else [ newPrefix ]
          ) attrs
        )
      );

    fromYAML =
      yaml:
      let
        output =
          pkgs.runCommand "from-yaml"
            {
              inherit yaml;
              allowSubstitutes = false;
              preferLocalBuild = true;
            }
            ''
              ${pkgs.remarshal}/bin/remarshal \
                -if yaml \
                -i <(echo "$yaml") \
                -of json \
                -o $out
            '';
      in
      builtins.fromJSON (builtins.readFile output);

    readYAML = path: fromYAML (builtins.readFile path);
  };
}
