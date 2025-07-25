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

    nix.optimise.automatic = lib.optionals config.nix-conf.garbage-collect.enable true;
    nix.optimise.interval = lib.mkIf config.nix-conf.garbage-collect.enable {
      #Weekday = 1;
      Hour = 6;
      #Minute = 0;
    };

    nix.gc.automatic = lib.optionals config.nix-conf.garbage-collect.enable true;
    nix.gc.interval = lib.mkIf config.nix-conf.garbage-collect.enable {
      #Weekday = 1;
      Hour = 6;
      #Minute = 0;
    };
    #nix.gc.options = "--delete-older-than 5d"; #Already setup in common 

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
  };
}
