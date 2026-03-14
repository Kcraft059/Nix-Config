{ theme, ... }:
builtins.toJSON {
  colors = {
    AlternateBase = theme.colors.backgrounds.overlay;
    Base = theme.colors.backgrounds.base;
    BrightText = theme.colors.colors.green;
    Button = "#000000";
    ButtonText = theme.colors.text.primary;
    Highlight = theme.colors.backgrounds.highlight_high;
    HighlightedText = theme.colors.colors.blue;
    Link = theme.colors.colors.purple;
    Text = theme.colors.text.primary;
    ToolTipBase = theme.colors.backgrounds.surface;
    ToolTipText = theme.colors.text.primary;
    Window = theme.colors.backgrounds.base;
    WindowText = theme.colors.text.primary;
    fadeAmount = 0.5;
    fadeColor = theme.colors.text.muted;
  };
  logColors = {
    Launcher = theme.colors.colors.purple;
    Error = theme.colors.colors.yellow;
    Warning = theme.colors.colors.yellow;
    Debug = theme.colors.colors.green;
    FatalHighlight = theme.colors.colors.red;
    Fatal = theme.colors.colors.yellow;
  };
  name = "theme.name";
  widgets = "macOS";
}
