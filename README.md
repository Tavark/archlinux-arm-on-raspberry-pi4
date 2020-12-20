# raspberry-pi4-archlinux

## Prepare micro SD card 
Installation is based on guide in https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4 with slight changes.

Replace sdX in the following instructions with the device name for the SD card as it appears on your computer.

1. Start fdisk to partition the SD card:

```bash
fdisk /dev/sdX
```

2. At the fdisk prompt, delete old partitions and create a new one:
    * Type **o**. This will clear out any partitions on the drive.
    * Type **p** to list partitions. There should be no partitions left.
    * Type **n**, then **p** for primary, **1** for the first partition on the drive, press **ENTER** to accept the default first sector, then type **+200M** for the last sector.
    * Type **t**, then **c** to set the first partition to type W95 FAT32 (LBA).
    * Type **n**, then **p** for primary, **2** for the second partition on the drive, and then press **ENTER** twice to accept the default first and last sector.
    * Write the partition table and exit by typing **w**.

3. Create and mount the FAT filesystem:
```bash
mkfs.vfat /dev/sdX1
cd /tmp
mkdir boot
mount /dev/sdX1 boot
```

4. Create and mount the ext4 filesystem. When prompted for input hit **ENTER**.
```bash
mkfs.ext4 /dev/sdX2
cd /tmp
mkdir root
mount /dev/sdX2 root
```
5. Download and extract the root filesystem (as root, not via sudo):
```bash

wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
tar -xzvf ArchLinuxARM-rpi-aarch64-latest.tar.gz -C root
sync
wget https://github.com/raspberrypi/firmware/raw/master/boot/bcm2711-rpi-4-b.dtb
cp bcm2711-rpi-4-b.dtb root/boot/bcm2711-rpi-4-b.dtb
```

5. Download dtb for Raspberry PI to make USB work
```bash
wget https://github.com/raspberrypi/firmware/raw/master/boot/bcm2711-rpi-4-b.dtb
cp bcm2711-rpi-4-b.dtb root/boot/bcm2711-rpi-4-b.dtb
```

6. Move boot files to the first partition:
```bash
mv root/boot/* boot
```

7. Before unmounting the partitions, update /etc/fstab for the different SD block device
```bash
sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab
```

8. Unmount the two partitions:
```bash
umount boot root
``` 

## Installation and configuration
Most of the installation descriptions and commands were taken from http://roosnaflak.com/tech-and-research/setting-up-arch-arm-raspberry-pi-4/ and adjusted.

1. Insert the SD card into the Raspberry Pi, connect ethernet, and apply 5V power.
2. Use the serial console or SSH to the IP address given to the board by your router.
    * Login as the default user **alarm** with the password **alarm**.
    * The default root password is **root**.
3. Initialize the pacman keyring and populate the Arch Linux ARM package signing keys:
```bash
pacman-key --init
pacman-key --populate archlinuxarm
```

4. Update system and pacman database
```bash
pacman -Syy
pacman -Syu
```

5. Install sudo and allow members of group wheel to execute any command
```bash
pacman -S sudo
visudo # and uncomment "# %wheel ALL=(ALL) ALL"
```

6. Install packages via pacman
```bash
sudo pacman -S neovim tmux git git-lfs man zsh fzf trash-cli base-devel docker
```

7. Install AUR helper as non root user
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

8. Create a new user
```bash
sudo useradd -m <user> -p <password>
sudo usermod -a -G wheel <user>
```

Check if you're able to login via your new user. You should also change the password for alarm and root.

* (Optional) allow login via ssh with your private key. Therefore login as your new user to your PI.
    ```bash
    mkdir .ssh
    touch .ssh/authorized_keys
    echo "<your ssh-rsa pub>" >> .ssh/authorized_keys
    ```

9. Configure hostname
```bash
sudo hostnamectl set-hostname <new_hostname>
```

10. Configure timezone
```bash
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

## Install and configure ZSH
1. Configure locale
```bash
sudoedit /etc/locale.gen # uncomment "en_US.UTF-8 UTF-8"
locale-gen
```

2. Install meslo font for Powerlevel10k
```bash
yay -S ttf-meslo-nerd-font-powerlevel10k
```

3. Change default shell to zsh
```bash
chsh -s $(which zsh)
``` 

2. Install zplug for zsh plugins
```bash
export ZPLUG_HOME=~/.zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME
```
Copy home/.zshrc and home/.zplugrc into your $HOME-directory

3. Copy configurations .zshrc and .zplugrc to user home
```bash
source .zshrc
```