{
  pkgs,
  config,
  rift-config,
  ...
}:
{
  xdg.configFile = {
    "rift/config.toml".text = rift-config;
  };
}
