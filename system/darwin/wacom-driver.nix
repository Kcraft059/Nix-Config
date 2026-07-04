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
      link-script = target: destination: ''
        if ${if config.darwin-system.wacom-driver.enable then "true" else "false"}; then 
          ln -sf "${target}" "${destination}"
        else
          [ -e "${destination}" ] && rm -rf "${destination}"
        fi
      '';
    in
    {
      system.activationScripts.postActivation.text = lib.mkAfter (
        lib.concatStringsSep "\n" [
          (link-script "${pkgs.wacom-tablet-driver}/Library/Frameworks/WacomMultiTouch.framework" "/Library/Frameworks/WacomMultiTouch.framework")
          (link-script "${pkgs.wacom-tablet-driver}/Library/Internet Plug-Ins/WacomTabletPlugin.plugin" "/Library/Internet Plug-Ins/WacomTabletPlugin.plugin")
          (link-script "${pkgs.wacom-tablet-driver}/Library/PreferencePanes/PenTablet.prefpane" "/Library/PreferencePanes/PenTablet.prefpane")
          (link-script "${pkgs.wacom-tablet-driver}/Library/PrivilegedHelperTools/com.wacom.TabletHelper.app" "/Library/PrivilegedHelperTools/com.wacom.TabletHelper.app")
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
