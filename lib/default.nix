lib: pkgs: {
  meadow = rec {
    inherit (lib.modules) mkIf mkMerge;
    inherit (lib.lists)
      all
      unique
      concatLists
      head
      tail
      isList
      last
      ;
    inherit (lib.attrsets) zipAttrsWith isAttrs;
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
          lib.attrsets.filterAttrs (_: type: type == "directory") (builtins.readDir basePath)
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
      moduleNames
      |> (builtins.map (m: {
        name = m;
        value = {
          enable = true;
        };
      }))
      |> (builtins.listToAttrs);

    flattenAttrs =
      prefix: delim: attrs:
      attrs
      |> builtins.mapAttrs (
        key: value:
        let
          newPrefix = if prefix == "" then key else "${prefix}${delim}${key}";
        in
        if builtins.isAttrs value then flattenAttrs newPrefix delim value else [ newPrefix ]
      )
      |> builtins.attrValues
      |> builtins.concatLists;

    fromYAML =
      yaml:
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
        ''
      |> builtins.readFile
      |> builtins.fromJSON;

    readYAML = path: fromYAML (builtins.readFile path);
  };
}
