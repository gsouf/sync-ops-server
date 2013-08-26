#!/bin/bash

# Creating a new virtual filesystem intended to host a sync-op repo

# $1 : location of the device
# $2 : size of the disk
# $3 : owner of the repo

## CHECK FOR ROOT
#
if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
    echo "  Error: You must be root to run this script."
    exit 1
fi

## CHECK FOR RSYNC
# TODO : better check (and depending on distro)
if [ ! -f /usr/bin/rsync ] ; then
    echo "Rsync is not installed on the system"
    exit 1
fi


MNT=$(mktemp -d /tmp/sync-ops.mnt.XXXXXXXXXX) || { echo "Failed to create tmp mount dir"; exit 1; }

NEWFILE=$1
USER=$3

# TODO : simplify count ? (add bs ?)
dd if=/dev/zero of=$NEWFILE count=$2

# TODO : partition type and location
mkfs -t ext3 -q $NEWFILE


mount $NEWFILE $MNT

mkdir $MNT/bin
mkdir $MNT/lib
mkdir $MNT/lib64

cp /bin/bash $MNT/bin/bash
cp /usr/bin/rsync $MNT/bin/rsync

ldd /bin/bash | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp --parents '{}' $MNT/
ldd /usr/bin/rsync | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp --parents '{}' $MNT/

mkdir $MNT/inbox
chown "$USER":"$USER" $MNT/inbox

umount $MNT
rmdir $MNT