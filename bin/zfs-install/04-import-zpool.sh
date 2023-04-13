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

import_pool () {
    print "Import zpool"
    zpool import -d /dev/disk/by-id -R /mnt $ZNAME -N -f
    zfs load-key $ZNAME
}

source_prefs
import_pool
