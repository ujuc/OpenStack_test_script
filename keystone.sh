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

ADMIN_PASSWORD=${ADMIN_PASSWORD:-passwd}
SERVICE_PASSWORD=${SERVICE_PASSWORD:-$ADMIN_PASSWORD}
SERVICE_TENANT_NAME=${SERVICE_TENANT_NAME:-service}

function get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

# Tenants
ADMIN_TENANT=$(get_id keystone tenant-create --name admin)
SERVICE_TENANT=$(get_id keystone tenant-create --name $SERVICE_TENANT_NAME)
DEMO_TENANT=$(get_id keystone tenant-create --name demo)

# Users
ADMIN_USER=$(get_id keystone user-create --name admin --pass "$ADMIN_PASSWORD" --email admin@foo.kr)
DEMO_USER=$(get_id keystone user-create --name demo --pass "$ADMIN_PASSWORD" --email demo@foo.kr)

NOVA_USER=$(get_id keystone user-create --name nova --pass "$SERVICE_PASSWORD" --email nova@foo.kr)
GLANCE_USER=$(get_id keystone user-create --name glance --pass "$SERVICE_PASSWORD"  --email glance@foo.kr)
SWIFT_USER=$(get_id keystone user-create --name swift --pass "$SERVICE_PASSWORD" --email=swift@foo.kr)
QUANTUM_USER=$(get_id keystone user-create --name quantum --pass "$SERVICE_PASSWORD" --email=quantum@foo.kr)

# Roles
ADMIN_ROLE=$(get_id keystone role-create --name=admin)
MEMBER_ROLE=$(get_id keystone role-create --name=Member)

# Add Roles to Users in Tenants (folsom
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT

keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $DEMO_TENANT
keystone user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $DEMO_TENANT

keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $GLANCE_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $SWIFT_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $QUANTUM_USER --role-id $ADMIN_ROLE

# Add Roles to Users in Tenants (Essex)
#keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT

#keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $DEMO_TENANT
#keystone user-role-add --user $DEMO_USER --role $MEMBER_ROLE --tenant_id $DEMO_TENANT

#keystone user-role-add --tenant_id $SERVICE_TENANT --user $NOVA_USER --role $ADMIN_ROLE
#keystone user-role-add --tenant_id $SERVICE_TENANT --user $GLANCE_USER --role $ADMIN_ROLE
#keystone user-role-add --tenant_id $SERVICE_TENANT --user $SWIFT_USER --role $ADMIN_ROLE
#keystone user-role-add --tenant_id $SERVICE_TENANT --user $QUANTUM_USER --role $ADMIN_ROLE

# Sevices
keystone service-create --name nova --type compute --description "OpenStack Compute Service"
keystone service-create --name volume --type volume --description "OpenStack Volume Service"
keystone service-create --name glance --type image --description "OpenStack Image Service"
keystone service-create --name swift --type object-store --description "OpenStack Storage Service"
keystone service-create --name keystone --type identity --description="OpenStack Identity Service"
keystone service-create --name=quantum --type=network --description="OpenStack Network Service"
keystone service-create --name=ec2 --type=ec2 --description="EC2 Service"

# list view
echo "tenant list"
keystone tenant-list
echo "user list"
keystone user-list
echo "role-list"
keystone role-list
echo "service list"
keystone service-list
