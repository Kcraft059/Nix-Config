{ lib, ... }:
{
  imports = [
    ./home.nix
    ./fastfetch.nix
    ./git.nix
    ./btop.nix
    ./atuin.nix
    ./alacritty.nix
    ./ssh.nix
    ./vscode.nix
    ./firefox.nix
    ./nvim.nix
    ./fzf.nix
    ./zsh.nix
    ./bat.nix
  ];

  home-config.GUIapps.enable = lib.mkDefault false;
  home-config.external-drive.enable = lib.mkDefault false;
}
