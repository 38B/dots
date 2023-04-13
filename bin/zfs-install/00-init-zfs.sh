#!/usr/bin/env bash
set -e # exit on error

print () {
    echo -e "\n\033[1m> $1\033[0m\n"
}

ask () {
    read -p "> $1 " -r
    echo
}

first_run () {
    if [ -f "./zfs.prefs" ] ; then
      print "zfs.prefs found. move on to step 01"
    else
      tests
      ask_zpool_name
      select_zpool_disk
      select_cold_disk
      generate_hostid
      export_prefs
    fi 
}

tests () {
    ls /sys/firmware/efi/efivars > /dev/null && \
        ping nixos.org -c 1 > /dev/null &&  \
        modprobe zfs &&                         \
        print "Tests ok"
}

select_zpool_disk () {
    print "Select Disk to Install zfs and efi boot" 
    select ENTRY in $(ls /dev/disk/by-id/);
    do
        DISK="/dev/disk/by-id/$ENTRY"
        echo "Installing zfs and efi boot on $ENTRY."
        break
    done
}

select_cold_disk () {
    print "Select Disk to use as cold storage"
    select ENTRY in $(ls /dev/disk/by-id/);
    do
        COLD="/dev/disk/by-id/$ENTRY"
        echo "Cold storage at $ENTRY"
	break
    done
}

ask_zpool_name () {
    ask "Name your zpool: "
    ZNAME=$REPLY
}

generate_hostid () {  
  print "Generate hostid"
  HOSTID=$(head -c8 /etc/machine-id)
}

export_prefs () {
    print "Exporting preferences to nix-install.prefs"
    echo "ZNAME=$ZNAME" > zfs.prefs
    echo "DISK=$DISK" >> zfs.prefs
    echo "COLD=$COLD" >> zfs.prefs
    echo "EFI=$DISK-part1" >> zfs.prefs
    echo "ZFS=$DISK-part3" >> zfs.prefs
    echo "HOSTID=$HOSTID" >> zfs.prefs
}

first_run
