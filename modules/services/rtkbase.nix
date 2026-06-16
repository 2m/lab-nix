# modules/services/rtkbase.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rtkbase;
in
{
  options.services.rtkbase = {
    enable = lib.mkEnableOption "RTKBase GNSS base station";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../pkgs/rtkbase {
        rtklib = cfg.rtklibPackage;
      };
      description = "RTKBase package to run.";
    };

    rtklibPackage = lib.mkOption {
      type = lib.types.package;
      description = "Package providing str2str, rtkrcv and convbin.";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/rtkbase";
      description = "Mutable RTKBase state directory.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "RTKBase web UI port.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the RTKBase web UI port.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "rtkbase";
      description = "User running RTKBase.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "rtkbase";
      description = "Group running RTKBase.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = [ "dialout" ];
      home = cfg.stateDir;
      createHome = true;
    };

    environment.systemPackages = [
      cfg.package
      cfg.rtklibPackage
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir}/data 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir}/logs 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.rtkbase-init = {
      description = "Initialize mutable RTKBase state directory";
      wantedBy = [ "multi-user.target" ];
      before = [
        "rtkbase-web.service"
        "str2str-tcp.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        if [ ! -e ${cfg.stateDir}/web_app/server.py ]; then
          cp -R ${cfg.package}/share/rtkbase/. ${cfg.stateDir}/
          chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
        fi

        if [ ! -e ${cfg.stateDir}/settings.conf ]; then
          cp ${cfg.stateDir}/settings.conf.default ${cfg.stateDir}/settings.conf
          sed -i \
            -e "s|^web_port=.*|web_port=${toString cfg.port}|" \
            -e "s|^user=.*|user=${cfg.user}|" \
            -e "s|^cast=.*|cast=str2str|" \
            ${cfg.stateDir}/settings.conf
          chown ${cfg.user}:${cfg.group} ${cfg.stateDir}/settings.conf
        fi
      '';
    };

    systemd.services.rtkbase-web = {
      description = "RTKBase Web Server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "rtkbase-init.service"
      ];
      wants = [ "network-online.target" ];
      path = [
        pkgs.systemd
        pkgs.procps
        pkgs.psmisc
        pkgs.socat
      ]
      ++ lib.optional (cfg.rtklibPackage != null) cfg.rtklibPackage;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${cfg.package}/bin/rtkbase-web";
        Restart = "on-failure";
        RestartSec = 30;
        ReadWritePaths = [
          cfg.stateDir
          "/var/tmp"
        ];
      };
    };

    # Use upstream-compatible service name because RTKBase expects
    # str2str_tcp.service.
    systemd.services.str2str_tcp = {
      description = "RTKBase main str2str TCP stream";
      after = [ "rtkbase-init.service" ];
      bindsTo = [ "rtkbase-init.service" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${pkgs.bash}/bin/bash ${cfg.stateDir}/run_cast.sh in_serial out_tcp";
        Restart = "on-failure";
        RestartSec = 10;
      };
      path = [
        pkgs.bash
        pkgs.coreutils
      ]
      ++ lib.optional (cfg.rtklibPackage != null) cfg.rtklibPackage;
    };

    # Use upstream-compatible timer name because RTKBase expects
    # rtkbase_archive.timer.
    systemd.timers.rtkbase_archive = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        Persistent = true;
      };
    };

    # Use upstream-compatible service name because RTKBase expects
    # rtkbase_archive.service.
    systemd.services.rtkbase_archive = {
      description = "Archive and clean RTKBase data";
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${pkgs.bash}/bin/bash ${cfg.stateDir}/archive_and_clean.sh";
      };
      path = [
        pkgs.bash
        pkgs.coreutils
        pkgs.zip
      ];
    };
  };
}
