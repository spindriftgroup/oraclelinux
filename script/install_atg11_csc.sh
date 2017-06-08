#!/bin/sh -eux

silent_file=silent.properties

declare -A oc_bin_file_name
oc_bin_file_name[11.1]="OCServiceCenter11.1.bin"
oc_bin_file_name[11.2]="OCServiceCenter11.2_224RCN.bin"
oc_bin_file_name[11.3]="OCServiceCenter11.3.bin"

oc_bin_file=${oc_bin_file_name[$ATG_VERSION]}

target_dir=$INSTALL_DIR/ATG/ATG${ATG_VERSION}

#Setup silent properties
echo "USER_INSTALL_DIR=$target_dir" > $silent_file

#Display silent parameters
cat $silent_file

#Install software
unzip $SOFTWARE_DIR/linux/atg/$ATG_VERSION/$OC_CSC_INSTALLER
chmod +x $oc_bin_file
sudo -u $INSTALL_USER ./$oc_bin_file -f $silent_file -i silent

#Clean up
rm $oc_bin_file
rm $silent_file
