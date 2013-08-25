#!/bin/bash

# Creating a new virtual filesystem intended to host a sync-op repo

# $1 : location of the device
# $2 : size of the disk

# TODO : of and count
dd if=/dev/zero of=$1 count=$2

# TODO : partition type and location
mkfs -t ext3 -q $1

