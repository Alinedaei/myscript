#!/bin/bash
sudo apt update
sudo apt-get install wget apt-transport-https -y
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
echo "deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang-22.x" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get install rabbitmq-server -y --fix-missing
sudo rabbitmqctl add_user admin R@bbitmQ12
sudo rabbitmqctl set_user_tags admin administrator3

echo "user:admin,passwd:R@bbitmQ123"
sudo systemctl status rabbitmq-server
systemctl is-enabled rabbitmq-server.service
sudo systemctl enable rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management
 sudo ss -tunelp | grep 15672
 sudo ufw allow proto tcp from any to any port 5672,15672
 hostname -I
 echo"http://yourip:15672"
 
