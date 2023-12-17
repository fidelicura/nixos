echo -e "\n[$] > Cleaning NixOS garbage...\n"
doas nix-collect-garbage --delete-old &&
doas nix-collect-garbage -d &&
doas /run/current-system/bin/switch-to-configuration boot
echo -e "\n[$] > NixOS garbage successfully cleared!\n"

