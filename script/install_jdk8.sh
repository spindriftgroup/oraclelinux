#!/bin/sh -eux

version=${JDK_INSTALLER:4:1}
minor_version=${JDK_INSTALLER:6:3}
if [ ${JDK_INSTALLER:8:1} eq "-" ]; then
  minor_version=${JDK_INSTALLER:6:2}
fi

rpm -ivh --nodeps --force $SOFTWARE_DIR/linux/java/$JDK_INSTALLER

#Set alternatives
## java ##
alternatives --install /usr/bin/java java /usr/java/jdk1.${version}.0_${minor_version}/jre/bin/java 200000
## javaws ##
alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.${version}.0_${minor_version}/jre/bin/javaws 200000
## Install javac only if you installed JDK (Java Development Kit) package ##
alternatives --install /usr/bin/javac javac /usr/java/jdk1.${version}.0_${minor_version}/bin/javac 200000
alternatives --install /usr/bin/jar jar /usr/java/jdk1.${version}.0_${minor_version}/bin/jar 200000

# Configure profile
profile=$HOME_DIR/.bash_profile
echo "export JAVA_HOME=/usr/java/latest" >> $profile
echo "export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8" >> $profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> $profile
echo "export JAVA${version}_HOME=/usr/java/jdk1.${version}.0_${minor_version}" >> $profile