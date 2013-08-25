#! /bin/bash

ETC_DIR="/etc/sync-ops-ssh"
TMP_DIR1="/tmp/sync-ops-reconfigure"
TMP_DIR2="/tmp/sync-ops-reconfigure-chroots"
SCRIPT_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
    echo "  Error: You must be root to run this script."
    exit 1
fi

cat "$ETC_DIR/sshd.conf" > $TMP_DIR1
echo "" > $TMP_DIR2

all_allowed=""

for f in "$ETC_DIR/users.d/*" ; do

    user=$(basename $f)
    jail=$(sed -n 's/.*jail-dir *= *\([^ ]*.*\)/\1/p' < $f)
    virtual_device=$(sed -n 's/.*virtual-device *= *\([^ ]*.*\)/\1/p' < $f)
    allowed_address=$(sed -n 's/.*allowed-address *= *\([^ ]*.*\)/\1/p' < $f)

    cat "$SCRIPT_DIR/res/ssh-chroot.model" | sed -e "s@{{username}}@$user@" -e "s@{{jail}}@$jail@" >> "$TMP_DIR2"

    # TODO explode for multi addresses
    all_allowed="$all_allowed $user@$allowed_address "

done


echo "" >> $TMP_DIR1
echo "AllowUsers $all_allowed" >> $TMP_DIR1
echo "" >> $TMP_DIR1
cat "$TMP_DIR2" >> $TMP_DIR1

mv "$TMP_DIR1" "$ETC_DIR/sshd_auto_conf"