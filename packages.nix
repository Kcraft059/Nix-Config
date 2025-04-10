{
  pkgs,
  config,
  self,
  ...
}:
let
  pkgsX86 = import pkgs.path {
    system = "x86_64-darwin";
    config = pkgs.config;
  };
  pkgsArm = import pkgs.path {
    system = "aarch64-darwin";
    config = pkgs.config;
  };
in
{
  environment.systemPackages = [
    pkgs.mkalias
    pkgs.ffmpeg
    pkgs.screen
    pkgs.php
    pkgs.neovim
    #pkgs.oh-my-zsh
    #pkgs.zsh-powerlevel10k
    pkgs.openjdk8
    pkgsX86.openjdk17
    pkgs.openjdk23
    #pkgs.alacritty # GUI
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.monocraft
  ];
}
