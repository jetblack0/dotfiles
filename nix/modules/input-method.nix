# ----------------------------------------------------------------------------
# Input method: fcitx5 with rime (rime-ice schema).
# ----------------------------------------------------------------------------
# What stays shared with every host:
#   - environment.d/20-input-method.conf (core.nix links environment.d)
#   - gtk-im-module in the gtk settings.ini files (desktop.nix)
#   - the fcitx5 theme templates in noctalia's config (desktop.nix)
# Without fcitx5 installed they do nothing.
{
  config,
  pkgs,
  ...
}:

let
  dotfiles = ../../config;
  username = config.core.username;
in
{
  # fcitx5
  # ---------------------------------------------
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = [
      (pkgs.fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-data # default.yaml, which the schema patch applies to
          pkgs.rime-ice
        ];
      })
    ];
  };


  # config files
  # ---------------------------------------------
  home-manager.users.${username} = {
    # fcitx5 rewrites these from its settings window, replacing the store
    # links with plain files; force puts the repo's back on the next switch
    # instead of failing on them
    xdg.configFile."fcitx5" = {
      source = dotfiles + "/config/fcitx5";
      recursive = true;
      force = true;
    };

    # rime reads its user config here and writes build/ next to it, so only
    # the schema patch is linked, not the directory
    xdg.dataFile."fcitx5/rime/default.custom.yaml".source =
      dotfiles + "/share/fcitx5/rime/default.custom.yaml";
  };
}
