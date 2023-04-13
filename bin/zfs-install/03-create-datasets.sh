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

create_datasets () {
    # ephemeral dataset
    print "Creating ephemeral dataset"
    zfs create -o mountpoint=none $ZNAME/ephemeral

    # eternal dataset
    print "Creating eternal dataset"
    zfs create -o mountpoint=none $ZNAME/eternal

    # slash dataset
    print "Creating slash dataset in ephemeral"
    zfs create -o mountpoint=legacy $ZNAME/ephemeral/slash
    print "Create empty snapshot of slash dataset"
    zfs snapshot $ZNAME/ephemeral/slash@blank

    # /nix dataset
    print "Creating nix dataset in ephemeral"
    zfs create -o mountpoint=legacy -o atime=off $ZNAME/ephemeral/nix
    
    # /home dataset
    print "Creating home dataset in ephemeral"
    zfs create -o mountpoint=legacy $ZNAME/ephemeral/home
    print "Create empty snapshot of home dataset"
    zfs snapshot $ZNAME/ephemeral/home@blank

    # /persist dataset
    print "Creating persist dataset in eternal"
    zfs create -o mountpoint=legacy $ZNAME/eternal/persist

    # /persist/desktops dataset
    print "Creating desktops dataset in eternal"
    zfs create -o mountpoint=legacy $ZNAME/eternal/persist/desktops
}

export_pool () {
    print "Export zpool"
    zpool export $ZNAME
}

source_prefs
create_datasets
export_pool
