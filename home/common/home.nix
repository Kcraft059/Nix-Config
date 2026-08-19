{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    home-config.gui = lib.mkEnableOption "Install GUI-Apps ?";
  };

  config = {
    home.packages =
      with pkgs;
      [
        imagemagick # Image editing
        yt-dlp # Video dwonloading tool
        speedtest-go # Speedtest
        mtr # My traceroute
        eza # ls replacement
        viu # image viewer
        sops # Secret management
        bear # generate compile_comand
      ]
      ++ lib.optionals config.home-config.gui [
        audacity
        signal-desktop
      ];
  };
}
