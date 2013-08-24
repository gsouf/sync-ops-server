#!/bin/bash

# Creating a new virtual filesystem intended to host a sync-op repo


# TODO : of and count
dd if=/dev/zero of=/tmp/test-disk count=2097152

# TODO : partition type and location
mkfs -t ext3 -q /tmp/test-disk

