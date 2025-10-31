fetch:
    rsync -chavzP --stats root@46.226.107.71:/etc/nixos .

push:
    rsync -chavzP --stats ./nixos/ root@46.226.107.71:/etc/nixos/
