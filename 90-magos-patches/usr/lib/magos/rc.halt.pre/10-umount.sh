#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

PATH=/usr/lib/magos/scripts:$PATH

swapoff -a >/dev/null 2>/dev/null

#umount network fs
egrep "[ ]nfs[ ]|[ ]cifs[ ]" /proc/mounts | awk '{print $2}' | grep -v ^/memory | xargs umount -lf

# umount any modules from /media
for a in `losetup -a | grep '(/media/' | awk '{print $1}' | tr -d :` ;do
   NM=$(grep ^$a" "  /proc/mounts | awk '{print $2}' )
   if echo $NM | grep -q ^/memory/bundles ;then
      deactivate $(basename $NM)
   else
      umount $a 2>/dev/null || umount -l $a 2>/dev/null
   fi
done
# then free any /media
for a in /home `grep /media/ /proc/mounts  | awk '{print $2}'` `grep " /memory/" /proc/mounts | grep -v /memory | awk '{print $2}'` ;do
    grep -q " $a " /proc/mounts || continue
    umount $a
    grep -q " $a " /proc/mounts || continue
    #move unmounted partitions
    mkdir -p /memory/mnt/unmounted$a
    mount --move $a /memory/mnt/unmounted$a
done

for a in /media/* ;do rmdir $a >/dev/null 2>&1 ;done

