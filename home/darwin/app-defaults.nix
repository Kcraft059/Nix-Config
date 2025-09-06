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
        "test".text = "test";
        "glip.plist" = "b";
      };
}
/*
  {

    { x = "a"; y = "b"; }

    home.file."/Users/camille/Library/Preferences/"
  }
*/
