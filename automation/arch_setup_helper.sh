#/bin/sh


### Add a user ###
useradd -m -g users -G wheel,games -s /usr/bin/bash cp # Other groups not necessary because of systemd??
passwd cp

pacman -S sudo
EDITOR=nano visudo
#uncomment %wheel ALL=(ALL)ALL

### Configure package management ###
# uncomment multilib

### Install audio stuff ###
pacman -S alsa-utils
alsamixer # Unmute master
speaker-test -c 2

### Install video driver ###
pacman -S nvidia lib32-nvidia-utils

### Install X-Server ###
pacman -S xorg-server xorg-server-utils xorg-xinit mesa

#Change keyboard layout
echo 'Section "InputClass"
    Identifier        "Keyboard Defaults"
    MatchIsKeyboard	  "yes"
    Option	          "XkbLayout" "de"
    Option             "XkbVariant" "nodeadkeys"
EndSection' > /etc/X11/xorg.conf.d/10-keyboard.conf

### Install Gnome ###
pacman -S gnome
systemctl enable gdm.service
systemctl start gdm.service