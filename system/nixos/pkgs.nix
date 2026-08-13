{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages =
    lib.optionals config.system-pkgs.core [
    ]
    ++ lib.optionals config.system-pkgs.additionnals [
    ]
    ++ lib.optionals config.system-pkgs.gui [
      pkgs.kdePackages.dolphin
    ];
}
