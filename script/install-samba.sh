#!/bin/sh -eux

if [[ "$INSTALL_SAMBA" == *true* ]]; then
  #Install samba
  yum -y install samba

  # For Windows SMB install cifs-utils
  yum -y install cifs-utils
fi
