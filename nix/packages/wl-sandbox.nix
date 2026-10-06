# ----------------------------------------------------------------------------
# winebox's helper. Opens a wayland socket whose clients the compositor treats
# as sandboxed. Source in lib/winebox.
# ----------------------------------------------------------------------------
{
  lib,
  stdenv,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
}:

stdenv.mkDerivation {
  pname = "wl-sandbox";
  version = "0.1";

  src = ../../lib/winebox;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [ wayland ];

  # The protocol glue comes from wayland-scanner at build time
  buildPhase = ''
    runHook preBuild
    xml=${wayland-protocols}/share/wayland-protocols/staging/security-context/security-context-v1.xml
    wayland-scanner client-header "$xml" security-context-v1-client-protocol.h
    wayland-scanner private-code "$xml" security-context-v1-protocol.c
    $CC -O2 -Wall -I. wl-sandbox.c security-context-v1-protocol.c \
      $(pkg-config --cflags --libs wayland-client) -o wl-sandbox
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 wl-sandbox "$out/bin/wl-sandbox"
    runHook postInstall
  '';

  meta = {
    description = "Open a wp-security-context-v1 wayland socket for a sandbox";
    platforms = lib.platforms.linux;
    mainProgram = "wl-sandbox";
  };
}
