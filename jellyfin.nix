{
  config,
  pkgs,
  ...
}:

{
  age.secrets.jellarr_api_key.file = ./secrets/jellarr_api_key.age;
  age.secrets.jellarr_env.file = ./secrets/jellarr_env.age;
  age.secrets.jellyfin_admin_password.file = ./secrets/jellyfin_admin_password.age;

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      # For Broadwell and newer (ca. 2014+), use with LIBVA_DRIVER_NAME=iHD:
      intel-media-driver
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  services = {
    jellyfin = {
      enable = true;
    };

    jellarr = {
      enable = true;
      environmentFile = config.age.secrets.jellarr_env.path;

      # Use bootstrap to automatically provision API key into Jellyfin DB
      bootstrap = {
        enable = true;
        apiKeyFile = config.age.secrets.jellarr_api_key.path;
      };

      config = {
        base_url = "https://jelly.lab.2m.lt";

        encoding = {
          allowAv1Encoding = false;
          allowHevcEncoding = false;
          enableDecodingColorDepth10Hevc = true;
          enableDecodingColorDepth10HevcRext = true;
          enableDecodingColorDepth12HevcRext = true;
          enableDecodingColorDepth10Vp9 = true;
          enableHardwareEncoding = true;
          hardwareAccelerationType = "vaapi";
          hardwareDecodingCodecs = [
            "h264"
            "hevc"
            "mpeg2video"
            "vc1"
            "vp8"
            "vp9"
            "av1"
          ];
          vaapiDevice = "/dev/dri/renderD128";
        };

        library = {
          virtualFolders = [
            {
              collectionType = "movies";
              libraryOptions = {
                pathInfos = [
                  {path = "/media/movies/";}
                ];
              };
              name = "Movies";
            }
          ];
        };

        system = {
          enableMetrics = true;
          pluginRepositories = [
            {
              enabled = true;
              name = "Jellyfin Official";
              url = "https://repo.jellyfin.org/releases/plugin/manifest.json";
            }
          ];
          trickplayOptions = {
            enableHwAcceleration = true;
            enableHwEncoding = true;
          };
        };

        users = [
          {
            name = "jellyfin";
            passwordFile = config.age.secrets.jellyfin_admin_password.path;
            policy = {
              isAdministrator = true;
              loginAttemptsBeforeLockout = 5;
            };
          }
        ];

        version = 1;

      };
    };
  };
}
