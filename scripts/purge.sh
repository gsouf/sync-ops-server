#!/bin/bash

if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
    echo "  Error: You must be root to run this script."
    exit 1
fi

if [ -f "/etc/init.d/sync-ops-ssh.pid" ]; then
    /etc/init.d/sync-ops-ssh stop
fi

rm -Rf /etc/sync-ops-ssh
rm /etc/init.d/sync-ops-ssh
rm /usr/sbin/sync-ops-sshd
rm -Rf /var/run/sync-ops-sshd