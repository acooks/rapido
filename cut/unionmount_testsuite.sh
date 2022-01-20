#!/bin/bash
#
# Copyright (C) SUSE LLC 2021, all rights reserved.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) version 3.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# License for more details.

RAPIDO_DIR="$(realpath -e ${0%/*})/.."
. "${RAPIDO_DIR}/runtime.vars"

_rt_require_dracut_args "$RAPIDO_DIR/autorun/unionmount_testsuite.sh" "$@"
_rt_require_conf_dir UNIONMOUNT_TESTSUITE_SRC
_rt_cpu_resources_set "2"
_rt_mem_resources_set "1024M"

"$DRACUT" --install "tail blockdev ps rmdir resize dd vim grep find df sha256sum \
		   strace mkfs.xfs mkfs.btrfs python3" \
	--include "$UNIONMOUNT_TESTSUITE_SRC" "$UNIONMOUNT_TESTSUITE_SRC" \
	--include "/usr/lib64/python3.6/" "/usr/lib64/python3.6/" \
	--add-drivers "zram lzo lzo-rle btrfs raid6_pq overlay" \
	--modules "base" \
	"${DRACUT_RAPIDO_ARGS[@]}" \
	"$DRACUT_OUT" || _fail "dracut failed"
