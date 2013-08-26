#!/bin/bash


if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
    echo "  Error: You must be root to run this script."
    exit 1
fi

echo ""
echo "### SYNC-OPS-SSH INSTALLER ###"
echo ""

## Init vars

# this script directory
SCRIPT_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# etc directory
ETC_DIRECTORY="/etc/sync-ops-ssh"

# etc directory
ETC_DIRECTORY="/etc/sync-ops-ssh"

# sync-ops-sshd bin file
BIN_FILE="/usr/sbin/sync-ops-sshd"

# sshd bin file
SSHD_BIN="/usr/sbin/sshd"

#init file
INIT_FILE="/etc/init.d/sync-ops-ssh"



## CREATE THE SSH PARALLEL DAEMON


#  create symlink to actual sshd file
#
if [ ! -f $BIN_FILE ]
then
    ln -s $SSHD_BIN $BIN_FILE
    echo sync-ops-sshd symlink created : $BIN_FILE
fi


# create the base conf directory
#
if [ ! -d "$ETC_DIRECTORY" ]; then
  mkdir $ETC_DIRECTORY
  echo $ETC_DIRECTORY created
fi


# DSA key
#
if [ ! -f "$ETC_DIRECTORY/ssh_host_dsa_key" ]; then
    ssh-keygen -t dsa -f "$ETC_DIRECTORY/ssh_host_dsa_key" -N '' -q
    echo DSA key generated
fi
# RSA key
#
if [ ! -f "$ETC_DIRECTORY/ssh_host_rsa_key" ]; then
    ssh-keygen -t rsa -f "$ETC_DIRECTORY/ssh_host_rsa_key" -N '' -q
    echo RSA key generated
fi
# ECDSA key
#
if [ ! -f "$ETC_DIRECTORY/ssh_host_ecdsa_key" ]; then
    ssh-keygen -t ecdsa -f "$ETC_DIRECTORY/ssh_host_ecdsa_key" -N '' -q
    echo ECDSA key generated
fi


# create the base conf directory
#
if [ ! -d "$ETC_DIRECTORY/users.d" ]; then
  mkdir "$ETC_DIRECTORY/users.d"
  echo $ETC_DIRECTORY/users.d created
fi

# create the allowed users conf file
#
if [ ! -f "$ETC_DIRECTORY/allowed-users" ]; then
  touch "$ETC_DIRECTORY/allowed-users"
  echo "$ETC_DIRECTORY/allowed-users" created
fi

# create the base config from the model
#
if [ ! -f "$ETC_DIRECTORY/sshd.conf" ]; then
    cat "$SCRIPT_DIR/res/ssh-default.model" | sed -e "s@{{etc_dir}}@$ETC_DIRECTORY@" > "$ETC_DIRECTORY/sshd.conf"
    echo Default config file created
fi


# create the init file from the model
#
if [ ! -f "$INIT_FILE" ]; then
    cat "$SCRIPT_DIR/res/init-script.model" | sed -e "s@{{etc_dir}}@$ETC_DIRECTORY@" -e "s@{{bin_file}}@$BIN_FILE@" > "$INIT_FILE"
    chmod +x "$INIT_FILE"
    echo Init script created
fi


# create the devices dir
#
if [ ! -d "/var/sync-ops/devices" ]; then
  mkdir -p "/var/sync-ops/devices"
  echo /var/sync-ops/devices created
fi

echo ""
echo "sync-ops ssh was installed in addition of the default ssh"
echo "For more security we recommend you to allow"
echo "only certain users to login to the defaut ssh"
echo "Add the following to your /etc/ssh/sshd_conf : AllowUsers user1 user2"
echo ""