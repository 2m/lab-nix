
build:
    ssh root@192.168.86.30 -t 'nixos-rebuild switch --flake /etc/nixos#lab2m'

cleanup:
    ssh root@ssh.lab.2m.lt -t 'nix-collect-garbage -d'

dev-prep:
    nix profile add github:nixos/nixpkgs#nixd
    nix profile add github:nixos/nixpkgs#nixfmt
    nix profile add github:ryantm/agenix

encrypt secret:
    cd nixos/secrets; env EDITOR=hx agenix -e {{secret}}.age
