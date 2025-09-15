# Kubernetes cluster setup

This document explains how to setup a kubernetes cluster on servers rented from hetzner.

1. Rent the servers from Hetzner and start recoverymode on them through hetzner UI.

2. To access the UI use the pass repo to log in to `https://robot.your-server.de/` using your password

3. You start recovery mode on a server by going to Servers,
   then select the server from the list so you get a drop down menu, then go to the Rescue tab, select Linux, 64 bit,
   select all the public keys by holding down the mouse button and dragging over them,
   and finally press "Activate rescue mode", you then have to reboot the system.

4. If you cannot access a Hetzner server to reboot it into rescue mode, you can reboot it from UI like this.
   Go to the servers drop down menu,go to the Reset tab,select "Execute an automatic hardware reset" and finally press "Send"

5. Run the Hetzner install image.
   Once recoverymode has been enabled you connect to it and run the hetzner install image,
   which is just a program called installimage that should be automatically available in rescue mode.
   It will start a UI, where you choose which operating system to install. Choose the latest LTS release of ubuntu.
   Do not choose a newer release than that because puppet only supports LTS releases of ubuntu.
   You will be asked to fill out a config, this will also setup some partitions and logical volumes for you.
   If you dont want the RAID with the OS to span accross all the drives,
   you have to outcomment the drives it shouldn't cover in the top of the installimage config.
   You then have to change the drive numbers so that start with 1 and go up by one
   (read the explanation in the config file)
   If one of the drives you want to install OS raid on,
   is not the top entry on the list of drives in the installimage config by default,
   you may experience problems after rebooting.
   If that happens you have to contact Hetzner and make them reorder the drives
   so the ones you want to install OS on come first.
   These where the settings used on KAM also the large drives where commented out,
   so the OS RAID was only on the small/fast drives:

```txt
SWRAID 1
SWRAIDLEVEL 1
HOSTNAME serversname
PART /boot ext3 512M
PART lvm vg0 all
LV vg0 root / ext4 10G
LV vg0 tmp /tmp ext4 1G
LV vg0 var /var ext4 55G
```

That creates two partitions on each of the small drives and two RAID1s
each using one of those partition from each drive,
one getting the ext3 filesystem and getting mounted on /boot,
the other getting a logival-volume-manager and having 3 logical volumes on it,
each of which get ext4 filesystem and get mounted on /, /tmp and /var.
For another example, these are the settings used on KBM.
Here we used all drives because small/fast and big drives where seperated by controller nodes and worker nodes:

```txt
SWRAID 1
SWRAIDLEVEL 1
HOSTNAME serversname
PART /boot ext3 512M
PART lvm vg0 20G
LV vg0 root / ext4 20G
```

That creates a similar situation as on KAM,
but with only 1 LV and where that two RAID1s span accross all available disks.
After install image finishes reboot

(3.) Finish manual part of disk setup
After install image finishedreate any partitions, logical volumes and filesystems that are missing.
Create the partitions with `fdisk`. Just follow fdisk instructions, use `fdisk m` to see options,
`fdisk /dev/sda` -> `n` to create a new partition on sda,
-> `t` -> `fd` to set the partition type to linuz-raid-autodetect,
which is what you need if you want to use this partition in a RAID.

Create RAIDs with
Install ZFS and create zpools and filesystems
Install ZFS with `apt install zfsutils-linux`
Create ZFS filesystems like this

```sh
zpool create mypool mirror /dev/nvme0n1p3 /dev/nvme1n1p3
zpool set asfift=12 mypool
zfs create mypool/docker -o mountpoint=/var/lib/docker
zfs create mypool/log -o mountpoint=/var/log
```
