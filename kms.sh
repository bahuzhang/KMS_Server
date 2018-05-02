#!/bin/bash
#URL: https://github.com/uselibrary/KMS_Server
#E-mail: mail@pa.ci
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #               Build KMS Server               #"
echo "    #                https://pa.ci                 #"
echo "    #                Version 0.4.1                  #"
echo "    ################################################"
#Prepare the installation environment
echo -e ""
echo -e "Prepare the installation environment."
if cat /etc/*-release | grep -Eqi "centos|red hat|redhat"; then
  echo "RPM-based"
  yum -y install git
elif cat /etc/*-release | grep -Eqi "debian|ubuntu|deepin"; then
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
if cat /etc/*-release | grep -Eqi "raspbian"; then
  mv KMS_Server/binaries/Linux/arm/little-endian/glibc/vlmcsd-armv6hf-Raspberry-glibc kms
else
  if [ "$arch" -eq 32 ]; then
    mv KMS_Server/binaries/Linux/intel/glibc/vlmcsd-x32-glibc kms
  else
    mv KMS_Server/binaries/Linux/intel/glibc/vlmcsd-x64-glibc kms
  fi
fi
mv kms /usr/bin/
chmod +x /usr/bin/kms
nohup kms > /home/kms.log 2>&1 &
echo -ne '\n@reboot root nohup kms > /home/kms.log 2>&1 &\n\n' >>/etc/crontab
#Cleaning Work
rm -rf KMS_Server
#Check kms server status
sleep 1
echo "Check KMS Server status..."
sleep 1
PIDS=`ps -ef |grep kms |grep -v grep | awk '{print $2}'`
if [ "$PIDS" != "" ]; then
  echo "kms server is runing!"
else
  echo "kms server is NOT running!"
fi
