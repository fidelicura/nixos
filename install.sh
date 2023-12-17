echo -e "\n[$] > Creating folders hierarchy..."
mkdir -p $HOME/downloads
mkdir -p $HOME/projects
mkdir -p $HOME/documents
mkdir -p $HOME/documents/notes
mkdir -p $HOME/documents/books
mkdir -p $HOME/documents/music
mkdir -p $HOME/documents/videos
mkdir -p $HOME/documents/pictures

mkdir -p $HOME/.config
mkdir -p $HOME/.local/share/bin
mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/.local/share/icons
mkdir -p $HOME/.local/share/themes
mkdir -p $HOME/.mozilla/firefox/main.main/chrome
mkdir -p $HOME/.mozilla/firefox/main.main/assets
mkdir -p $HOME/.mozilla/firefox/main.main/extensions
echo -e "\n[$] > Hierarchy created successfully!"



echo -e "\n[$] > Stowing configuration files..."
cd configs/ &&
stow -t $HOME */ &&
cd ..
echo -e "\n[$] > Stowing done successfully!\n"



read -p "[$] > Rebuild? " REBUILD_ANSWER
if [ "$REBUILD_ANSWER" = "yes" ] || [ "$REBUILD_ANSWER" = "y" ] || [ "$REBUILD_ANSWER" = "Y" ]; then
  echo -e "\n[$] > Rebuilding NixOS...\n"
  if command -v doas >/dev/null 2>&1; then
    doas nixos-rebuild switch -I nixos-config=./configuration.nix
  else
    sudo nixos-rebuild switch -I nixos-config=./configuration.nix
  fi
  echo -e "\n[$] > Rebuilt NixOS successfully!"
fi
