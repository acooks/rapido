#!/bin/bash
# SPDX-License-Identifier: (LGPL-2.1 OR LGPL-3.0)
# Copyright (C) SUSE LLC 2022, all rights reserved.

RAPIDO_DIR="$(realpath -e ${0%/*})/.."
. "${RAPIDO_DIR}/runtime.vars"

_rt_require_dracut_args "$RAPIDO_DIR/autorun/net_test_tn40xx.sh" "$@"
_rt_require_networking
_rt_cpu_resources_set "2"
_rt_mem_resources_set "256M"

"$DRACUT" \
	--install "hostname lspci ip bridge ethtool iperf3 nc" \
	--add-drivers "tn40xx" \
	--modules "base" \
	"${DRACUT_RAPIDO_ARGS[@]}" \
	"$DRACUT_OUT" || _fail "dracut failed"
