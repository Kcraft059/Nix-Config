{ config, ... }:
{
  # Programs
  programs.firefox = {
    enable = config.home-config.gui;

    profiles = {
      "default" = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.search.defaultenginename" = "Google";
        };
        extensions.force = true;
        search = {
          force = true;
          default = "google";
        };
      };
    };
  };

  stylix.targets.firefox = {
    profileNames = [ "default" ];
    colorTheme.enable = true;
  };
}
