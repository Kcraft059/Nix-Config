{
  pkgs,
  config,
  self,
  lib,
  ...
}:
{
  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nix.enable = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [
      "root"
      "@wheel"
      "camille"
    ];
  };

  nix.extraOptions = lib.optionalString (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix.gc.options = "-d --delete-older-than 15d";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
}
