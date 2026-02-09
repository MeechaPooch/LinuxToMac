mydir=$(pwd)


# TAHOE GTK THEME (vinceliuice)

# enter working directory
mkdir /tmp/macx-install
cd /tmp/macx-install
# gtk theme
git clone https://github.com/vinceliuice/MacTahoe-gtk-theme.git --depth=1
cd MacTahoe-gtk-theme
./install.sh -b -l --shell -i simple

# firefox and flatpaks
./tweaks.sh -f default -F
# flatpak theme override (credit vinceliuice)
sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0

#wallpaper
cd wallpaper
sudo install-gnome-backgrounds.shinstall-gnome-backgrounds.sh
#todo set wallpaper with code # not that important

# todo through code, set all themes immediately (no gui tweaks app needed)
# macos font! # NO NEED because adwaita sans already looks like macos font

# GDM
sudo ./tweaks.sh -g -nb  



# install extensions
cd $mydir/assets/extensions/extensions-zips
for d in *.zip; do gnome-extensions install $d; done

# Shell dconf settings
dconf load /org/gnome/shell/ < $mydir/dconf/dconf-settings-shell.ini
dconf load /org/gnome/desktop/ < $mydir/dconf/dconf-settings-desktop.ini







# Custom script for switching day/night
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

cp $mydir/assets/monitortheme/monitortheme ~/.local/bin
cp $mydir/assets/monitortheme/monitortheme.service ~/.config/systemd/user
# help from gemini
# Reload systemd to see the new file
systemctl --user daemon-reload
# Enable it to run on login
systemctl --user enable --now monitortheme.service

# todo add libreoffice macros
cp -r $mydir/assets/lo-macros/Standard1 ~/.config/libreoffice/4/user/basic/Standard1

# todo patch theme



# install extensions
# mkdir -p ~/.local/share/gnome-shell/extensions/
# cp -rf $mydir/assets/extensions/extensions/* ~/.local/share/gnome-shell/extensions/
