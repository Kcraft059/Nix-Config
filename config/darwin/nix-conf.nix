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
    nix = {
      enable = true;
      settings = {
        experimental-features = "nix-command flakes";
      };
      extraOptions = lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
      optimise = lib.mkIf config.nix-conf.garbage-collect.enable {
        automatic = true;
        interval = {
          #Weekday = 1;
          Hour = 6;
          #Minute = 0;
        };
      };
      gc = lib.mkIf config.nix-conf.garbage-collect.enable {
        automatic = true;
        interval = {
          #Weekday = 1;
          Hour = 6;
          #Minute = 0;
        };
        options = "-d --delete-older-than 15d";
      };
    };

    nixpkgs.hostPlatform = system; # Already specified dynamically
    nixpkgs.config.allowUnfree = true;
    #nixpkgs.config.allowUnsupportedSystem = true;
    #nixpkgs.config.allowBroken = true;

    # Create /etc/zshrc that loads the nix-darwin environment.
    # programs.zsh.enable = true;
    # Set Git commit hash for darwin-version.
    system.configurationRevision = self.rev or self.dirtyRev or null;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
  };
}
