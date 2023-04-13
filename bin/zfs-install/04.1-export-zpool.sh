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


export_pool () {
    print "Export zpool $ZNAME"
    zpool export $ZNAME
}

source_prefs
export_pool
