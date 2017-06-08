#!/bin/sh -eux

declare -A oc_patch_file_name
oc_patch_file_name[p19145440_110000_Generic.zip]="OCPlatform11.0_p1"
oc_patch_file_name[p19145462_110000_Generic.zip]="Service11.0_p1"

oc_patch_file_name[p20173321_111000_Generic.zip]="OCPlatform11.1_p1"
oc_patch_file_name[p20173342_111000_Generic.zip]="Service11.1_p1"

oc_patch_file_name[p23147552_112000_Generic.zip]="OCPlatform11.2_p1"
oc_patch_file_name[p23147539_112000_Generic.zip]="Service11.2_p1"
oc_patch_file_name[p24950065_112000_Generic.zip]="OCPlatform11.2_p2"
oc_patch_file_name[p24950079_112000_Generic.zip]="Service11.2_p2"
oc_patch_file_name[p25404313_112020_Generic.zip]="OCPlatform11.2_p2.1"

oc_patch_dir=$INSTALL_DIR/ATG/ATG${ATG_VERSION}/patch
patch_file_name=$OC_PATCH

patch_file_dir=${oc_patch_file_name[$patch_file_name]}
patch_file=$SOFTWARE_DIR/linux/atg/$ATG_VERSION/$patch_file_name
if [ -f $patch_file ]; then
  sudo -u $INSTALL_USER unzip $patch_file -d $oc_patch_dir
  cd $oc_patch_dir/$patch_file_dir
  chmod +x bin/*.sh
  yes 'y' | sudo -u $INSTALL_USER ./bin/install.sh
fi
