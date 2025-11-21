{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "kcraft059.msg@gmail.com";
        name = "Kcraft059";
      };
    };
    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}
