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
    # Auto upgrade nix package and the daemon service.
    # services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    nix.optimise.interval = lib.mkIf config.nix-conf.garbage-collect.enable {
      #Weekday = 1;
      Hour = 6;
      #Minute = 0;
    };

    nix.gc.interval = lib.mkIf config.nix-conf.garbage-collect.enable {
      #Weekday = 1;
      Hour = 6;
      #Minute = 0;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
  };
}
