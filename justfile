fetch:
    rsync -chavzP --stats root@192.168.86.30:/etc/nixos .

push:
    rsync -chavzP --stats ./nixos/ root@192.168.86.30:/etc/nixos/

build:
    ssh root@ssh.lab.2m.lt -t 'nixos-rebuild switch'

upgrade channel:
    ssh root@ssh.lab.2m.lt -t 'nix-channel --add https://nixos.org/channels/nixos-{{channel}} nixos'
    ssh root@ssh.lab.2m.lt -t 'nixos-rebuild switch --upgrade'

cleanup:
    ssh root@ssh.lab.2m.lt -t 'nix-collect-garbage -d'

dev-prep:
    nix profile add github:nixos/nixpkgs#nixd
    nix profile add github:nixos/nixpkgs#nixfmt
    nix profile add github:ryantm/agenix

encrypt secret:
    cd nixos/secrets; env EDITOR=hx agenix -e {{secret}}.age
