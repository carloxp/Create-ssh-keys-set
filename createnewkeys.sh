#!/bin/bash

# simple script to create 4 types of ssh keys
# note: work on arrays to remove unneeded key
# note: work both for root or user

userhost="<ROOT-OR-USERNAME>@<YOURSERVER>";
location="/root/.ssh";
declare -a keytypes
keytypes=("rsa" "dsa" "ecdsa" "ed25519")
declare -a keybits
keybits=("-b 2048" "-b 1024" "-b 521" "")
keynumber=${#keytypes[@]}-1

# check if /root/.ssh exist
if [ ! -d ${location} ]; then
  mkdir ${location}
fi

# Memo: typically we set the permissions to be:
# /root/.ssh directory:          700 (drwx------)
# public key (ex.: .pub file):   644 (-rw-r--r--)
# private key (ex.: id_rsa):     600 (-rw-------)
# Your home directory should not be writeable by
# the group or others (at most 755 (drwxr-xr-x)).

# set right permissons to .ssh directory
chmod 700 ${location} # drwx------

# create authorized_keys and authorized_keys2 if don't exist
if [ ! -e ${location}/authorized_keys ]; then
  touch ${location}/authorized_keys
fi
if [ ! -e ${location}/authorized_keys2 ]; then
  touch ${location}/authorized_keys2
fi
# set right permissons
chmod 600 ${location}/authorized_keys
chmod 600 ${location}/authorized_keys2

# create keys if don't exist
for ((i=0;i<=keynumber;i++)) do
    if [ ! -e ${location}/id_${keytypes[i]}.pub ]; then
      ssh-keygen -t ${keytypes[i]} ${keybits[i]} -C ${userhost}
    else
      echo "key "${keytypes[i]}" already exist: ssh-keygen -t ${keytypes[i]} ${keybits[i]} -C ${userhost}"
    fi
      chmod 600 ${location}/id_${keytypes[i]}
      chmod 644 ${location}/id_${keytypes[i]}.pub
done

echo "Keys created."
exit 0
