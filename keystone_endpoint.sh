#!/bin/sh
#
# Keystone Endpoints
#
# Desciption: Create Service Endpoints

# Mainly inspired by http://www.hastexo.com/resources/docs/installing-openstack-essex-20121-ubuntu-1204-precise-pangolin
# Written by Martin Gerhard Loschwitz / Hastexo
# Modified by Emilien Macchi /StackOps
# Edited by SungJin Gang / eBuntu
#
# Support: openstack@lists.launchpad.net
# License: Apache Software License (ASL) 2.0

# Host IP
HOST_IP=
#SWIFT_HOST_IP=

# MySQL definitions
MYSQL_USER=keystonedb
MYSQL_DATABASE=keystone
MYSQL_HOST=localhost
MYSQL_PASSWORD=keystone00

# Keystone definitions
KEYSTONE_REGION=RegionOne

# other definitions
MASTER="$HOST_IP"
#SWIFT_MASTER="$SWIFT_HOST_IP"

# Sevices
keystone service-create --name nova --type compute --description "OpenStack Compute Service"
keystone service-create --name cinder --type volume --description "OpenStack Volume Service"
keystone service-create --name glance --type image --description "OpenStack Image Service"
keystone service-create --name swift --type object-store --description "OpenStack Storage Service"
keystone service-create --name keystone --type identity --description "OpenStack Identity Service"
keystone service-create --name ec2 --type ec2 --description "EC2 Service"
keystone service-create --name quantum --type network --description "OpenStack Network Service"

create_endpoint () {
	case $1 in
		compute)
		keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':8774/v2/$(tenant_id)s' --adminurl 'http://'"$MASTER"':8774/v2/$(tenant_id)s' --internalurl 'http://'"$MASTER"':8774/v2/$(tenant_id)s'
		;;
		volume)
		keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':8776/v1/$(tenant_id)s' --adminurl 'http://'"$MASTER"':8776/v1/$(tenant_id)s' --internalurl 'http://'"$MASTER"':8776/v1/$(tenant_id)s'
		;;
		image)
		keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':9292/v2' --adminurl 'http://'"$MASTER"':9292/v2' --internalurl'http://'"$MASTER"':9292/v2'
		;;
		object-store)
		if [ $SWIFT_MASTER ]; then
			keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$SWIFT_MASTER"':8080/v1/AUTH_$(tenant_id)s' --adminurl 'http://'"$SWIFT_MASTER"':8080/v1' --internalurl 'http://'"$SWIFT_MASTER"':8080/v1/AUTH_$(tenant_id)s'
		else
			keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':8080/v1/AUTH_$(tenant_id)s' --adminurl 'http://'"$MASTER"':8080/v1' --internalurl 'http://'"$MASTER"':8080/v1/AUTH_$(tenant_id)s'
		fi
		;;
		identity)
		keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':5000/v2.0' --adminurl 'http://'"$MASTER"':35357/v2.0' --internalurl 'http://'"$MASTER"':5000/v2.0'
		;;
		ec2)
		keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':8773/services/Cloud' --adminurl 'http://'"$MASTER"':8773/services/Admin' --internalurl 'http://'"$MASTER"':8773/services/Cloud'
		;;
		network)
		keystone endpoint-create --region $KEYSTONE_REGION --service-id $2 --publicurl 'http://'"$MASTER"':9696/' --adminurl 'http://'"$MASTER"':9696/' --internalurl 'http://'"$MASTER"':9696/'
		;;
	esac
}		

for i in compute volume image object-store identity ec2 network; do
	id=`mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p "$MYSQL_PASSWORD" "$MYSQL_DATABASE" -ss -e "SELECT id FROM service WHERE type='"$1"';"` || exit 1
	create_endpoint $1 $id
done

echo "service list"
keystone service-list
echo "endpoint list"
keystone endpoint-list