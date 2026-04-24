{
  pkgs,
  ...
}:
{
  programs.fish.enable = true; # puts fish in /etc/shells
  users.defaultUserShell = pkgs.fish;

  # fish enables man caches, disable it
  documentation.man.enable = false;
}
