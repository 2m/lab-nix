fetch:
    rsync -chavzP --stats root@ssh.lab.2m.lt:/etc/nixos .

push:
    rsync -chavzP --stats ./nixos/ root@ssh.lab.2m.lt:/etc/nixos/

build:
    ssh root@ssh.lab.2m.lt -t 'nixos-rebuild switch'

dev-prep:
    nix profile add github:nixos/nixpkgs#nixd
    nix profile add github:nixos/nixpkgs#nixfmt
    nix profile add github:ryantm/agenix

encrypt secret:
    cd nixos; env EDITOR=hx RULES=./secrets/secrets.nix agenix -e {{secret}}.age
