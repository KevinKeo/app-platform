# app-platform

Deployment of a tomcat server and postgresql server.

Allow to focus on the development of MVP application and then just deploy a war on tomcat.


## Getting Started

Start the servers, then add your war into tomcat-war dir, it will move it into the tomcat server and start it automatically at 172.28.128.10:8080/WAR_NAME/

## Prerequisites

You need vagrant and Virtualbox.

# Installing

Once vagrant is installed.
In the git repository :
```
vagrant up
```
It will start an ubuntu 18.04 and an ubuntu 16.04.

* Ubuntu 18.04 (172.28.128.10:8080)
  * openjdk-11-jre
  * tomcat v9.0.17

* Ubuntu 16.04 (172.28.128.20:5432)
  * postgresql


## PostgreSQL

The default user 'vagrant' has a role with 'superuser' rights. It allows to create role and database. And you can connect to any database with :

```
psql DB_NAME
```

* vagrant role don't require a password, his access to postgresql is only done by peer, therefore you should be inside the vm as vagrant and then use psql to do any superuser action on postgres.

By default, an application database and an app account are created (unix user & postgres)
* DB_NAME : appdb
* username : appuser
* password : appuser (feel free to change it)
* role : appuser
* password_role : appuser

To verify :
```
vagrant ssh postgres
su appuser
(asking password : appuser)
psql appdb
```
* appuser own the appdb, you can freely create table and drop them.
* Currently appuser is the only account who is allowed to access postgresql server from 172.28.128.0/24 (Host running vagrant is 127.28.128.1 and tomcat is 127.28.128.10), and asking for role password.
* To only allow access from tomcat server, modify 172.28.128.0/24 by 172.28.128.10/32


To access appdb from an application on tomcat server :
```
Connect through IP:5432/appdb
Using role appuser account 
roleuser : appuser
rolepwd  : appuser
```


## Tomcat

Tomcat should be already started (systemctl status tomcat) and accesible from your browser. (172.28.128.10:8080)

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
(replace 127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1 by ^.*$ )

vi host-manager/META-INF/context.xml
(replace 127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1 by ^.*$ )
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
