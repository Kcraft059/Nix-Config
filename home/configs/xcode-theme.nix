{ theme, themeUtils, ... }:
let
  clrs = theme.colors;
  rgbFormat = hex: themeUtils.RGBStringSep " " (themeUtils.RGBtoFloatRGB (themeUtils.hexToRGB hex));
in
''
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
  	<key>DVTConsoleDebuggerInputTextColor</key>
  	<string>${rgbFormat clrs.text.primary} 1</string>
  	<key>DVTConsoleDebuggerInputTextFont</key>
  	<string>SFMono-Bold - 11.0</string>
  	<key>DVTConsoleDebuggerOutputTextColor</key>
  	<string>${rgbFormat clrs.text.subtle} 1</string>
  	<key>DVTConsoleDebuggerOutputTextFont</key>
  	<string>SFMono-Regular - 11.0</string>
  	<key>DVTConsoleDebuggerPromptTextColor</key>
  	<string>${rgbFormat clrs.text.primary} 1</string>
  	<key>DVTConsoleDebuggerPromptTextFont</key>
  	<string>SFMono-Bold - 11.0</string>
  	<key>DVTConsoleExectuableInputTextColor</key>
  	<string>${rgbFormat clrs.text.primary} 1</string>
  	<key>DVTConsoleExectuableInputTextFont</key>
  	<string>SFMono-Regular - 11.0</string>
  	<key>DVTConsoleExectuableOutputTextColor</key>
  	<string>${rgbFormat clrs.text.subtle} 1</string>
  	<key>DVTConsoleExectuableOutputTextFont</key>
  	<string>SFMono-Bold - 11.0</string>
  	<key>DVTConsoleTextBackgroundColor</key>
  	<string>${rgbFormat clrs.backgrounds.base} 1</string>
  	<key>DVTConsoleTextInsertionPointColor</key>
  	<string>${rgbFormat clrs.colors.blue} 1</string>
  	<key>DVTConsoleTextSelectionColor</key>
  	<string>${rgbFormat clrs.backgrounds.highlight_med} 1</string>
  	<key>DVTDebuggerInstructionPointerColor</key>
  	<string>${rgbFormat clrs.colors.blue} 1</string>
  	<key>DVTFontAndColorVersion</key>
  	<integer>1</integer>
  	<key>DVTLineSpacing</key>
  	<real>1.1000000238418579</real>
  	<key>DVTMarkupTextBackgroundColor</key>
  	<string>0.96 0.96 0.96 1</string>
  	<key>DVTMarkupTextBorderColor</key>
  	<string>0.8832 0.8832 0.8832 1</string>
  	<key>DVTMarkupTextCodeFont</key>
  	<string>SFMono-Regular - 8.0</string>
  	<key>DVTMarkupTextEmphasisColor</key>
  	<string>0 0 0 1</string>
  	<key>DVTMarkupTextEmphasisFont</key>
  	<string>.SFNS-RegularItalic - 11.0</string>
  	<key>DVTMarkupTextInlineCodeColor</key>
  	<string>${rgbFormat clrs.colors.purple} 1</string>
  	<key>DVTMarkupTextLinkColor</key>
  	<string>0 0 0.8 1</string>
  	<key>DVTMarkupTextLinkFont</key>
  	<string>.SFNS-Regular - 11.0</string>
  	<key>DVTMarkupTextNormalColor</key>
  	<string>0 0 0 1</string>
  	<key>DVTMarkupTextNormalFont</key>
  	<string>.SFNS-Regular - 11.0</string>
  	<key>DVTMarkupTextOtherHeadingColor</key>
  	<string>0 0 0 0.5</string>
  	<key>DVTMarkupTextOtherHeadingFont</key>
  	<string>.SFNS-Regular - 15.4</string>
  	<key>DVTMarkupTextPrimaryHeadingColor</key>
  	<string>0 0 0 1</string>
  	<key>DVTMarkupTextPrimaryHeadingFont</key>
  	<string>.SFNS-Regular - 26.4</string>
  	<key>DVTMarkupTextSecondaryHeadingColor</key>
  	<string>0 0 0 1</string>
  	<key>DVTMarkupTextSecondaryHeadingFont</key>
  	<string>.SFNS-Regular - 19.8</string>
  	<key>DVTMarkupTextStrongColor</key>
  	<string>0 0 0 1</string>
  	<key>DVTMarkupTextStrongFont</key>
  	<string>.SFNS-Bold - 11.0</string>
  	<key>DVTScrollbarMarkerAnalyzerColor</key>
  	<string>0.403922 0.372549 1 1</string>
  	<key>DVTScrollbarMarkerBreakpointColor</key>
  	<string>0.290196 0.290196 0.968627 1</string>
  	<key>DVTScrollbarMarkerDiffColor</key>
  	<string>0.556863 0.556863 0.556863 1</string>
  	<key>DVTScrollbarMarkerDiffConflictColor</key>
  	<string>0.968627 0.290196 0.290196 1</string>
  	<key>DVTScrollbarMarkerErrorColor</key>
  	<string>0.968627 0.290196 0.290196 1</string>
  	<key>DVTScrollbarMarkerRuntimeIssueColor</key>
  	<string>0.643137 0.509804 1 1</string>
  	<key>DVTScrollbarMarkerWarningColor</key>
  	<string>0.937255 0.717647 0.34902 1</string>
  	<key>DVTSourceTextBackground</key>
  	<string>${rgbFormat clrs.backgrounds.base} 1</string>
  	<key>DVTSourceTextBlockDimBackgroundColor</key>
  	<string>0.5 0.5 0.5 1</string>
  	<key>DVTSourceTextCurrentLineHighlightColor</key>
  	<string>${rgbFormat clrs.backgrounds.surface} 1</string>
  	<key>DVTSourceTextInsertionPointColor</key>
  	<string>${rgbFormat clrs.colors.cyan} 1</string>
  	<key>DVTSourceTextInvisiblesColor</key>
  	<string>0.254902 0.313725 0.368627 1</string>
  	<key>DVTSourceTextSelectionColor</key>
  	<string>0.192157 0.180392 0.270588 1</string>
  	<key>DVTSourceTextSyntaxColors</key>
  	<dict>
  		<key>xcode.syntax.attribute</key>
  		<string>${rgbFormat clrs.colors.blue} 1</string>
  		<key>xcode.syntax.character</key>
  		<string>${rgbFormat clrs.colors.cyan} 1</string>
  		<key>xcode.syntax.comment</key>
  		<string>${rgbFormat clrs.text.muted} 1</string>
  		<key>xcode.syntax.comment.doc</key>
  		<string>${rgbFormat clrs.text.muted} 1</string>
  		<key>xcode.syntax.comment.doc.keyword</key>
  		<string>${rgbFormat clrs.text.subtle} 1</string>
  		<key>xcode.syntax.declaration.other</key>
  		<string>${rgbFormat clrs.colors_variant.blue} 1</string>
  		<key>xcode.syntax.declaration.type</key>
  		<string>${rgbFormat clrs.colors.blue} 1</string>
  		<key>xcode.syntax.identifier.class</key>
  		<string>${rgbFormat clrs.colors.green} 1</string>
  		<key>xcode.syntax.identifier.class.system</key>
  		<string>${rgbFormat clrs.colors.red} 1</string>
  		<key>xcode.syntax.identifier.constant</key>
  		<string>${rgbFormat clrs.colors.green} 1</string>
  		<key>xcode.syntax.identifier.constant.system</key>
  		<string>${rgbFormat clrs.colors.red} 1</string>
  		<key>xcode.syntax.identifier.function</key>
  		<string>${rgbFormat clrs.colors.green} 1</string>
  		<key>xcode.syntax.identifier.function.system</key>
  		<string>${rgbFormat clrs.colors.red} 1</string>
  		<key>xcode.syntax.identifier.macro</key>
  		<string>${rgbFormat clrs.colors.purple} 1</string>
  		<key>xcode.syntax.identifier.macro.system</key>
  		<string>${rgbFormat clrs.colors.purple} 1</string>
  		<key>xcode.syntax.identifier.type</key>
  		<string>${rgbFormat clrs.colors.green} 1</string>
  		<key>xcode.syntax.identifier.type.system</key>
  		<string>${rgbFormat clrs.colors.red} 1</string>
  		<key>xcode.syntax.identifier.variable</key>
  		<string>${rgbFormat clrs.colors.green} 1</string>
  		<key>xcode.syntax.identifier.variable.system</key>
  		<string>${rgbFormat clrs.colors.red} 1</string>
  		<key>xcode.syntax.keyword</key>
  		<string>${rgbFormat clrs.colors.blue} 1</string>
  		<key>xcode.syntax.mark</key>
  		<string>${rgbFormat clrs.text.subtle} 1</string>
  		<key>xcode.syntax.markup.code</key>
  		<string>0.665 0.052 0.569 1</string>
  		<key>xcode.syntax.number</key>
  		<string>${rgbFormat clrs.colors.cyan} 1</string>
  		<key>xcode.syntax.plain</key>
  		<string>${rgbFormat clrs.text.primary} 1</string>
  		<key>xcode.syntax.preprocessor</key>
  		<string>${rgbFormat clrs.colors_variant.blue} 1</string>
  		<key>xcode.syntax.string</key>
  		<string>${rgbFormat clrs.colors.yellow} 1</string>
  		<key>xcode.syntax.url</key>
  		<string>${rgbFormat clrs.colors.green} 1</string>
  	</dict>
  	<key>DVTSourceTextSyntaxFonts</key>
  	<dict>
  		<key>xcode.syntax.attribute</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.character</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.comment</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.comment.doc</key>
  		<string>HelveticaNeue - 11.0</string>
  		<key>xcode.syntax.comment.doc.keyword</key>
  		<string>SFMono-Bold - 11.0</string>
  		<key>xcode.syntax.declaration.other</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.declaration.type</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.class</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.class.system</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.constant</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.constant.system</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.function</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.function.system</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.macro</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.macro.system</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.type</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.type.system</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.variable</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.identifier.variable.system</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.keyword</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.mark</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.markup.code</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.number</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.plain</key>
  		<string>SFMono-Medium - 12.0</string>
  		<key>xcode.syntax.preprocessor</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.string</key>
  		<string>SFMono-Medium - 11.0</string>
  		<key>xcode.syntax.url</key>
  		<string>SFMono-Medium - 11.0</string>
  	</dict>
  </dict>
  </plist>
''
