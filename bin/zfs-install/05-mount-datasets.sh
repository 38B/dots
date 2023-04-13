#!/usr/bin/env bash
set -e # exit on error

print () {
    echo -e "\n\033[1m> $1\033[0m\n"
}

ask () {
    read -p "> $1 " -r
    echo
}

source_prefs () {
    if [ -f "./zfs.prefs" ] ; then
      source "./zfs.prefs"
    else
      print "Please run 00-init.sh first"
      exit
    fi
}

if_nodir_t_mkdir () {
  path=$(readlink -f $1)
  if [ ! -d $path ]; then
    print "Creating $path"	  
    mkdir $path
  else
    print "$path found"
  fi
}

mount_datasets () {
  print "Mounting $ZNAME/ephemeral/slash to /mnt"	
  mount -t zfs $ZNAME/ephemeral/slash /mnt
  if_nodir_t_mkdir /mnt/boot
  if_nodir_t_mkdir /mnt/nix
  if_nodir_t_mkdir /mnt/home
  if_nodir_t_mkdir /mnt/persist
  if_nodir_t_mkdir /mnt/cold
  print "Mounting $EFI to /mnt/boot"
  mount -t vfat $EFI /mnt/boot
  print "Mounting $ZNAME/ephemeral/nix to /mnt/nix"
  mount -t zfs $ZNAME/ephemeral/nix /mnt/nix
  print "Mounting $ZNAME/ephemeral/home to /mnt/home"
  mount -t zfs $ZNAME/ephemeral/home /mnt/home
  print "Mounting $ZNAME/eternal/persist to /mnt/persist"
  mount -t zfs $ZNAME/eternal/persist /mnt/persist
  if_nodir_t_mkdir /mnt/persist/desktops
  print "Mounting $ZNAME/eternal/persist/desktops to /mnt/persist/desktops"
  mount -t zfs $ZNAME/eternal/persist/desktops /mnt/persist/desktops
  print "Mounting $COLD to /mnt/cold"
  mount -t exfat $COLD /mnt/cold
}

source_prefs
mount_datasets
