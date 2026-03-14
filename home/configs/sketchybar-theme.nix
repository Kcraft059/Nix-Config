{
  safe_theme_name,
  theme,
  themeUtils,
  ...
}:
let
  clr = theme.colors;
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
      primary = 0xff${hcv clr.text.primary},
      subtle = 0xff${hcv clr.text.subtle},
      muted = 0xff${hcv clr.text.muted},
    },
    zone = {
      background = function(tpf, tpfunc)
        return tpfunc(0x${hcv clr.backgrounds.overlay}, tpf - 50)
      end,
      border = function(tpf, tpfunc)
        return tpfunc(0x${hcv clr.backgrounds.highlight_med}, tpf - 20)
      end,
      overlay = 0xff${hcv clr.backgrounds.highlight_high}
    },
    colors = {
      red = 0xff${hcv clr.colors.red},
      orange = 0xff${hcv clr.colors.cyan},
      yellow = 0xff${hcv clr.colors.yellow},
      blue = 0xff${hcv clr.colors.blue},
      cyan = 0xff${hcv clr.colors.green},
      purple = 0xff${hcv clr.colors.purple},
      black = 0xff${hcv clr.backgrounds.highlight_low}
    }
  }
''
