#!/bin/bash
# eBuntu test script
# Copyright 2012 eBuntu
# Editer : ujuc
# origin: http://docs.openstack.org/essex/openstack-compute/starter/content/Creating_Databases-d1e921.html#comment-562723657


for app in nova glance keystone quantum swift cinder
do
sudo mysql -uroot -proot00 -v -e "
CREATE DATABASE ${app};
CREATE USER ${app}db;
GRANT ALL PRIVILEGES ON ${app}.* TO '${app}db'@'localhost';
SET PASSWORD FOR '${app}db'@'localhost' = PASSWORD('${app}00');
";
done
