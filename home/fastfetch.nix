{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    home-config.fastfetch.logo = mkOption {
      type = string.type;
      default = "";
      example = literalExpression '''';
      description = ''
        Configure the logo type
      '';
    };
    home-config.fastfetch.osString = mkOption {
      type = string.type;
      default = "OS";
      example = literalExpression '''';
      description = ''
        Configure the OSstring
      '';
    };
  };

  config = {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = config.home-config.fastfetch.logo;
          # "type"= "auto";
          color = {
            "1" = # "38;5;153"
              "red";
            "2" = # "38;5;217"
              "cyan";
            "3" = # "38;5;255"
              "yellow";
            "4" = # "38;5;153"
              "blue";
            "5" = # "38;5;217"
              "green";
            "6" = # "38;5;255"
              "magenta";
            "7" = # "38;5;28";
              "white";
            "8" = # "38;5;160"
              "light_black";
          };
          padding = {
            top = 4;
          };
        };
        display = {
          color = {
            separator = "light_black";
          };
          separator = " │ ";
          constants = [
            ">───────────<Ø>─────────────────────────────────────────────<"
            ">───────────<Ø>───┤\u001b[1;38;5;7mBase System\u001b[0;38;5;8m├─────────────────────────────<"
            ">───────────<Ø>───┤\u001b[1;38;5;7mEnvironnement\u001b[0;38;5;8m├───────────────────────────<"
            ">───────────<Ø>───┤\u001b[1;38;5;7mNetworking\u001b[0;38;5;8m├──────────────────────────────<"
            ">───────────<Ø>───┤\u001b[1;38;5;7mHardware\u001b[0;38;5;8m├────────────────────────────────<"
            "          >─<%>─<"
          ];
        };
        modules = [
          {
            type = "title";
            key = "   HostName ";
            keyColor = "yellow";
            outputColor = "cyan";
            color = {
              user = "38;5;147";
              at = "white";
              host = "38;5;205";
            };
          }
          {
            type = "custom";
            format = "{$6}";
            outputColor = "separator";
          }
          {
            type = "os";
            key = "   " ++ home-config.fastfetch.osString;
            keyColor = "magenta";
            format = "{?pretty-name}{pretty-name}{?}{/pretty-name}{name}{/} {codename}  {#2}[v{version}] [{arch}]";
          }
          {
            type = "custom";
            format = "{$2}";
            outputColor = "separator";
          }
          {
            type = "kernel";
            key = "   Kernel   ";
            format = "{sysname}  {#2}[v{release}]";
            keyColor = "red";
          }
          {
            type = "bootmgr";
            key = "   Boot Man.";
            format = "{name} {#2}{#3}({firmware-path})";
            keyColor = "red";
          }
          {
            type = "custom";
            format = "{$3}";
            outputColor = "separator";
          }
          {
            type = "datetime";
            keyColor = "green";
            key = "   Datetime ";
            format = "{year}-{month-pretty}-{day-in-month} {hour-pretty}={minute-pretty}={second-pretty}  {#2}[{weekday}] [W{week}] [UTC{offset-from-utc}]";
          }
          {
            type = "uptime";
            key = "   Uptime   ";
            keyColor = "green";
          }
          {
            type = "shell";
            key = "   Shell    ";
            format = "{process-name} {#2}[v{version}] [pid {pid}]";
            keyColor = "green";
          }
          {
            type = "terminal";
            key = "   Terminal ";
            format = "{pretty-name} {#2}[v{version}]";
            keyColor = "green";
          }
          {
            type = "terminaltheme";
            key = "   Theme    ";
            keyColor = "green";
          }
          {
            type = "terminalfont";
            key = "   Font     ";
            keyColor = "green";
          }
          {
            type = "packages";
            key = "   Packages ";
            keyColor = "green";
          }
          {
            type = "custom";
            format = "{$4}";
            outputColor = "separator";
          }
          {
            type = "wifi";
            key = "   WIFI     ";
            keyColor = "blue";
          }
          {
            type = "localip";
            key = "   Local IP ";
            keyColor = "blue";
          }
          /*
            {
                "type"= "publicip";
                "key"= "   Public IP";
                "keyColor"= "blue"
            },
          */
          {
            type = "custom";
            format = "{$5}";
            outputColor = "separator";
          }
          {
            type = "host";
            key = "   Model    ";
            keyColor = "cyan";
          }
          {
            type = "display";
            key = "   Display  ";
            keyColor = "cyan";
          }
          {
            type = "cpu";
            key = "   CPU      ";
            showPeCoreCount = true;
            format = "{name}  {#2}[C={core-types}] [{freq-max}]";
            keyColor = "cyan";
          }
          {
            type = "gpu";
            key = "   GPU      ";
            driverSpecific = true;
            format = "{name}  {#2}[C={core-count}]{?frequency} [{frequency}]{?} [{type}]";
            keyColor = "cyan";
          }
          {
            type = "memory";
            key = "   RAM      ";
            keyColor = "cyan";
          }
          {
            type = "swap";
            key = "   SWAP     ";
            keyColor = "cyan";
          }
          {
            type = "disk";
            key = "   Disk     ";
            format = "{#3}({mountpoint}){#0} {size-percentage} | {size-used}/{size-total} - {filesystem} {?is-readonly}{#2}[Read-only]{?}";
            keyColor = "cyan";
          }
          {
            type = "battery";
            key = "   Battery  ";
            keyColor = "cyan";
          }
          {
            type = "custom";
            format = "{$1}";
            outputColor = "separator";
          }
          "break"
          {
            type = "colors";
            paddingLeft = 15;
          }
        ];

      };
    };
    home.file.".config/fastfetch/logo.txt".source = ./configs/fastfetch-logo.txt;
    home.file.".config/fastfetch/config.jsonc".source = ./configs/fastfetch.jsonc;
    #home.packages = [ pkgs.fastfetch ];

  };

}
