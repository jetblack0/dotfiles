{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:

stdenvNoCC.mkDerivation {
  pname = "apple-fonts-sf-pro";
  version = "20260906";

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    hash = "sha256-qQlPDem3idc1RO5Q/FKgiE1Kn3/PYt5Sl04yBPOnSmI=";
  };

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    runHook preUnpack
    7z x -bso0 -bsp0 "$src"
    7z x -bso0 -bsp0 "SFProFonts/SF Pro Fonts.pkg"
    7z x -bso0 -bsp0 "Payload~"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out/share/fonts/opentype" Library/Fonts/*.otf
    install -Dm444 -t "$out/share/fonts/truetype" Library/Fonts/*.ttf
    runHook postInstall
  '';

  meta = {
    description = "Apple's San Francisco Pro family: variable, Display, Text and Rounded cuts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
