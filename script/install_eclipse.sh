#!/bin/sh -eux

if [ "x$INSTALL_ECLIPSE" -eq "x" ]; then
  echo "Eclipse install option INSTALL_ECLIPSE not set."
  exit 0
fi
if [ "$INSTALL_ECLIPSE" -eq "false" ]; then
  echo "Eclipse install option INSTALL_ECLIPSE set to false - no installation required."
  exit 0
fi

declare -A eclipse_distro_files
eclipse_distro_files[neon-R]="eclipse-jee-neon-R-linux-gtk-x86_64.tar.gz"
eclipse_distro_files[neon-3]="eclipse-jee-neon-3-linux-gtk-x86_64.tar.gz"
eclipse_distro_files[oxygen-R]="eclipse-jee-oxygen-R-linux-gtk-x86_64.tar.gz"

declare -A eclipse_internal_version
eclipse_internal_version[neon-R]="4.6.0"
eclipse_internal_version[neon-3]="4.6.3"
eclipse_internal_version[oxygen-R]="4.7.0"

share_file_name=${eclipse_distro_files[$ECLIPSE_VERSION]}

profile_file=/home/$INSTALL_USER/.bash_profile

install_dir=$INSTALL_DIR/eclipse

local_share_file=$SOFTWARE_DIR/linux/eclipse/$share_file_name

eclipse_ini=$SOFTWARE_DIR/eclipse/eclipse.ini
eclipse_executable=/usr/bin/eclipse
eclipse_desktop=/usr/share/applications/eclipse.desktop

tar -xvzf $LOCAL_SHARE_FILE -C $INSTALL_DIR
sudo chmod -R +r $INSTALL_DIR/eclipse

touch $eclipse_executable
chmod 755 $eclipse_executable
 
cat >$eclipse_executable <<_EOF_
#!/bin/sh
export ECLIPSE_HOME="$INSTALL_DIR/eclipse"
\$ECLIPSE_HOME/eclipse \$*
_EOF_

# Create Gnome desktop launcher
cat >$eclipse_desktop <<_EOF_
[Desktop Entry]
Encoding=UTF-8
Name=Eclipse
Comment=Eclipse SDK ${eclipse_internal_version[$ECLIPSE_VERSION]}
Exec=eclipse
Icon=$INSTALL_DIR/eclipse/icon.xpm
Terminal=false
Type=Application
Categories=GNOME;Application;Development;
StartupNotify=true
_EOF_

sudo chown -R $INSTALL_USER:$INSTALL_USER $INSTALL_DIR/eclipse
