{ config, lib, ... }:
{
  options.nix-conf = {
    garbage-collect.enable = lib.mkEnableOption "Whether to enable GC & OPTIMISE periodically";
  };

  config = {
    nix.optimise.dates = lib.optionals config.nix-conf.garbage-collect.enable "12hr";
    nix.gc.dates = lib.optionals config.nix-conf.garbage-collect.enable "12hr";
  };
}
