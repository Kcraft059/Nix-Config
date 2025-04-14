{ pkgs, lib, ... }:
{
  instDMGapp =
    {
      name,
      appname ? name,
      version,
      src,
      description,
      homepage,
      postInstall ? "",
      sourceRoot ? ".",
      ...
    }:
    with pkgs;
    stdenv.mkDerivation {
      name = "${name}-${version}";
      version = "${version}";
      src = src;
      buildInputs = [
        undmg
        unzip
      ];
      sourceRoot = sourceRoot;
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      installPhase =
        ''
          mkdir -p "$out/Applications/${appname}.app"
          cp -pR * "$out/Applications/${appname}.app"
        ''
        + postInstall;
      meta = with lib; {
        description = description;
        homepage = homepage;
        maintainers = with maintainers; [ kfreitag1 ];
        platforms = platforms.darwin;
      };
    };

}
