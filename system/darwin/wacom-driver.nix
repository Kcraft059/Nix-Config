{
  pkgs,
  lib,
  config,
  ...
}:
{

  options.darwin-system.wacom-driver = {
    enable = lib.mkEnableOption "Enable wacom tablet driver";
    auto-run = lib.mkEnableOption "Auto-run tablet driver";
  };

  config =
    let
      link-script =
        abs_path:
        if config.darwin-system.wacom-driver.enable then
          ''[ -e "${abs_path}" ] || ln -s "${pkgs.wacom-tablet-driver}/${abs_path}" "${abs_path}"''
        else
          ''
            [ -e "${abs_path}" ] && rm -rf "${abs_path}"
          '';
    in
    {
      system.activationScripts.postActivation.text = lib.mkAfter (
        lib.concatStringsSep "\n" [
          (link-script "/Library/Frameworks/WacomMultiTouch.framework")
          (link-script "/Library/Internet Plug-Ins/WacomTabletPlugin.plugin")
          (link-script "/Library/PreferencePanes/PenTablet.prefpane")
          (link-script "/Library/PrivilegedHelperTools/com.wacom.TabletHelper.app")
        ]
      );

      environment.systemPackages = lib.mkIf config.darwin-system.wacom-driver.enable [
        pkgs.wacom-tablet-driver
      ];

      launchd.agents."wacom-pentablet-driver" = lib.mkIf config.darwin-system.wacom-driver.enable {
        command = "'${pkgs.wacom-tablet-driver}/Library/Application Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver'";

        environment = {
          "RUN_WITH_LAUNCHD" = "1";
        };

        serviceConfig = {
          Label = "com.wacom.pentablet";
          LimitLoadToSessionType = [
            "Aqua"
            "LoginWindow"
          ];
          RunAtLoad = config.darwin-system.wacom-driver.auto-run;
          KeepAlive = config.darwin-system.wacom-driver.auto-run;
          ThrottleInterval = 2;
        };
      };
    };
}
