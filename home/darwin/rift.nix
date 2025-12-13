{
  pkgs,
  config,
  global-config,
  ...
}:
{
  xdg.configFile = {
    "rift/config.toml".text = global-config.services.rift.config;
  };
}
