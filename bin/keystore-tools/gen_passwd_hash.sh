#!/usr/bin/env bash

[ -z "$1" ] && echo "This script takes one argument of username."

mkpasswd -m sha-512 > pass_${1} 
