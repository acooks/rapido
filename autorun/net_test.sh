#!/bin/bash
# SPDX-License-Identifier: (LGPL-2.1 OR LGPL-3.0)

# This rapido test is for running a network device driver test suite.
#
# The test script and configuration is defined outside of rapido.
# Refer to:
# [the rapido guide](docs/network_device_driver_guide.md) and
# [test suite](https://github.com/acooks/net-driver-test)

_vm_ar_env_check || exit 1
_vm_ar_dyn_debug_enable

ip link set lo up
