# ----------------------------------------------------------------------------
# Wire the self-managed data drive into the user session.
# ----------------------------------------------------------------------------
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.data;
  username = config.core.username;

  xdgDirNames = [
    "desktop"
    "documents"
    "download"
    "music"
    "pictures"
    "projects"
    "publicShare"
    "templates"
    "videos"
  ];

  checkScript = ''
    problems=()
    empty_dirs=()
    data_home=${lib.escapeShellArg cfg.home}

    if [ ! -d "$data_home" ]; then
      problems+=("$data_home does not exist or is not a directory — mount the data drive first")
    else
      ${lib.optionalString cfg.requireMount ''
        if ! ${pkgs.util-linux}/bin/mountpoint -q "$data_home"; then
          problems+=("$data_home is not a mountpoint — the data drive is not mounted (a plain directory needs data.requireMount = false)")
        fi
      ''}
      if [ "$(stat -c %u "$data_home")" != "$(id -u)" ]; then
        problems+=("$data_home is owned by uid $(stat -c %u "$data_home") — fix with: sudo chown $USER: $data_home")
      fi
    fi

    for t in ${lib.escapeShellArgs (lib.attrValues cfg.links ++ lib.attrValues cfg.userDirs)}; do
      [ -d "$data_home/$t" ] || problems+=("$data_home/$t is missing — nix never writes into the second home; put the data there yourself (mkdir -p it, or mv the existing state in)")
    done

    ${lib.concatStrings (
      lib.mapAttrsToList (src: dst: ''
        p="$HOME/${src}"
        if [ -e "$p" ] && [ ! -L "$p" ]; then
          if [ -d "$p" ]; then
            if [ -z "$(ls -A "$p")" ]; then
              empty_dirs+=("$p")
            else
              problems+=("$p is a non-empty directory — merge it into the second home yourself: mv \"$p\" \"$data_home/${dst}\" (or move its contents, minding dotfiles) and rerun")
            fi
          else
            problems+=("$p is a regular file — move it into the second home yourself: mv \"$p\" \"$data_home/${dst}/\"")
          fi
        fi
      '') cfg.links
    )}

    if [ "''${#problems[@]}" -gt 0 ]; then
      printf 'second home not ready:\n' >&2
      printf '  - %s\n' "''${problems[@]}" >&2
      exit 1
    fi

    for d in "''${empty_dirs[@]}"; do
      run rmdir "$d"
    done
  '';
in
{
  # per-host knobs
  # ---------------------------------------------
  options.data = {
    enable = lib.mkEnableOption "wiring the data home into the user session";

    home = lib.mkOption {
      type = lib.types.str;
      default = config.users.users.${username}.home + "/assets";
      description = "Where the data drive is mounted; its layout is hand-managed.";
    };

    requireMount = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Refuse to run unless the data home is a real mountpoint.";
    };

    links = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        ".local/share/zsh" = "state/zsh";
      };
      description = ''
        Directories in $HOME replaced by symlinks into the data home.
        Whole directories, never single files.
      '';
    };

    userDirs = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        documents = "docs";
        download = "downs";
        videos = "media/vids";
        pictures = "media/pics";
      };
      description = "xdg user dirs routed into the data home.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, lib, ... }:
      {
        xdg.userDirs =
          {
            enable = true;
            # never write into the data home
            createDirectories = false;
          }
          // lib.genAttrs xdgDirNames (
            n:
            if cfg.userDirs ? ${lib.toLower n} then
              "${cfg.home}/${cfg.userDirs.${lib.toLower n}}"
            else
              "$HOME/"
          );

        home.file = lib.mapAttrs (src: dst: {
          source = config.lib.file.mkOutOfStoreSymlink "${cfg.home}/${dst}";
        }) cfg.links;

        home.activation.dataCheck = lib.hm.dag.entryBefore [ "checkLinkTargets" ] checkScript;
      };
  };
}
