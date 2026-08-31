# ----------------------------------------------------------------------------
# Zen browser, fed from the shared config/zen payload.
# ----------------------------------------------------------------------------
{
  config,
  lib,
  inputs,
  ...
}:

let
  dotfiles = ../../config;
  username = config.core.username;
in
{
  home-manager.users.${username} = {
    imports = [ inputs.zen-browser.homeModules.default ];

    programs.zen-browser = {
      enable = true;

      # extension installs, the same file ansible plants in distribution/
      policies = (lib.importJSON (dotfiles + "/zen/policies.json")).policies;

      profiles.default = {
        # captured prefs; extraConfig lands after settings, last write wins
        extraConfig = builtins.readFile (dotfiles + "/zen/user.js");

        # a fresh profile is at version 0 and the 0->N migration resets the
        # shortcuts on first launch; the pin keeps the deployed set
        settings."zen.keyboard.shortcuts.version" = 20;
      };
    };

    # the full captured set, so the file stays the unit ansible manages too
    xdg.configFile."zen/default/zen-keyboard-shortcuts.json".source =
      dotfiles + "/zen/zen-keyboard-shortcuts.json";
  };
}
