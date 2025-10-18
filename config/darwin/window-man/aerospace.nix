# AeroSpace configuration module
{
  pkgs,
  config,
  lib,
  ...
}:

let
  common = import ./common-options.nix { inherit config pkgs; };

  # Enabling
  enable-aerospace = common.enable-aerospace && common.enable-wm;

  # Visual
  barHeight =
    if config.home-manager.users.camille.programs.sketchybar.enable then common.barHeight else 0;
  topGap = barHeight + common.global-padding;
  global-padding = common.global-padding;

  # Behaviour
  workspaceNames = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
  ];
  primaryWorkspaces = lib.take 5 workspaceNames;
  secondaryWorkspaces = lib.drop 5 workspaceNames;
  workspaceAssignments =
    (lib.genAttrs primaryWorkspaces (_: [
      "main"
      "1"
    ]))
    // (lib.genAttrs secondaryWorkspaces (_: [
      "secondary"
      "2"
    ]));

  workspaceListString = lib.concatStringsSep " " (builtins.map (name: "\"${name}\"") workspaceNames);
  primaryWorkspace = builtins.head workspaceNames; # equivalent to 1
  
  # Execs
  aerospaceSetup = pkgs.writeShellScriptBin "aerospace-setup-workspaces" ''
    #!/usr/bin/env bash
    set -euo pipefail

    for ws in ${workspaceListString}; do
      ${pkgs.aerospace}/bin/aerospace workspace "$ws" >/dev/null 2>&1 || true
    done

    ${pkgs.aerospace}/bin/aerospace workspace "${primaryWorkspace}" >/dev/null 2>&1 || true
  '';

  aerospaceSketchybarTrigger = pkgs.writeShellScriptBin "aerospace-sketchybar-trigger" ''
    #!/usr/bin/env bash
    ${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE
  '';

in
{
  environment.systemPackages = [
    aerospaceSetup
    aerospaceSketchybarTrigger
  ];

  services.aerospace = {
    enable = enable-aerospace;
    settings = {
      "after-startup-command" = [
        "exec-and-forget /run/current-system/sw/bin/aerospace-setup-workspaces"
      ];
      gaps = {
        inner.horizontal = global-padding;
        inner.vertical = global-padding;
        outer.left = global-padding;
        outer.right = global-padding;
        outer.bottom = global-padding;
        outer.top = topGap;
        /*= [
          #{ monitor."Built-in Retina Display" = builtinTopGap; }
          topGap # fallback for any other monitor
        ];*/
      };
      "on-focused-monitor-changed" = [
        "move-mouse monitor-lazy-center"
      ];
      "on-focus-changed" = [
        "move-mouse window-lazy-center"
      ];
      "exec-on-workspace-change" = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      "workspace-to-monitor-force-assignment" = workspaceAssignments;
      "on-window-detected" = [
        {
          "if".app-name-regex-substring = "System (Preferences|Settings)";
          run = "layout floating";
        }
        {
          "if".app-name-regex-substring =
            "Archive Utility|Protector|Alfred|Activity Monitor|Console|Calculator";
          run = "layout floating";
        }
      ];
    };
  };
}
