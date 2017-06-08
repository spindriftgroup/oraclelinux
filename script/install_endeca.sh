#!/bin/sh -eux

endeca_version=${ATG_VERSION}.0
endeca_mdex_version=${ATG_VERSION}.0
if [ "$ATG_VERSION" = "11.2" ]; then
  endeca_mdex_version=6.5.2
fi
profile=$HOME_DIR/.bash_profile

#Create Endeca apps dir
#======================
endeca_apps_dir=$INSTALL_DIR/endeca_apps
mkdir -p $endeca_apps_dir

#Install MDEX
#============
declare -A endeca_mdex_installer_file
endeca_mdex_installer_file[6.5.2]="OCmdex6.5.2-Linux64_962107.bin"
endeca_mdex_installer_file[11.3.0]="OCmdex11.3.0-Linux64_1186050.bin"

unzip $SOFTWARE_DIR/linux/endeca/MDEX/$MDEX_INSTALLER
endeca_installer=${endeca_mdex_installer_file[$endeca_mdex_version]}
chmod +x $endeca_installer

silent_file=mdex.rsp
cat >$silent_file <<EOF
USER_INSTALL_DIR=$INSTALL_DIR
EOF

cat $silent_file

sudo -u $INSTALL_USER ./$endeca_installer -i silent -f $silent_file
rm $endeca_installer
rm $silent_file
pres_file=OCpresAPI6.5.2-Linux64_962107.tgz
if [ -f $pres_file ]; then
  rm $pres_file
fi

#Configure the profile
endeca_env_source=$INSTALL_DIR/endeca/MDEX/$endeca_mdex_version/mdex_setup_sh.ini
echo "source $endeca_env_source" >> $profile

#Install Platform Services
#=========================
declare -A endeca_ps_installer_file
endeca_ps_installer_file[11.2.0]="OCplatformservices11.2.0-Linux64.bin"
endeca_ps_installer_file[11.3.0]="OCplatformservices11.3.0-Linux64.bin"

unzip $SOFTWARE_DIR/linux/endeca/PlatformServices/$PS_INSTALLER
endeca_installer=${endeca_ps_installer_file[$endeca_version]}
chmod +x $endeca_installer

# Silent install response file parameters
silent_file=ps.rsp
rf_http_port=8888
rf_shutdown_port=8090
rf_mdex_root=$INSTALL_DIR/endeca/MDEX/$endeca_mdex_version

cat >$silent_file <<EOF
USER_INSTALL_DIR=$INSTALL_DIR
ETOOLS_HTTP_PORT=$rf_http_port
ETOOLS_SERVER_PORT=$rf_shutdown_port
EAC_MDEX_ROOT=$rf_mdex_root
EOF

cat $silent_file

sudo -u $INSTALL_USER ./$endeca_installer -i silent -f $silent_file
rm $endeca_installer
rm $silent_file

#Configure the profile
endeca_workspace=$INSTALL_DIR/endeca/PlatformServices/workspace
endeca_env_source=$endeca_workspace/setup/installer_sh.ini
echo "source $endeca_env_source" >> $profile

#Install Tools and Frameworks
#============================
declare -A endeca_taf_zip_files
endeca_taf_zip_files[11.2.0]="V78208-01-Oracle-Commerce-TAF-11.2-Linux.zip"
endeca_taf_zip_files[11.3.0]="V861215-01-Oracle-Commerce-TAF-11.3.0-Linux.zip"

declare -A endeca_taf_version
endeca_taf_version[11.2.0]="11.2.0.0.0"
endeca_taf_version[11.3.0]="11.3.0.0.0"

unzip $SOFTWARE_DIR/linux/endeca/ToolsAndFrameworks/$TAF_INSTALLER
cd cd/Disk1/install

chmod +x silent_install.sh

response_file=silent.rsp
cat > $response_file << _EOF_
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME="$INSTALL_USER"
ACCEPT_LICENSE_AGREEMENT=true
SELECTED_LANGUAGES={"en"}
COMPONENT_LANGUAGES={"en"}
INSTALL_TYPE="Complete Installation"
TOPLEVEL_COMPONENT={"oracle.endeca.guidedsearch","${endeca_taf_version[$endeca_version]}"}
CLUSTER_NODES={}
FROM_LOCATION="../stage/products.xml"
_EOF_

oracle_home_name=ToolsAndFrameworks
oracle_home_location=$INSTALL_DIR/endeca/$oracle_home_name

sudo -u $INSTALL_USER ./silent_install.sh $PWD/$response_file $oracle_home_name $oracle_home_location
cd $HOME_DIR
rm -rf cd

#Configure the profile
taf_install_dir=$oracle_home_location/$endeca_version
echo "export ENDECA_TOOLS_ROOT=$taf_install_dir" >> $profile
echo "export ENDECA_TOOLS_CONF=$taf_install_dir/server/workspace" >> $profile


#Install CAS
#===========
declare -A endeca_cas_installer_file
endeca_cas_installer_file[11.2.0]="OCcas11.2.0-Linux64.bin"
endeca_cas_installer_file[11.3.0]="OCcas11.3.0-Linux64.bin"

unzip $SOFTWARE_DIR/linux/endeca/CAS/$CAS_INSTALLER
endeca_installer=${endeca_cas_installer_file[$endeca_version]}
chmod +x $endeca_installer

#Setup response file silent properties
http_port=8500
shutdown_port=8506
endeca_tools_root=$INSTALL_DIR/endeca/ToolsAndFrameworks/$endeca_version
endeca_tools_conf=$endeca_tools_root/server/workspace

response_file=silent.rsp
cat >$response_file <<EOF
USER_INSTALL_DIR=$INSTALL_DIR
CHOSEN_FEATURE_LIST=CAS,Console,DT
CHOSEN_INSTALL_FEATURE_LIST=CAS,Console,DT
CHOSEN_INSTALL_SET=Custom
CASPORT=$http_port
CASSTOPPORT=$shutdown_port
ENDECA_TOOLS_ROOT=$endeca_tools_root
ENDECA_TOOLS_CONF=$endeca_tools_conf
EOF

sudo -u $INSTALL_USER ./$endeca_installer -i silent -f $response_file
rm $response_file
rm $endeca_installer

#Configure the profile
echo "export CAS_ROOT=$INSTALL_DIR/endeca/CAS/$endeca_version" >> $profile