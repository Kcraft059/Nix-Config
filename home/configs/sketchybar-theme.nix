{
  safe_theme_name,
  theme,
  themeUtils,
  ...
}:
let
  clrs = theme.colors;
  hcv = themeUtils.hexColorToHexValue;
in
''
  ${safe_theme_name} = {
    bar = {
      background = function(tpf, tpfunc)
        return tpfunc(0x161616, 145)
      end,
      border = function(tpf, tpfunc)
        return tpfunc(0x808080, tpf - 20)
      end
    },
    text = {
      primary = 0xff${hcv clrs.text.primary},
      subtle = 0xff${hcv clrs.text.subtle},
      muted = 0xff${hcv clrs.text.muted},
    },
    zone = {
      background = function(tpf, tpfunc)
        return tpfunc(0x${hcv clrs.backgrounds.overlay}, tpf - 50)
      end,
      border = function(tpf, tpfunc)
        return tpfunc(0x${hcv clrs.backgrounds.highlight_med}, tpf - 20)
      end,
      overlay = 0xff${hcv clrs.backgrounds.highlight_high}
    },
    colors = {
      red = 0xff${hcv clrs.colors.red},
      orange = 0xff${hcv clrs.colors.cyan},
      yellow = 0xff${hcv clrs.colors.yellow},
      blue = 0xff${hcv clrs.colors.blue},
      cyan = 0xff${hcv clrs.colors.green},
      purple = 0xff${hcv clrs.colors.purple},
      black = 0xff${hcv clrs.backgrounds.highlight_low}
    }
  }
''
