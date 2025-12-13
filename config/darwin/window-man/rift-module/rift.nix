{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.rift;
in
{
  options.services.rift = with lib.types; {
    enable = lib.mkEnableOption "Whether to enable the rift window-manager";
    package = lib.mkOption {
      type = path;
      default = pkgs.rift;
      description = "The rift package to use.";
    };
    config = lib.mkOption {
      type = str;
      example = '''';
      description = ''
        Raw Toml config
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.rift = {
      serviceConfig.ProgramArguments = [
        "${cfg.package}/bin/rift"
      ];
      /*
        ++ optionals (cfg.config != { } || cfg.extraConfig != "") [
          "-c"
          configFile
        ];
      */
      ## config not supported;

      serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
      serviceConfig.EnvironmentVariables = {
        PATH = "${cfg.package}/bin:${config.environment.systemPath}";
      };

      managedBy = "services.rift.enable";
    };
  };
}
