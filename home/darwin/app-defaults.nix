{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.file =
    lib.mapAttrs'
      (name: value: lib.nameValuePair ("/Users/camille/Library/Preferences/" + name) (value))
      {
        "com.apple.screencapture.plist".source = ../configs/defaults-plists/com.apple.screencapture.plist;
        "com.ethanbills.DockDoor.plist".source = ../configs/defaults-plists/com.ethanbills.DockDoor.plist;
      };
}
