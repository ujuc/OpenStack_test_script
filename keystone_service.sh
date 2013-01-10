# Sevices
keystone service-create --name nova --type compute --description "OpenStack Compute Service"
keystone service-create --name cinder --type volume --description "OpenStack Volume Service"
keystone service-create --name glance --type image --description "OpenStack Image Service"
keystone service-create --name swift --type object-store --description "OpenStack Storage Service"
keystone service-create --name keystone --type identity --description "OpenStack Identity Service"
keystone service-create --name ec2 --type ec2 --description "EC2 Service"
keystone service-create --name quantum --type network --description "OpenStack Network Service"

echo "service list"
keystone service-list