Rapido can be used to test network device drivers.

Here is an example where real device is 'passed through' from the host to a VM, so that the test suite for the driver under test can run in a VM.

Rather than defining the variables in rapido.conf, the test suite configuration is contained in a test script and passed to the test suite by rapido at run-time. This enables multiple test VMs to run concurrently.

Here is an example script with the test configuration variables:

	#!/usr/bin/bash

	if [[ $(id -u) -ne 0 ]]; then
			echo "Run this script as root"
			exit 1
	fi

	export NET_TEST_KMOD="tn40xx"
	export NET_TEST_SUITE="/home/me/net-test"
	export NET_TEST_IP_ADDR="192.168.123.4/24"
	export NET_TEST_DEV_HOST="0a:00.0"
	NET_TEST_DEV_VM="0000:00:03.0"

	START_CMD="/driver-tests/start.sh ${NET_TEST_DEV_VM} ${NET_TEST_KMOD} ${NET_TEST_IP_ADDR}"

	./rapido cut -x "$START_CMD" net-test


The host's network device is contained in `NET_TEST_DEV_HOST` and passed to qemu in the `QEMU_EXTRA_ARGS` variable.

    #
    # Path to Linux kernel source. Prior to running "rapido cut", the kernel
    # should be built, with modules installed (see KERNEL_INSTALL_MOD_PATH below).
    # e.g. KERNEL_SRC="/home/me/linux"
    #KERNEL_SRC=""

    # Path to compiled kernel modules.
    # If left blank, Dracut will use its default (e.g. /lib/modules) search path.
    # A value of "${KERNEL_SRC}/mods" makes sense when used alongside
    # "INSTALL_MOD_PATH=./mods make modules_install" during kernel compilation.
    # e.g. KERNEL_INSTALL_MOD_PATH="${KERNEL_SRC}/mods"
    #KERNEL_INSTALL_MOD_PATH=""

    # The name of the kernel module under test.
    # Passed to the VM as a kernel parameter for use in the test suite.
    # e.g. NET_TEST_KMOD="ixgbe"
    #NET_TEST_KMOD=""

    # The location of the test suite to add into the VM.
    # e.g. NET_TEST_SUITE="/home/me/net-test"
    #NET_TEST_SUITE=""

    # The IPv4 address to assign to the interface for the driver under test.
    # e.g. NET_TEST_IP_ADDR="192.168.123.123/24"
    #NET_TEST_IP_ADDR=""

    # The host PCI address of the network peripheral for the driver under test.
    # This device must use the vfio-pci stub driver in the host, to be passed to
    # the VM.
    # e.g. NET_TEST_DEV_HOST="07:00.0"
    #NET_TEST_DEV_HOST=""

    # The PCI address of the peripheral in the VM.
    # Passed to the VM as a kernel parameter and used in the test suite to identify
    # the peripheral for the driver under test.
    # e.g. NET_TEST_DEV_VM="0000:00:03.0"
    #NET_TEST_DEV_VM=""

    # Enable IOMMU and pass the PCIe network peripheral into the VM.
    # e.g.
    # QEMU_EXTRA_ARGS="\
    #  -M q35,accel=kvm,kernel-irqchip=split \
    #  -cpu host \
    #  -nographic\
    #  -device intel-iommu,intremap=on,caching-mode=on,device-iotlb=on \
    #  -device virtio-rng-pci \
    #  -device vfio-pci,host=$NET_TEST_DEV_HOST \
    # "
    #QEMU_EXTRA_ARGS=""

