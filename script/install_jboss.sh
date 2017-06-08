#!/bin/sh -eux

declare -a jboss_patch_installers
jboss_patch_installers[1]="jboss-eap-6.4.1.CP.zip"
jboss_patch_installers[2]="jboss-eap-6.4.2.CP.zip"
jboss_patch_installers[3]="jboss-eap-6.4.3.CP.zip"
jboss_patch_installers[4]="jboss-eap-6.4.4.CP.zip"

target_dir=$INSTALL_DIR/jboss
if [ ! -d $target_dir ]; then
  mkdir -p $target_dir
  chown -R $INSTALL_USER:$INSTALL_USER $target_dir
fi
sudo -u $INSTALL_USER unzip $SOFTWARE_DIR/linux/jboss/$JBOSS_INSTALLER -d $target_dir

#Install patches
for i in "${!jboss_patch_installers[@]}"
do
  patch_file_name=${jboss_patch_installers[$i]}
  patch_file=$SOFTWARE_DIR/linux/jboss/$patch_file_name
  if [ -f $patch_file ]; then
    sudo -u $INSTALL_USER $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply $patch_file"
  fi
done

#Set JBOSS_HOME
profile=$HOME_DIR/.bash_profile
jboss_home=$INSTALL_DIR/jboss/jboss-eap-$JBOSS_VERSION
echo "export JBOSS_HOME=$jboss_home" >> $profile