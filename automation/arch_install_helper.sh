#/bin/sh

### Change the language ###
loadkeys de-latin1-nodeadkeys

### Internet Connection ###
# DHCP enabled by default

### Partitioning ###


### Mount the partitions ###
mount /dev/sda1 /mnt
mount /dev/sda2 /mnt/boot
mount /dev/sda5 /mnt/home
swapon /dev/sda6

### Set up mirrors ###
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
wget -O /etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/?country=AT&country=DE&protocol=http&ip_version=4
sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist
rankmirrors -n 6 /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist

### Install the base system ###
pacstrap -i /mnt base

### Generate an fstab ###
genfstab -U -p /mnt >> /mnt/etc/fstab

### Configure the system ###
arch-chroot /mnt

loadkeys de-latin1-nodeadkeys
setfont Lat2-Terminus16

#language
sed -i '' 's/^#en_US/en_US/g' /etc/locale.gen
sed -i '' 's/^#de_AT/de_AT/g' /etc/locale.gen
locale-gen

echo LANG=de_AT.UTF-8 > /etc/locale.conf
echo LC_COLLATE="C" >> /etc/locale.conf
export LANG=de_AT.UTF-8

echo KEYMAP=de-latin1-nodeadkeys > /etc/vconsole.conf
echo FONT=Lat2-Terminus16 >> /etc/vconsole.conf
ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime

# UTC hardwarewatch
hwclock --systohc --utc

#hostname
echo cplt > /etc/hostname

#root password
passwd

#network
#dhcpcd eth0
pacman -S ifplugd wpa_actionid
cp /etc/netctl/examples/netctl-ifplugd /etc/netctl/
cp /etc/netctl/examples/netctl-auto /etc/netctl/
#systemctl enable netctl-auto@wlan0.service 
systemctl enable netctl-ifplugd@eth0.service  

### Install bootloader ###
pacman -S grub-bios os-prober
grub-install --recheck /dev/sda
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo #whatever ??
grub-mkconfig -o /boot/grub/grub.cfg



### Enable Swap on boot ###
#echo "/dev/sda6 none swap defaults 0 0" >> /etc/fstab -- might not be needed


### Performance Tuning ###
## Swappiness ##
SWAPPINESS=1
CACHEPRESSURE=50
sed -c -i "s/\($vm\.swappiness\s*=\s*\).*/\$SWAPPINESS/" /etc/sysctl.conf
sed -c -i "s/\($vm\.vfs_cache_pressure\s*=\s*\).*/\$CACHEPRESSURE/" /etc/sysctl.conf


exit
umount /mnt/{boot,home,}
reboot