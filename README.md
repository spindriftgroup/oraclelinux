# Packer templates for Oracle Linux

### Overview

This repository contains templates for Oracle Linux that can create
Vagrant boxes using Packer.

## Original README
See the full and original [README at source](https://github.com/boxcutter/oraclelinux/blob/master/README.md)

## Current Boxes as per official Oracle Commerce supported environments

For ATG 11.3:

* Oracle Linux 7.2 (64-bit)
* Oracle Linux 7.2 Desktop (64-bit)

For ATG 11.2
* Oracle Linux 6.7 (64-bit)
* Oracle Linux 6.7 Desktop (64-bit)

## Building the Vagrant boxes with Packer

To build all the boxes, you will need [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed.

We make use of JSON files containing user variables to build specific versions of Ubuntu.
You tell `packer` to use a specific user variable file via the `-var-file=` command line
option.  This will override the default options on the core `oraclelinux-base.json` and `oraclelinux-full.json` packer template,
which builds Oracle Linux 6.7 by default.

For example, to build Oracle Linux 7.2 headless basic, use the following:

    $ packer build -var-file=ol72.json oraclelinux-base.json

If you want to make boxes with a desktop and full installation use the desktop var file with the full installation json file.
For example, to build Oracle Linux 6.7 for VirtualBox with desktop and fully installed phase 1 environment:

    $ packer build -var-file=ol67-desktop.json oraclelinux-full.json


Supported builds currently are:

    $ packer build -var-file=ol67.json oraclelinux-base.json
    $ packer build -var-file=ol67.json oraclelinux-full.json
    $ packer build -var-file=ol67-desktop.json oraclelinux-base.json
    $ packer build -var-file=ol67-desktop.json oraclelinux-full.json

The custom, reduced templates only support the following hypervisors:

* `virtualbox-iso` - [VirtualBox](https://www.virtualbox.org/wiki/Downloads) desktop virtualization


### Build Variables

The variable `HEADLESS` can be set to run Packer in headless mode.
Set `HEADLESS := true`, the default is false.

The variable `UPDATE` can be used to perform OS patch management.  The
default is to not apply OS updates by default.  When `UPDATE := true`,
the latest OS updates will be applied.

The variable `PACKER` can be used to set the path to the packer binary.
The default is `packer`.

The variable `ISO_PATH` can be used to set the path to a directory with
OS install images.  This override is commonly used to speed up Packer
builds by pointing at pre-downloaded ISOs instead of using the default
download Internet URLs.
These customisations have only been tested against pre-downloaded ISOs
and use the `iso_name` and `iso_path` user variables.

The variables `SSH_USERNAME` and `SSH_PASSWORD` can be used to change
the default name & password from the default `vagrant`/`vagrant`
respectively.
Please do not change these under any circumstances for developer circulation.

The variable `INSTALL_VAGRANT_KEY` can be set to turn off installation
of the default insecure vagrant key when the image is being used
outside of vagrant.  Set `INSTALL_VAGRANT_KEY := false`, the default
is true.
Please leave this as per the default value.

For full installations all the software installers must be downloaded and
available in your local software cache. These are copied into the VM, installed
and removed from the VM. They are not removed from your local cache.

### Local Vagrant installation

If you are developing, building and testing these, once built the box is in the box/virtualbox directory.
You can then add the basebox to vagrant (use --force if the box already exists):

    $ vagrant box add ~/path/to/project/oraclelinux/box/virtualbox/ol67-1.0.0.box --name=ol67-1.0.0 --force

### Acknowledgments

[boxcutter project](https://github.com/boxcutter/oraclelinux) for providing basebox configurations from which this project is forked.

