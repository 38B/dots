#!/usr/bin/env bash

[ -z "$1" ] && echo "This script takes one argument of username."

ssh-keygen -t ed25519 -f id_${1} -q -P "" -C "${1}::$(date +"%x::%T")"
