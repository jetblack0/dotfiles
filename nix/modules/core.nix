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

      # misc
      xdg-ninja
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

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
        });
    };
  };
}
