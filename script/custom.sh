#!/bin/sh -eux

# Add yum repos for oracle-xe
yum -y install unzip libaio bc initscripts net-tools openssl
yum -y install wget

# Add configuration for rlwrap
EPEL_RPM=epel-release-6-8.noarch.rpm
wget http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/$EPEL_RPM
rpm -Uvh $EPEL_RPM
yum -y install rlwrap
rm $EPEL_RPM

#Install AWS CLI tools as a bootstrap to download the Vagrant provisioning scripts from AWS
AWS_CLI_BUNDLE=awscli-bundle
AWS_CLI_BUNDLE_FILE=$AWS_CLI_BUNDLE.zip
curl -O https://s3.amazonaws.com/aws-cli/$AWS_CLI_BUNDLE_FILE
unzip $AWS_CLI_BUNDLE_FILE
./$AWS_CLI_BUNDLE/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf $AWS_CLI_BUNDLE
rm $AWS_CLI_BUNDLE_FILE

# Install Apache 
yum -y install httpd

# Install Page speed
ps_repo=/etc/yum.repos.d/mod-pagespeed.repo
if [ ! -f $ps_repo ]; then
  touch /etc/yum.repos.d/mod-pagespeed.repo
  echo "[mod-pagespeed]" > $ps_repo
  echo "name=mod-pagespeed" >> $ps_repo
  echo "baseurl=http://dl.google.com/linux/mod-pagespeed/rpm/stable/x86_64" >> $ps_repo
  echo "enabled=1" >> $ps_repo
  echo "gpgcheck=0" >> $ps_repo
fi
yum -y --enablerepo=mod-pagespeed install mod-pagespeed

#Un-install PackageKit as it frequently creates a yum lock
yum -y remove PackageKit

