#!/usr/bin/env bash

sudo apt-get install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib

#CREATE ADMIN SUPER USER 
echo "CREATE ROLE vagrant SUPERUSER CREATEDB CREATEROLE LOGIN" | sudo -u postgres psql -a -f -

#CREATE AN APP USER
sudo useradd -g users -d /home/appuser -m -s /bin/bash -p $(echo appuser | openssl passwd -1 -stdin) appuser

#CREATE POSTGRES APP USER
echo "CREATE ROLE appuser LOGIN ENCRYPTED PASSWORD 'appuser'" | sudo -u postgres psql -a -f -
echo "CREATE DATABASE appdb OWNER appuser" | sudo -u postgres psql -a -f -

#Allow 172.28.128.0/24 (modify following your setup) to access postgres db with appuser
echo "listen_addresses = '*'" >> /etc/postgresql/11/main/postgresql.conf
echo 'host    all             appuser         172.28.128.0/24             md5' >> /etc/postgresql/11/main/pg_hba.conf

sudo systemctl restart postgresql