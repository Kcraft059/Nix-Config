{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "kcraft059.msg@gmail.com";
    userName = "Kcraft059";
    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}
