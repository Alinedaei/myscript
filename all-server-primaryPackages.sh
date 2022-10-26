####
adduser infraadmin
usermod -aG sudo/wheel  infraadmin
passwd infraadmin 

adduser devadmin
usermod -aG sudo/wheel devadmin
passwd devadmin 

adduser  softadmin
usermod -aG sudo/wheel softadmin
passwd softadmin 


####
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf



####
cat /etc/sysconfig/network-scripts/ifcfg-ens160
echo "DNS1=172.20.21.5" >> /etc/sysconfig/network-scripts/ifcfg-ens160
echo "DNS2=172.20.21.7" >> /etc/sysconfig/network-scripts/ifcfg-ens160
echo "DOMAIN=gbgnetwork.net" >> /etc/sysconfig/network-scripts/ifcfg-ens160
ifdown/ifup ens160 
/etc/init.d/network restart 

####
yum update -y 
init 6
yum -y install epel-release
yum -y install ntp htop telnet wget vim net-tools vm-tools zip unzip bzip bzip2 gzip net-snmp net-snmp-utils  open-vm-tools ntpdate ntp-doc 

apt-get install  install  ntp htop telnet wget vim net-tools  zip unzip gzip snmp  snmpd open-vm-tools ntpdate ntp-doc

cp /etc/snmp/snmpd.conf  /etc/snmp/snmpd.conf.orig
> /etc/snmp/snmpd.conf
sudo tee /etc/snmp/snmpd.conf<<EOF
com2sec local localhost gol444mon
com2sec localnet 172.30.41.39 gol444mon
com2sec localnet solarmain.gbgnetwork.net gol444mon
com2sec localnet 172.30.32.170 gol444mon
com2sec localnet solarwinds.gbgnetwork.net gol444mon
group MyROGroup v2c local
group MyROGroup v2c localnet
view all included .1
access MyROGroup "" any noauth exact all none none  
EOF
systemctl restart snmpd
systemctl enable snmpd


cp /etc/ntp.conf /etc/ntp.conf.orig
> /etc/ntp.conf
sudo tee  /etc/ntp.conf<<EOF
server ntp1.gbgnetwork.net
server ntp2.gbgnetwork.net
server 172.20.33.1
server 172.20.33.2
EOF
systemctl restart ntpd
systemctl enable ntpd



timedatectl
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tehran /etc/localtime
date