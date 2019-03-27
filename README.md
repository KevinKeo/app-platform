# app-platform

Deployment of a tomcat server and postgresql server.

## Getting Started

Create a Postgresql server and Tomcat server.

Allow to focus on the development of MVP application and then just deploy a war on tomcat.

### Prerequisites

You need vagrant to use it and a Virtualbox.


### Installing

Once vagrant is installed.
In the git repository :
```
vagrant up
```
It will start an ubuntu 18.04 and an ubuntu 16.04.

* Ubuntu 18.04
  * openjdk-11-jre
  * tomcat v9.0.17

* Ubuntu 16.04
  * postgresql



The two VM will have their own IP in the private network. (Vagrantfile)
```
application|postgres.vm.network "private_network", type:"dhcp"
```


## PostgreSQL

The default user 'vagrant' has a role 'super user'. It allows to create role and database. And you can connect to any database with :

```
psql DB_NAME
```

* vagrant role don't require a password, his access to postgresql is only done by peer, therefore you should be inside the vm as vagrant and then use psql to do any super user action on postgres.

By default, an application database and an app account is created (unix user & postgres)
DB_NAME : appdb
username : appuser
password : appuser (feel free to change it)

To verify :
```
vagrant ssh postgres
su appuser
(asking password : appuser)
psql appdb
```
* appuser own the appdb, you can freely create table and drop them.
* currently the only account who allow access from 172.28.128.0/24 (see postgresql.sh), asking for role password (which is the same as the unix account)


To access appdb from an application :
```
vagrant ssh postgres
ifconfig
(get his IP)
Connect through IP:5432/appdb
Using appuser account 
username : appuser
password : appuser
```


## Tomcat

Tomcat should be already started (systemctl status tomcat) and accesible from your browser.

```
vagrant ssh application
ifconfig
(get his IP and try accessing IP:8080 from your browser.)
```

If you need access to server manager or host tab :
Add a tomcat user : 
```
  sudo su
  vi /opt/tomcat/conf/tomcat-users.xml
  <role rolename="admin-gui"/>
  <role rolename="manager-gui"/>
  <user username="user" password="password" roles="admin-gui,manager-gui"/>
```

Then you need to configure tomcat to allow access from your host ip, to simplify, we will allow access from every ip.
```
cd /opt/tomcat/webapps
vi manager/META-INF/context.xml
(replace 127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1 to ^.*$ )
vi host-manager/META-INF/context.xml
(replace 127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1 to ^.*$ )
```
Now just click on host manager and insert the user password


## Deploy an application

You need to deploy your WAR into /opt/tomcat/webapps
Either use scp, or drop your war into shared directory who is directly linked to the VM directory /tmp/vagrant
Then move the war to /opt/tomcat/webapps.
It will automatically start your webapplication.
To reach it : tomcatIP:8080/WAR_NAME/


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details
