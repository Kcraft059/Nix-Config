{
  pkgs,
  config,
  self,
  lib,
  system,
  ...
}:
{
  options.nix-conf = {
    garbage-collect.enable = lib.mkEnableOption "Whether to enable GC & OPTIMISE periodically";
  };

  imports = [
    ./../common/nix-conf.nix
  ];

  config = {
    nix.optimise.dates = lib.optionals config.nix-conf.garbage-collect.enable "12hr";
    nix.gc.dates = lib.optionals config.nix-conf.garbage-collect.enable "12hr";
  };
}
