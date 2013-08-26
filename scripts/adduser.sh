#! /bin/bash

if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
    echo "  Error: You must be root to run this script."
    exit 1
fi


# this script directory
SCRIPT_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# sync-ops-ssh etc dir
ETC_DIR="/etc/sync-ops-ssh"


# TODO
USER="bobito"


# TODO
JAIL="/var/sync-ops/jails/$USER"


# TODO
VDEVICE="/var/sync-ops/devices/$USER.sofs"


# DEVICE SIZE IN Bytes
# TODO
DEVICE_SIZE=20480


# allowed addresses
ALLOWED_ADDR="*"



# TODO check if user exists
# TODO unix user creation if not exists



if [ ! -d "$JAIL" ] ; then
    mkdir -p $JAIL
fi

if [ ! -f "$ETC_DIR/users.d/$USER" ] ; then
    cat "$SCRIPT_DIR/res/user-conf.model" | sed -e "s@{{jail}}@$JAIL@" -e "s@{{virtual-device}}@$VDEVICE@" -e "s@{{address}}@$ALLOWED_ADDR@"  > "$ETC_DIR/users.d/$USER"
    echo "user ssh config created"
fi


# TODO size
if [ ! -f "$VDEVICE" ] ; then
    bash $SCRIPT_DIR/new-vfs.sh $VDEVICE 20480 $USER
    echo "Virtual FS created"
fi


# TODO check if mounted/mountable
bash $SCRIPT_DIR/mount-fs.sh $VDEVICE $JAIL
echo "Virtual FS mounted"



