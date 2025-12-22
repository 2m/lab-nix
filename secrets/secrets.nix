let
  martynas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh";
  users = [ martynas ];

  lab-hb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyfDdZO0WBxvQ++KK0KOAZlLFtwzsq96LH0WdKr6+Iy";
  systems = [ lab-hb ];
in
{
  "restic_password.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
  "restic_repository.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
  "cloudflare_token.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
  "qbittorrent.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
}
