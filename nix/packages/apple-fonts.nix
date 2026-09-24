{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
  cpio,
}:

stdenvNoCC.mkDerivation {
  pname = "apple-fonts-sf-pro";
  version = "20260911";

  # Apple republishes every release at the same url, which breaks the hash
  # on every new install. The wayback snapshot is immutable, so it goes
  # first; fetchurl only moves on when a download fails, not when the hash
  # is wrong. Bump both together: new snapshot, new hash.
  src = fetchurl {
    urls = [
      "https://web.archive.org/web/20260916202226id_/https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
      "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
    ];
    hash = "sha256-loqzuLH5LC2K9h6waA9cIiTE541ZuYa/AEUCp/wBKRg=";
  };

  nativeBuildInputs = [
    p7zip
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack
    7z x -bso0 -bsp0 "$src"
    cpio -idm --quiet < "Payload~"
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
