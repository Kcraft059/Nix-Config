{ pkgs, lib, ... }:
{
  installMacApp = # Works Both with DMG and ZIPS
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
        _7zz # Use instead of undmg, for HFS and APFS
        #unzip
      ];
      sourceRoot = sourceRoot;
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      unpackPhase = ''
        7zz x -snld $src
      '';
      installPhase =
        ''
          mkdir -p "$out/Applications/${appname}.app"
          cp -pR * "$out/Applications/${appname}.app"
        ''
        + postInstall;
      meta = with lib; {
        description = description;
        homepage = homepage;
        maintainers = with maintainers; [ Kcraft059 ];
        platforms = platforms.darwin;
      };
    };

}
