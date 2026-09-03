# ----------------------------------------------------------------------------
# Apple Color Emoji. Not in nixpkgs.
# ----------------------------------------------------------------------------
{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "apple-color-emoji";
  version = "20260722";

  src = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-ttf/releases/download/macos-26-20260722-484daf4e/AppleColorEmoji-Linux.ttf";
    hash = "sha256-43x69iZaxKCvbVe8ZehhCad22ZZug0MzRVf2PaSCUW8=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 "$src" "$out/share/fonts/truetype/apple-color-emoji.ttf"
    runHook postInstall
  '';

  meta = {
    description = "Colour emoji typeface iOS and macOS render emoji with";
    homepage = "https://github.com/samuelngs/apple-emoji-ttf";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
