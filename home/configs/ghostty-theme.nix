{ theme, ... }:
let
  clrs = theme.colors;
in
''
  palette = 0= ${clrs.backgrounds.overlay}
  palette = 1= ${clrs.colors.red}
  palette = 2= ${clrs.colors.green}
  palette = 3= ${clrs.colors.yellow}
  palette = 4= ${clrs.colors.blue}
  palette = 5= ${clrs.colors.purple}
  palette = 6= ${clrs.colors.cyan}
  palette = 7= ${clrs.text.primary}
  palette = 8= ${clrs.text.muted}
  palette = 9= ${clrs.colors_variant.red}
  palette = 10= ${clrs.colors_variant.green}
  palette = 11= ${clrs.colors_variant.yellow}
  palette = 12= ${clrs.colors_variant.blue}
  palette = 13= ${clrs.colors_variant.purple}
  palette = 14= ${clrs.colors_variant.cyan}
  palette = 15= ${clrs.text.primary}
  background = ${clrs.backgrounds.base}
  foreground = ${clrs.text.primary}
  cursor-color = ${clrs.text.primary}
  cursor-text = ${clrs.backgrounds.base}
  selection-background = ${clrs.backgrounds.highlight_med}
  selection-foreground = ${clrs.text.primary}
''
