{ super }:

super.yabai.overrideAttrs (oldAttrs: {
  src = super.fetchFromGitHub {
    owner = "AhsanFazal";
    repo = "yabai";
    rev = "8880b5cf3f8a7c0fbcc84f9cabcd58c6c9541c05"; # Or pin to a specific commit
    hash = "sha256-KNQy7vtKUtF9wDRAHqK9GfhPN8/grNEW+3r5vudbvYY="; # Replace with actual hash
  };
  dontBuild = false;
  buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.apple-sdk_15 ];
  postPatch = ''
    substituteInPlace makefile \
      --replace-fail "-arch x86_64" ""
  '';
})
