#!/bin/bash
# From http://www.hastexo.com/resources/docs/installing-openstack-essex-20121-ubuntu-1204-precise-pangolin
# Modified by Emilien Macchi
# Please send me feedback at emilien.macchi@gmail.com
# Thank's to Martin !
# Thank's to stckops ~!!!
# edit : ujuc

#
# Endpoint setting
# NOT used '#' add

function get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

# Tenants
ADMIN_TENANT=$(get_id keystone tenant-create --name admin)
SERVICE_TENANT=$(get_id keystone tenant-create --name service)
DEMO_TENANT=$(get_id keystone tenant-create --name demo)

# Users
ADMIN_USER=$(get_id keystone user-create --name admin --pass admin --email admin@foo.kr)
DEMO_USER=$(get_id keystone user-create --name demo --pass demo --email demo@foo.kr)

NOVA_USER=$(get_id keystone user-create --name nova --pass nova --email nova@foo.kr)
GLANCE_USER=$(get_id keystone user-create --name glance --pass glance  --email glance@foo.kr)
SWIFT_USER=$(get_id keystone user-create --name swift --pass swift --email swift@foo.kr)
QUANTUM_USER=$(get_id keystone user-create --name quantum --pass quantum --email quantum@foo.kr)
CINDER_USER=$(get_id keystone user-create --name cinder --pass cinder --email cinder@foo.kr)

# Roles
ADMIN_ROLE=$(get_id keystone role-create --name admin)
MEMBER_ROLE=$(get_id keystone role-create --name Member)

# Add Roles to Users in Tenants
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT

keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $DEMO_TENANT
keystone user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $DEMO_TENANT

keystone user-role-add --user-id $NOVA_USER --role-id $ADMIN_ROLE --tenant-id $SERVICE_TENANT
keystone user-role-add --user-id $GLANCE_USER --role-id $ADMIN_ROLE --tenant-id $SERVICE_TENANT
keystone user-role-add --user-id $SWIFT_USER --role-id $ADMIN_ROLE --tenant-id $SERVICE_TENANT
keystone user-role-add --user-id $QUANTUM_USER --role-id $ADMIN_ROLE --tenant-id $SERVICE_TENANT
keystone user-role-add --user-id $CINDER_USER --role-id $ADMIN_ROLE --tenant-id $SERVICE_TENANT

# list view
echo "tenant list"
keystone tenant-list
echo "user list"
keystone user-list
echo "role-list"
keystone role-list
