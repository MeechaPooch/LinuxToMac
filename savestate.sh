assetsfolder="assets"
mkdir -p $assetsfolder/dconf
mkdir -p $assetsfolder/extensions
dconf dump /org/gnome/shell/ > $assetsfolder/dconf/dconf-settings-shell.ini
dconf dump /org/gnome/desktop/ > $assetsfolder/dconf/dconf-settings-desktop.ini

gnome-extensions list --enabled > $assetsfolder/extensions/gnome-extensions-list.txt