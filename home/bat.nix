{ pkgs, lib, ... }:
{
  stylix.targets.bat.enable = false;
  
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
    };
  };
}
