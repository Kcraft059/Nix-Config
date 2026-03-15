{ theme, ... }:
let
  clrs = theme.colors;
  chck = test_value: fallback: if test_value != null then test_value else fallback;
in
builtins.toJSON {
  colors = {
    AlternateBase = clrs.backgrounds.overlay;
    Base = clrs.backgrounds.base;
    BrightText = clrs.colors.green;
    Button = "#000000";
    ButtonText = clrs.text.primary;
    Highlight = clrs.backgrounds.highlight_high;
    HighlightedText = clrs.colors.blue;
    Link = clrs.colors.purple;
    Text = clrs.text.primary;
    ToolTipBase = clrs.backgrounds.surface;
    ToolTipText = clrs.text.primary;
    Window = clrs.backgrounds.base;
    WindowText = clrs.text.primary;
    fadeAmount = 0.5;
    fadeColor = clrs.text.muted;
  };
  logColors = {
    Launcher = clrs.colors.purple;
    Error = chck clrs.colors.orange clrs.colors.red;
    Warning = clrs.colors.yellow;
    Debug = clrs.colors.green;
    FatalHighlight = clrs.colors.red;
    Fatal = chck clrs.colors.orange clrs.colors.yellow;
  };
  name = "theme.name";
  widgets = "macOS";
}
