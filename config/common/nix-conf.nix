{
  pkgs,
  config,
  self,
  lib,
  #system,
  ...
}:
{

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix.enable = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
  };
  nix.extraOptions = lib.optionalString (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix.gc.options = "-d --delete-older-than 15d";

  ## All of those are now defined in flake.nix
 
  #nixpkgs.hostPlatform = system; # Already specified dynamically
  #nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowUnsupportedSystem = true;
  #nixpkgs.config.allowBroken = true;
  
  ##

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;
  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog

}
