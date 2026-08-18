{ ... }:
{
  services = {
    calibre-web = {
      enable = true;
      options = {
        enableBookUploading = true;
        calibreLibrary = "/var/lib/calibre-library";
        reverseProxyAuth = {
          enable = true;
          header = "X-User";
        };
      };
    };
  };
}
