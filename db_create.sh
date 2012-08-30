#!/bin/bash
# eBuntu test script
# Copyright 2012 eBuntu
# Editer : ujuc
# 원본: http://docs.openstack.org/essex/openstack-compute/starter/content/Creating_Databases-d1e921.html#comment-562723657


for app in nova glance keystone quantum swift
do
mysql -uroot -proot00 -v -e "
CREATE DATABASE ${app};
CREATE USER ${app}db;
GRANT ALL PRIVILEGES ON ${app}.* TO '${app}db'@'%';
SET PASSWORD FOR '${app}db'@'%' = PASSWORD('${app}00');
";
done