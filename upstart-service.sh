#!/bin/bash
sudo yum install mailx -y
sudo apt-get install mailutils -y
mkdir /usr/local/serviceup
cd /usr/local/serviceup 
touch upstart-service.sh
sudo tee upstart-service.sh<<EOF
 #!/bin/bash
 #service monitoring
 /bin/netstat -tulpn | awk '{print $4}' | awk -F: '{print $4}' | grep ^80$ > /dev/null   2>/dev/null
 a=$(echo $?)
 if test $a -ne 0
 then
 echo "nginx service down" | mail -s "nginx Service DOWN and restarted now" root@localhost
 /etc/init.d/nginx start > /dev/null 2>/dev/null
 else
 sleep 0
 fi
 /bin/netstat -tulpn | awk '{print $4}' | awk -F: '{print $4}' | grep ^53$ > /dev/null   2>/dev/null
 b=$(echo $?)
 if test $b -ne 0
 then
 echo "elasticsearch service down" | mail -s "elasticsearch Service DOWN and restarted now" root@localhost
 /etc/init.d/elasticsearch start > /dev/null 2>/dev/null
 else
 sleep 0
 fi
EOF

 sudo tee /etc/crontab<<EOF
 */5 * * * * /usr/local/serviceup/upstart-service.sh > /dev/null 2>/dev/null
EOF