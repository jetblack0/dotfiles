# ----------------------------------------------------------------------------
# Zen browser, fed from the shared config/zen payload.
# ----------------------------------------------------------------------------
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = ../../config;
  username = config.core.username;

  # The payload prefs, plus the two noctalia's zen template hook maintains.
  userJs = pkgs.writeText "zen-user.js" (
    builtins.readFile (dotfiles + "/zen/user.js")
    + ''
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      user_pref("devtools.chrome.enabled", true);
    ''
  );
in
{
  home-manager.users.${username} =
    { lib, ... }:
    {
      imports = [ inputs.zen-browser.homeModules.default ];

      programs.zen-browser = {
        enable = true;

        # extension installs
        policies = (lib.importJSON (dotfiles + "/zen/policies.json")).policies;

        profiles.default = { };
      };

      xdg.configFile."zen/default/zen-keyboard-shortcuts.json".source =
        dotfiles + "/zen/zen-keyboard-shortcuts.json";

      # A real file, not a store symlink: noctalia's zen template hook edits
      # user.js in place and aborts on a read-only one.
      home.activation.zenUserJs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run install -Dm644 ${userJs} "$HOME/.config/zen/default/user.js"
      '';
    };
}
