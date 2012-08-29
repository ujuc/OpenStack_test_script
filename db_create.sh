#!/bin/bash

for app in nova glance keystone quantum
do
mysql -uroot -proot00 -v -e "
CREATE DATABASE ${app};
CREATE USER ${app}db;
GRANT ALL PRIVILEGES ON ${app}.* TO '${app}db'@'%';
SET PASSWORD FOR '${app}db'@'%' = PASSWORD('${app}00');
";
done
