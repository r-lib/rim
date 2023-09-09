#!! /bin/sh

set -x

# need a user with $LOCAL_UID

user=`getent passwd $LOCAL_UID | cut -f1 -d:`
if [ -z "$user" ]; then
    adduser -D -u "$LOCAL_UID" rig
    user=rig
fi

# need a user with $LOCAL_GID

group=`getent group $LOCAL_GID | cut -f1 -d:`
if [ -z "$group" ]; then
    addgroup -g "$LOCAL_GID" rig
    group=rig
fi

# We only need acceess to these and it would takes ~10s to chown all the
# files of the rust toolchain

chown $user:$group /home/rigbuild/
chown $user:$group /home/rigbuild/.cargo

exec su -s /bin/sh $user sh -c "$*"
