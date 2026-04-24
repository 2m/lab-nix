let
  martynas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh";
  users = [ martynas ];

  lab-hb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyfDdZO0WBxvQ++KK0KOAZlLFtwzsq96LH0WdKr6+Iy";
  lab-rpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKf9pENEsef39webOu8x3/EdU9XW6iQgXSzQEG+ijTHc";
  carla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeSL7B5nsq/RTCq9AwuF1hwM35lhMgWi9sP39OaldUY";
in
{
  "restic_password.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "restic_repository.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "cloudflare_token.age" = {
    publicKeys = users ++ [
      lab-hb
      lab-rpi
    ];
    armor = true;
  };
  "qbittorrent.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "jellarr_api_key.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "jellarr_env.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "jellyfin_admin_password.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "grafana_secret_key.age" = {
    publicKeys = users ++ [ lab-hb ];
    armor = true;
  };
  "atuin_key.age" = {
    publicKeys = users ++ [
      lab-hb
      carla
    ];
    armor = true;
  };
}
