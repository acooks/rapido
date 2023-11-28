#!/bin/bash
# SPDX-License-Identifier: (LGPL-2.1 OR LGPL-3.0)
# Copyright (C) SUSE LLC 2022, all rights reserved.

_vm_ar_env_check || exit 1
_vm_ar_dyn_debug_enable

now() {
	declare -a _uptime
	readarray -d " " -t _uptime < /proc/uptime
	printf "[%12s][USPACE] " "${_uptime[0]}0000"
}

now; echo "Starting udevd"

/usr/lib/systemd/systemd-udevd &

now; echo "Loading Driver"
modprobe tn40xx || _fatal "Failed to load tn40xx module"

now; echo "Waiting for dynamic IP addresses..."
READY=$(ip -oneline -4 addr show dev eth1 scope global)

while [ -z "$READY" ] ; do
	sleep 1
	READY=$(ip -oneline -4 addr show dev eth1 scope global)	
done

now; echo "Starting iperf3"
iperf3 -c 10.1.4.153

now; echo "You can now do manual testing..."

