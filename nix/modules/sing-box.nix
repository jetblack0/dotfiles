{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.core.username;
  home = config.users.users.${username}.home;
  profileDir = "${home}/.config/sing-box";

  renderConfig = pkgs.writeShellScript "sing-box-render-config" ''
    umask 077
    ${lib.getExe pkgs.yq-go} -o=json "${profileDir}/$1.yaml" > "$RUNTIME_DIRECTORY/policy.json"
    if [ -f "${profileDir}/providers.json" ]; then
      ${lib.getExe pkgs.sing-box} merge "$RUNTIME_DIRECTORY/config.json" \
        -c "$RUNTIME_DIRECTORY/policy.json" \
        -c "${profileDir}/providers.json" > /dev/null
    else
      mv "$RUNTIME_DIRECTORY/policy.json" "$RUNTIME_DIRECTORY/config.json"
    fi
  '';

  capabilities = [
    "CAP_NET_ADMIN"
    "CAP_NET_RAW"
    "CAP_NET_BIND_SERVICE"
    "CAP_SYS_PTRACE"
    "CAP_DAC_READ_SEARCH"
  ];
in
{
  # per-host knobs
  # ---------------------------------------------
  options.singBox.providersTimer = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Refresh the subscription outbounds on a timer. Off by default: it
      reaches the network and rewrites providers.json.
    '';
  };

  options.singBox.providersSchedule = lib.mkOption {
    type = lib.types.str;
    default = "daily";
    description = "OnCalendar expression for the refresh timer.";
  };

  options.singBox.autostartProfiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "laptop" ];
    description = ''
      Profiles started at boot, read from <profileDir>/<name>.yaml.
      Empty means nothing runs until `systemctl start sing-box@<name>`.
    '';
  };

  config = {
    # the service
    # ---------------------------------------------
    systemd.services =
      {
        "sing-box@" = {
          description = "sing-box proxy, profile %i";
          documentation = [ "https://sing-box.sagernet.org" ];
          after = [
            "network.target"
            "nss-lookup.target"
            "network-online.target"
          ];
          requires = [ "network-online.target" ];
          path = [ pkgs.tor ];
          unitConfig.RequiresMountsFor = home;
          serviceConfig = {
            User = "sing-box";
            Group = "sing-box";
            StateDirectory = "sing-box-%i";
            TimeoutStartSec = "300";
            RuntimeDirectory = "sing-box-%i";
            RuntimeDirectoryMode = "0700";
            AmbientCapabilities = capabilities;
            CapabilityBoundingSet = capabilities;
            ExecStartPre = "${renderConfig} %i";
            ExecStart = "${lib.getExe pkgs.sing-box} -D /var/lib/sing-box-%i -c %t/sing-box-%i/config.json run";
            ExecReload = [
              "${renderConfig} %i"
              "${pkgs.coreutils}/bin/kill -HUP $MAINPID"
            ];
            Restart = "on-failure";
            RestartSec = "10s";
            LimitNOFILE = "infinity";
          };
        };
      }
      # Refresh service.
      // lib.optionalAttrs config.singBox.providersTimer {
        sing-box-providers = {
          description = "Refresh sing-box outbounds from the clash subscriptions";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          path = [
            pkgs.yq-go
            pkgs.jq
            pkgs.curl
            pkgs.sing-box
          ];
          serviceConfig = {
            Type = "oneshot";
            User = username;
            ExecStart = "${home}/.local/bin/sing-box-providers --no-reload";
            ExecStartPost = "+${pkgs.systemd}/bin/systemctl reload sing-box@*";
          };
        };
      }
      // lib.genAttrs (map (p: "sing-box@${p}") config.singBox.autostartProfiles) (_: {
        overrideStrategy = "asDropin";
        wantedBy = [ "multi-user.target" ];
      });


    systemd.timers.sing-box-providers = lib.mkIf config.singBox.providersTimer {
      description = "Refresh sing-box outbounds from the clash subscriptions";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = config.singBox.providersSchedule;
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };


    # the daemon's own user
    # ---------------------------------------------
    users.users.sing-box = {
      isSystemUser = true;
      group = "sing-box";
      home = "/var/lib/sing-box";
    };
    users.groups.sing-box = { };

    services.dbus.packages = [ pkgs.sing-box ];


    # the profile directory
    # ---------------------------------------------
    systemd.user.tmpfiles.users.${username}.rules = [ "d %h/.config/sing-box 0700" ];
  };
}
