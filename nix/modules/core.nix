# ----------------------------------------------------------------------------
# CLI baseline every host gets.
# ----------------------------------------------------------------------------
{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  dotfiles = ../../config;
in
{
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
          "bottom"
          "btop"
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
}
