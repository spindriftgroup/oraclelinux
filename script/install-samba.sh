#!/bin/sh -eux

if [[ "$INSTALL_SAMBA" == *true* ]]; then
  #Install samba
  yum -y install samba

  # For Windows SMB install cifs-utils
  yum -y install cifs-utils
  
  #Set samba to start on boot
  sudo /sbin/chkconfig --level 345 smb on
    
  #Set password for vagrant
  (echo "vagrant";echo "vagrant") | sudo smbpasswd -a vagrant
  
  #Configure samba
  cp /tmp/smb.conf /etc/samba
  rm /tmp/smb.conf
fi
