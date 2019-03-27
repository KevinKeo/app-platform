#!/usr/bin/env bash

sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y openjdk-11-jre

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /etc && curl -O http://miroir.univ-lorraine.fr/apache/tomcat/tomcat-9/v9.0.17/bin/apache-tomcat-9.0.17.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat && chmod -R g+r conf && chmod g+x conf &&  chown -R tomcat webapps/ work/ temp/ logs/
sudo cp /tmp/vagrant/tomcat.service /etc/systemd/system/ && systemctl daemon-reload && systemctl start tomcat

echo y | sudo ufw enable
sudo ufw allow 8080
sudo ufw allow 22