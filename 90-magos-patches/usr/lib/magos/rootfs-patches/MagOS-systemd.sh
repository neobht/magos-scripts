#!/bin/bash
SERVICESMASK="abrtd hostapd irqbalance smartd bumblebeed dhcpd6 \
NetworkManager-wait-online fedora-loadmodules fedora-storage-init-late.service fedora-storage-init sshd \
tor rpcbind xinetd crond lvm2-lvmetad.service lvm2-monitor.service lvm2-pvscan@.service time-sync.target ldconfig.service sys-fs-fuse-connections.mount"
SERVICESSTOP="dhcpd wine"
for a in $SERVICESMASK ;do
    [ -f lib/systemd/system/$a.service ] &&  ln -s '/dev/null' "etc/systemd/system/$a.service"
done
for a in $SERVICESSTOP ;do
    [ -f lib/systemd/system/$a.service ] &&  chroot . /bin/systemctl disable $a.service
done
exit 0
