{ config, lib, ... }:
{
  # The compositor is picked per user with `meadow.default.wm` in home-manager,
  # system modules (session, portals, sunshine) follow whatever the users chose.
  options.meadow.wms = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = lib.unique (
      lib.mapAttrsToList (_: user: user.meadow.default.wm) config.home-manager.users
    );
    readOnly = true;
    description = "Window managers selected by the home-manager users.";
  };
}
