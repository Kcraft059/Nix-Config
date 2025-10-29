{
  pkgs,
  config,
  lib,
  systemFonts,
  ...
}:
{
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    package = pkgs.vscode;
    enable = config.home-config.GUIapps.enable;
    profiles.default = {
      userSettings =
        let
          font =
            lib.optionalString (builtins.elem pkgs.nerd-fonts.jetbrains-mono systemFonts) lib.mkForce
              "JetBrainsMono Nerd Font";
        in
        {
          "workbench.colorTheme" = "Rosé Pine Moon";
          "editor.fontSize" = 13.0;
          "debug.console.fontSize" = 13.0;
          "markdown.preview.fontSize" = 13.0;
          "scm.inputFontSize" = 13.0;
          "terminal.integrated.fontSize" = 13.0;
          "git.openRepositoryInParentFolders" = "always";
          "explorer.confirmDragAndDrop" = false;
          "git.confirmSync" = false;
          "explorer.confirmDelete" = false;
          "editor.detectIndentation" = false;
          "editor.tabSize" = 2;
          "git.suggestSmartCommit" = true;
          "shfmt.executablePath" = "${pkgs.shfmt}/bin/shfmt";
          "editor.fontFamily" = font;
          "debug.console.fontFamily" = font;
          "chat.editor.fontFamily" = font;
          "scm.inputFontFamily" = font;
          "editor.inlayHints.fontFamily" = font;
          "editor.inlineSuggest.fontFamily" = font;
          "workbench.startupEditor" = "none";
          "chat.disableAIFeatures" = true;
          "C_Cpp.vcFormat.newLine.beforeCatch" = false;
          "C_Cpp.vcFormat.newLine.beforeElse" = false;
          "C_Cpp.clang_format_style" = "{ BasedOnStyle: Google, ColumnLimit: 0}";
        };
      extensions = with pkgs.vscode-marketplace; [
        # To use, needs to overlay inputs.nix-vscode-extensions.overlays.default
        jnoortheen.nix-ide
        ms-vscode.cpptools-extension-pack
        mvllow.rose-pine
        bmewburn.vscode-intelephense-client
        mkhl.shfmt
        dnicolson.binary-plist
        # SPGoding.datapack-language-server # Not added yet to the packages repo
      ];
    };
  };
}
