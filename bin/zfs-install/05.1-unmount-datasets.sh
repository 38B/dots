#!/usr/bin/env bash
set -e # exit on error

print () {
    echo -e "\n\033[1m> $1\033[0m\n"
}

source_prefs () {
    if [ -f "./zfs.prefs" ] ; then
      source "./zfs.prefs"
    else
      print "Please run 00-init.sh first"
      exit
    fi
}

if_mount_t_unmount () {
  path=$(readlink -f $1)
  if [[ $(findmnt -M "$path") ]]; then 	  
    print "Unmounting $path"
    umount "$path" 
  fi
}

unmount_datasets () {
  if_mount_t_unmount /mnt/cold
  if_mount_t_unmount /mnt/persist/desktops
  if_mount_t_unmount /mnt/persist 
  if_mount_t_unmount /mnt/home
  if_mount_t_unmount /mnt/nix
  if_mount_t_unmount /mnt/boot
  if_mount_t_unmount /mnt
}

source_prefs
unmount_datasets
