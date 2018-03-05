#!/bin/bash
#URL: https://github.com/uselibrary/KMS_Server
#E-mail: emkqson@gmail.com
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #               Build KMS Server               #"
echo "    #                https://pa.ci                 #"
echo "    #                 Version 0.3                  #"
echo "    ################################################"
#Prepare the installation environment
echo -e ""
echo -e "Prepare the installation environment."
if cat /etc/*-release | grep -Eqi "centos|red hat|redhat"; then
  echo "RPM-based"
  yum -y install git
elif cat /etc/*-release | grep -Eqi "debian|ubuntu"; then
  echo "Debian-based"
  apt-get -y install git
else
  echo "This release is not supported."
  exit
fi
#Check instruction
if getconf LONG_BIT | grep -Eqi "64"; then
  arch=64
else
  arch=32
fi
#Build KMS Server
git clone https://github.com/uselibrary/KMS_Server
mv KMS_Server vlmcsd
mv vlmcsd /usr/local/
mkdir /usr/local/KMS/
ln -sv /usr/local/vlmcsd/ /usr/local/KMS/
if cat /etc/*-release | grep -Eqi "raspbian"; then
  echo "export PATH=/usr/local/KMS/vlmcsd/binaries/Linux/arm/little-endian/glibc:\$PATH" > /etc/profile.d/vlmcs.sh
  source /etc/profile.d/vlmcs.sh
  chmod +x /usr/local/KMS/vlmcsd/binaries/Linux/arm/little-endian/glibc/*
  echo "nohup vlmcsd-armv6hf-Raspberry-glibc &" >> /etc/rc.local
  nohup vlmcsd-armv6hf-Raspberry-glibc &
else
  echo "export PATH=/usr/local/KMS/vlmcsd/binaries/Linux/intel/static:\$PATH" > /etc/profile.d/vlmcs.sh
  source /etc/profile.d/vlmcs.sh
  chmod +x /usr/local/KMS/vlmcsd/binaries/Linux/intel/static/*
  if [ "$arch" -eq 32 ]; then
    echo "nohup vlmcsd-x86-musl-static &" >> /etc/rc.local
    nohup vlmcsd-x86-musl-static &
  else
    echo "nohup vlmcsd-x64-musl-static &" >> /etc/rc.local
    nohup vlmcsd-x64-musl-static &
  fi
fi
#Check vlmcsd status
sleep 1
echo "Check vlmcsd status..."
sleep 1
PIDS=`ps -ef |grep vlmcsd |grep -v grep | awk '{print $2}'`
if [ "$PIDS" != "" ]; then
  echo "vlmcsd is runing!"
else
  echo "vlmcsd is NOT running!"
fi
