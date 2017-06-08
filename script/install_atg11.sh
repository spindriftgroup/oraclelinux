#!/bin/sh -eux

silent_file=silent.properties

declare -A oc_bin_file_name
oc_bin_file_name[11.1]="OCPlatform11_1.bin"
oc_bin_file_name[11.2]="OCPlatform11_2.bin"
oc_bin_file_name[11.3]="OCPlatform11.3.bin"

oc_bin_file=${oc_bin_file_name[$ATG_VERSION]}

target_dir=$INSTALL_DIR/ATG/ATG${ATG_VERSION}

#Setup silent properties
echo "USER_INSTALL_DIR=$target_dir" > $silent_file
echo "CHOSEN_INSTALL_FEATURE_LIST=RM,Commerce,Portal,CA,MP,QF" >>$silent_file
if [ $APP_SERVER = "jboss" ]; then
  server_version=`find $INSTALL_DIR/jboss -type d -name "jboss-eap-*" | head -1 | cut -f4 -d '/'`
  echo "SELECTED_APP_SERVER=\"JBoss\",\"\",\"\",\"\"" >>$silent_file
  echo "ATG_JBOSS_HOME=$INSTALL_DIR/jboss/$server_version/jboss-as"  >>$silent_file
fi
echo "ATG_JDK_HOME=/usr/java/latest" >>$silent_file

#Display silent parameters
cat $silent_file

#Install platform base
if [ ! -d $target_dir ]; then
  mkdir -p $target_dir
  chown -R $INSTALL_USER:$INSTALL_USER $target_dir
fi
unzip $SOFTWARE_DIR/linux/atg/$ATG_VERSION/$OC_INSTALLER
chmod +x $oc_bin_file
sudo -u $INSTALL_USER ./$oc_bin_file -f $silent_file -i silent

#Clean up
rm $oc_bin_file
rm $silent_file

#Set ATG_HOME
profile=$HOME_DIR/.bash_profile
echo "export ATG_HOME=$target_dir" >> $profile
echo "export ATGJRE=\$JAVA_HOME/bin/java">> $profile
echo "export DYNAMO_HOME=\$ATG_HOME/home" >> $profile
echo "export PATH=\$PATH:\$ATG_HOME/home/bin" >> $profile
