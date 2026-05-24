{ pkgs, lib, ... }:
let
  packageHelper = import ./utils/app-install.nix { inherit pkgs lib; };
in
packageHelper.installMacApp {
  name = "raycast";
  appname = "Raycast";
  version = "0.60.0.0";
  sourceRoot = "Raycast Beta.app";
  src = pkgs.fetchurl {
    url = "https://x-r2.raycast-releases.com/Raycast_Beta_0.60.1.0_b841f79494_arm64.dmg";
    sha256 = "0hzl70aminax9z2jzyrj7msfqjax961vagqxv0jzgbl61iccx4xp";
  };
  description = "A collection of powerful productivity tools all within an extendable launcher. Fast, ergonomic and reliable.";
  homepage = "https://www.raycast.com";
}
