let
  martynas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh";
  users = [ martynas ];

  lab2m = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvgQrVRaN5e/73jVtQYJn5pU5Cql+CeKJsrvrIA/n+R";
  systems = [ lab2m ];
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
}
