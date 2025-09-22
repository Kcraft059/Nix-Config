{
  pkgs,
  config,
  lib,
  systemFonts,
  ...
}:
{
  programs.vscode = {
    package = pkgs.vscode;
    enable = config.home-config.GUIapps.enable;
    profiles.default = {
      userSettings =
        let
          font = lib.optionalString (builtins.elem pkgs.nerd-fonts.jetbrains-mono systemFonts) lib.mkForce "JetBrainsMono Nerd Font";
        in
        {
          "workbench.colorTheme" = lib.mkForce "Rosé Pine Moon";
          "editor.fontSize" = lib.mkForce 13.0;
          "debug.console.fontSize" = lib.mkForce 13.0;
          "markdown.preview.fontSize" = lib.mkForce 13.0;
          "scm.inputFontSize" = lib.mkForce 13.0;
          "terminal.integrated.fontSize" = lib.mkForce 13.0;
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
        };
      extensions = with pkgs.vscode-marketplace; [
        # To use, needs to overlay inputs.nix-vscode-extensions.overlays.default
        jnoortheen.nix-ide
        mvllow.rose-pine
        bmewburn.vscode-intelephense-client
        mkhl.shfmt
        dnicolson.binary-plist
        # SPGoding.datapack-language-server # Not added yet to the packages repo
      ];
    };
  };
}
