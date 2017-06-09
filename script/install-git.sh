#!/bin/sh -eux

default_git_version=2.9.4

git_version=$GIT_VERSION
if [ "x$GIT_VERSION" -eq "x" ];then
  git_version=default_git_version
fi

echo "Installing Git $git_version..."

yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel -y
yum install gcc perl-ExtUtils-MakeMaker -y
yum remove git -y

cd /usr/src
wget https://www.kernel.org/pub/software/scm/git/git-$git_version.tar.gz
tar xzf git-$git_version.tar.gz

cd git-$git_version
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc

