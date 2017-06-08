#!/bin/sh -eux

#Create required swap file
#=========================

swap_size=2048

if [ ! -f /home/swapfile ]; then
  dd if=/dev/zero of=/home/swapfile bs=$swap_size count=1048576
  mkswap /home/swapfile
  swapon /home/swapfile
  swapon -a
  swapon -s
  echo '/home/swapfile swap swap defaults 0 0' >> /etc/fstab
fi

#Install XE
#===========

rpm_file=oracle-xe-11.2.0-1.0.x86_64.rpm
profile_file=$HOME_DIR/.bash_profile
xe_install_dir=/u01/app/oracle/product/11.2.0/xe
#Oracle environment for profile
oracle_env=/u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

# Oracle response file parameters
oracle_xe_http_port=8070
oracle_xe_db_port=1521
oracle_xe_sys_password=password
oracle_xe_start_on_startup=y

unzip $SOFTWARE_DIR/linux/oracle/$ORACLE_XE_INSTALLER

rpm -ivh Disk1/$rpm_file
  
#Create silent response file and execute configuration.
responsefile=oracle_xe.rsp
echo "$oracle_xe_http_port" > $responsefile
echo "$oracle_xe_db_port" >> $responsefile
echo "$oracle_xe_sys_password" >> $responsefile 
echo "$oracle_xe_sys_password" >> $responsefile
echo "$oracle_xe_start_on_startup" >> $responsefile
cat $responsefile
sudo /etc/init.d/oracle-xe configure < $responsefile
  
# Set the env vars for the profile
echo ". $oracle_env" >> $profile_file
  
# Clean up
rm $responsefile
rm -rf Disk1

source $oracle_env


#Incubating testing for increase processes to stop random data import failures
proc_limit=300
tmpsql=/var/tmp/increase_sessions.sql
echo "alter system set processes=$proc_limit scope=spfile;" >$tmpsql
echo "shutdown immediate" >>$tmpsql
echo "startup" >>$tmpsql
echo "exit" >>$tmpsql
sqlplus sys/password as sysdba @$tmpsql
rm $tmpsql


# Set CLI prompt and linesize
#============================
sqlplus_global_login_file=$xe_install_dir/sqlplus/admin/glogin.sql
linesize=10000

cat >>$sqlplus_global_login_file << _EOL_
--Sets the line length(size) to the width of the terminal or given size
HOST echo "set linesize $linesize trim on" > .tmp.sql
@.tmp.sql
HOST rm -f .tmp.sql
--To set SQL prompt to current user
set sqlprompt "&&_USER@&&_CONNECT_IDENTIFIER SQL>"
_EOL_

#change the line containing linesize
sudo sed -i "/set linesize/c\HOST echo \"set linesize $linesize\" > .tmp.sql" $sqlplus_global_login_file

# Set CLI history
#================
echo "alias sqlplus='rlwrap sqlplus'" >> $HOME_DIR/.bashrc
