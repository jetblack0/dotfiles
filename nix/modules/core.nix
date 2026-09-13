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

  # Executables from config/bin[/<subdir>] as ~/.local/bin entries
  binScripts =
    subdir:
    let
      root = dotfiles + "/bin${subdir}";
    in
    lib.optionalAttrs (builtins.pathExists root) (
      lib.mapAttrs' (
        name: _:
        lib.nameValuePair ".local/bin/${name}" {
          source = root + "/${name}";
          executable = true;
        }
      ) (lib.filterAttrs (_: type: type == "regular") (builtins.readDir root))
    );

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

    sshAutostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start sshd at boot. Off by default.";
    };
  };

  config = {
    # nix
    # ---------------------------------------------
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];


    # console
    # ---------------------------------------------
    console = {
      font = "ter-d24b";
      keyMap = pkgs.runCommand "us-capslock-escape.map" { } ''
        gunzip -c ${pkgs.kbd}/share/keymaps/i386/qwerty/us.map.gz > $out
        echo 'keycode 58 = Escape' >> $out
      '';
      packages = [ pkgs.terminus_font ];
    };

    # the pc speaker beeps on every boot and on every console bell
    boot.blacklistedKernelModules = [ "pcspkr" ];


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
      cloudflared
      docker-compose
      kubernetes-helm
      kubectl
      linode-cli
      opentofu
      sops
      steampipe

      # networking
      dig
      mtr
      tcpdump
      traceroute

      # ai
      claude-code
      ollama
      opencode

      # proxy
      sing-box
      # the profile's `type: tor` outbound execs this at startup; without it
      # sing-box refuses to start at all, not just .onion
      tor

      # misc
      ventoy
      xdg-ninja
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "claude-code"
        "apple-color-emoji"
        "apple-fonts-sf-pro"
        "ventoy"
      ];

    # ventoy bundles prebuilt blobs nixpkgs will not vouch for (nixpkgs#404663).
    nixpkgs.config.allowInsecurePredicate = pkg: lib.getName pkg == "ventoy";

    virtualisation.docker.enable = true;
    programs.nix-ld.enable = true;


    # ssh
    # ---------------------------------------------
    # Provisioned, not running: sshd_config and the host keys exist so a
    # `systemctl start sshd` is all it takes to reach a desktop from another
    # machine. Hosts that want it at boot set core.sshAutostart.
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true; # the primary user logs in by password
        PermitRootLogin = "no";
      };
    };

    # the openssh module wires sshd into multi-user.target; drop that unless
    # the host opts in
    systemd.services.sshd.wantedBy = lib.mkForce (
      lib.optional config.core.sshAutostart "multi-user.target"
    );


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
            "environment.d"
            "fastfetch"
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

      home.file = binScripts "" // binScripts "/linux";
    };
  };
}
