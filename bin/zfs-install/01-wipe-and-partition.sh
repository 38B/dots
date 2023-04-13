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

ask_wipe () {
    ask "Do you want to wipe all datas on $DISK ?"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Clear disk
        dd if=/dev/zero of="$DISK" bs=512 count=1
	zpool labelclear -f "$DISK" || print "zpool labelclear failed on full disk"
        wipefs -af "$DISK"
        sgdisk -Zo "$DISK"
    fi
}

ask_partition () {
    ask "Do you want to partition $DISK ?"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      print "Creating EFI part"
      sgdisk -n1:1M:+1024M -t1:EF00 "$DISK"
      print "Creating ZFS part"
      sgdisk -n3:0:0 -t3:bf01 "$DISK"
      partprobe "$DISK"
      sleep 1
      print "Clear zfs partition label if present"
      zpool labelclear -f "$ZFS" || print "zpool labelclear failed on zfs partition"
      print "Formating EFI part"
      mkfs.vfat "$EFI"
      sleep 1
    fi
}

source_prefs
ask_wipe
ask_partition
