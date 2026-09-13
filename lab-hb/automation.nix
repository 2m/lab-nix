{
  lib,
  ...
}:
{
  services.n8n = {
    enable = true;
    environment = {
      N8N_WEBHOOK_URL = "https://atm.lab.2m.lt/";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "n8n"
  ];
}
