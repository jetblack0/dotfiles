# ----------------------------------------------------------------------------
# CLI baseline every host gets.
# ----------------------------------------------------------------------------
{
  config,
  lib,
  pkgs,
  ...
}:

let
  dotfiles = ../../config;
  username = config.core.username;

  # yazi plugins. The list comes from config/yazi/package.toml
  yaziPluginFiles =
    let
      deps =
        (builtins.fromTOML (builtins.readFile (dotfiles + "/config/yazi/package.toml"))).plugin.deps
          or [ ];
      names = map (d: lib.last (lib.splitString ":" (lib.last (lib.splitString "/" d.use)))) deps;
      missing = builtins.filter (n: !(pkgs.yaziPlugins ? ${n})) names;
    in
    lib.throwIf (missing != [ ])
      "yazi plugins in package.toml but absent from nixpkgs yaziPlugins: ${lib.concatStringsSep ", " missing}"
      (builtins.listToAttrs (
        map (n: {
          name = "yazi/plugins/${n}.yazi";
          value.source = pkgs.yaziPlugins.${n};
        }) names
      ));
in
{
  # per-host knobs
  # ---------------------------------------------
  options.core = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The primary user (uid 1000), owner of the deployed dotfiles.";
    };
  };

  config = {
    # nix
    # ---------------------------------------------
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];


    # users
    # ---------------------------------------------
    users.users.${username} = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "docker"
        "video"
        "input"
      ];
      shell = pkgs.zsh;
    };


    # packages
    # ---------------------------------------------
    environment.systemPackages = with pkgs; [
      # shell, terminal & files
      bat
      dua
      eza
      fd
      fzf
      jq
      yq-go
      kitty.terminfo
      ouch
      ripgrep
      tmux
      yazi
      zoxide

      # system monitors & info
      bottom
      btop
      fastfetch

      # git & code
      git
      delta
      lazygit
      tokei

      # editor
      neovim
      glow
      tealdeer

      # mail & feeds
      aerc
      newsboat

      # secrets
      pass

      # basics other distros ship and nixos does not
      curl
      diffutils
      file
      gawk
      man-pages
      rsync
      unzip

      # nvim toolchain
      jdk17
      nodejs
      python3
      tree-sitter
      gcc
      gnumake

      # python tooling
      uv

      # cloud & devops
      ansible
      argocd
      awscli2
      docker-compose
      kubernetes-helm
      kubectl
      opentofu
      steampipe

      # ai
      claude-code
      ollama
      opencode

      # proxy
      sing-box

      # misc
      xdg-ninja
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "claude-code"
        "apple-color-emoji"
        "apple-fonts-sf-pro"
      ];

    virtualisation.docker.enable = true;
    programs.nix-ld.enable = true;


    # zsh
    # ---------------------------------------------
    programs.zsh = {
      enable = true;
      shellInit = builtins.readFile (dotfiles + "/etc/zsh/zshenv");
      promptInit = "";
      enableCompletion = false;
    };
    environment.binsh = "${pkgs.dash}/bin/dash";

    # dirs the shell config writes into
    systemd.user.tmpfiles.users.${username}.rules = [
      "d %h/.cache/less"
      "d %h/.cache/zsh"
      "d %h/.local/share/redis"
      "d %h/.local/share/zsh"
    ];


    # home-manager
    # ---------------------------------------------
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-backup";
    home-manager.users.${username} = {
      home.stateVersion = config.system.stateVersion;

      xdg.configFile =
        let
          coreDirs = [
            "aerc"
            "bat"
            "git"
            "glow"
            "lazygit"
            "newsboat"
            "nvim"
            "opencode"
            "shell"
            "tmux"
            "yazi"
          ];
        in
        lib.genAttrs coreDirs (dir: {
          source = dotfiles + "/config/${dir}";
          recursive = true;
        })
        # yazi's plugins/ is untracked (ya pkg owns it on arch), so the flake
        # never copies it -- deploy them from nixpkgs instead
        // yaziPluginFiles;
    };
  };
}
