mydir=$(pwd)
temp=/tmp/macx-install
mkdir -p "$temp"



# install extensions the online way

curl -sL https://hkdb.github.io/app/getapp.sh | bash
yes | app -y install pipx
pipx install gnome-extensions-cli --system-site-packages
# install extensions ONLINE
while IFS= read -r line; do
    gext install "$line"
done < "$mydir/assets/extensions/gnome-extensions-list.txt"


# # install extensions OFFLINE - breaks some extensions!
# cd "$mydir/assets/extensions/extensions-zips"
# for d in *.zip; do gnome-extensions install $d; done

# enable all extensions
while IFS= read -r line; do
    gnome-extensions enable "$line"
done < "$mydir/assets/extensions/gnome-extensions-list.txt"


# TAHOE GTK THEME (vinceliuice)

# enter working directory
mkdir /tmp/macx-install
cd /tmp/macx-install
# gtk theme
git clone https://github.com/vinceliuice/MacTahoe-gtk-theme.git --depth=1
cd MacTahoe-gtk-theme
# yesblur
# ./install.sh -b -l --shell -i simple
# noblur
./install.sh -b -l --shell -i simple
sudo ./tweaks.sh -g -nb  


#wallpaper
cd wallpaper
sudo ./install-gnome-backgrounds.sh
#todo set wallpaper with code # not that important

# Shell dconf settings
dconf load /org/gnome/shell/ < "$mydir/assets/dconf/dconf-settings-shell.ini"
dconf load /org/gnome/desktop/ < "$mydir/assets/dconf/dconf-settings-desktop.ini"




#icon theme
cd $temp
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh -a
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-light'
gsettings set org.gnome.desktop.interface gtk-theme "MacTahoe-Light"
dconf write /org/gnome/shell/extensions/user-theme/name "'MacTahoe-Light-solid'"

# Custom script for switching day/night
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user


cp "$mydir/assets/monitortheme/monitortheme" ~/.local/bin
cp "$mydir/assets/monitortheme/monitortheme.service" ~/.config/systemd/user
cp "$mydir/assets/monitortheme/restartmonitortheme.service" ~/.config/systemd/user
cp "$mydir/assets/monitortheme/restartmonitortheme.timer" ~/.config/systemd/user

# help from gemini
# Reload systemd to see the new file
systemctl --user daemon-reload
# Enable it to run on login
systemctl --user enable --now monitortheme.service
systemctl --user enable --now restartmonitortheme.timer

# todo add libreoffice macros
cp -r "$mydir/assets/lo-macros/Standard1" ~/.config/libreoffice/4/user/basic/Standard1

# todo patch theme



# install extensions
# mkdir -p ~/.local/share/gnome-shell/extensions/
# cp -rf $mydir/assets/extensions/extensions/* ~/.local/share/gnome-shell/extensions/






# install firefox optimization
# Do this at end because I believe that the mactahoe install overwrites user.js

#!/bin/bash
# Get total memory in megabytes
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')

if [ "$MEM_TOTAL" -lt 6000 ]; then
    echo "Memory detected: ~4GB. Running lightweight task..."
    cat "$mydir/assets/firefox/4gb.js" >> ~/.mozilla/firefox/*.default-release/user.js 2>/dev/null
    cat "$mydir/assets/firefox/4gb.js" >> ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*.default-release/user.js 2>/dev/null 2>/dev/null   
    
elif [ "$MEM_TOTAL" -lt 12000 ]; then
    echo "Memory detected: ~8GB. Running medium task..."
    cat "$mydir/assets/firefox/8gb.js" >> ~/.mozilla/firefox/*.default-release/user.js 2>/dev/null
    cat "$mydir/assets/firefox/8gb.js" >> ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*.default-release/user.js 2>/dev/null 2>/dev/null
    
else
    echo "Memory detected: 16GB+. Running heavy task..."
    cat "$mydir/assets/firefox/16gb.js" >> ~/.mozilla/firefox/*.default-release/user.js 2>/dev/null
    cat "$mydir/assets/firefox/16gb.js" >> ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*.default-release/user.js 2>/dev/null 2>/dev/null
fi



# firefox and flatpaks
./tweaks.sh -f default -F
# flatpak theme override (credit vinceliuice)
sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0

# todo through code, set all themes immediately (no gui tweaks app needed)
# macos font! # NO NEED because adwaita sans already looks like macos font



exit


yes | app -y install flatpak
yes | app -y install gnome-tweaks

#flatpak apps
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub io.github.kolunmi.Bazaar -y
flatpak install flathub com.github.tchx84.Flatseal -y
# flatpak install flathub it.mijorus.gearlever -y


# fedora install all media codecs
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install libavcodec-freeworld --allowerasing -y
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install intel-media-driver --allowerasing -y
    sudo dnf install libva-nvidia-driver -y
    sudo dnf install libavcodec-freeworld -y
    sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
    sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
else
    echo "dnf not found. Skipping..."
fi
