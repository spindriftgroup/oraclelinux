#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing VMware Tools"
    cat /etc/redhat-release
    if grep -q -i "release 6" /etc/redhat-release ; then
        # Uninstall fuse to fake out the vmware install so it won't try to
        # enable the VMware blocking filesystem
        yum erase -y fuse
    fi
    # Assume that we've installed all the prerequisites:
    # kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
    # from the install media via ks.cfg

    # On RHEL 5, add /sbin to PATH because vagrant does a probe for
    # vmhgfs with lsmod sans PATH
    if grep -q -i "release 5" /etc/redhat-release ; then
        echo "export PATH=$PATH:/usr/sbin:/sbin" >> /home/vagrant/.bashrc
    fi

    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /home/vagrant/linux.iso /mnt/cdrom

    VMWARE_TOOLS_PATH=$(ls /mnt/cdrom/VMwareTools-*.tar.gz)
    VMWARE_TOOLS_VERSION=$(echo "${VMWARE_TOOLS_PATH}" | cut -f2 -d'-')
    VMWARE_TOOLS_BUILD=$(echo "${VMWARE_TOOLS_PATH}" | cut -f3 -d'-')
    VMWARE_TOOLS_BUILD=$(basename ${VMWARE_TOOLS_BUILD} .tar.gz)
    VMWARE_TOOLS_MAJOR_VERSION=$(echo ${VMWARE_TOOLS_VERSION} | cut -d '.' -f 1)
    echo "==> VMware Tools Path: ${VMWARE_TOOLS_PATH}"
    echo "==> VMware Tools Version: ${VMWARE_TOOLS_VERSION}"
    echo "==> VMware Tools Build: ${VMWARE_TOOLS_BUILD}"

    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
    if [ "${VMWARE_TOOLS_MAJOR_VERSION}" -lt "10" ]; then
        /tmp/vmware-tools-distrib/vmware-install.pl -d
    else
        /tmp/vmware-tools-distrib/vmware-install.pl --force-install
    fi
    rm /home/vagrant/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom
    rm -rf /tmp/VMwareTools-*

    echo "==> Removing packages needed for building guest tools"
    yum -y remove gcc cpp kernel-devel kernel-headers perl
fi
