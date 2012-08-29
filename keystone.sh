﻿#!/bin/bash
# From http://www.hastexo.com/resources/docs/installing-openstack-essex-20121-ubuntu-1204-precise-pangolin
# Modified by Emilien Macchi
# Please send me feedback at emilien.macchi@gmail.com
# Thank's to Martin !
# Thank's to stckops ~!!!
# edit : ujuc

ADMIN_PASSWORD=${ADMIN_PASSWORD:-passwd}
SERVICE_PASSWORD=${SERVICE_PASSWORD:-$ADMIN_PASSWORD}
SERVICE_TENANT_NAME=${SERVICE_TENANT_NAME:-service}

function get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

# Tenants
ADMIN_TENANT=$(get_id keystone tenant-create --name=admin)
SERVICE_TENANT=$(get_id keystone tenant-create --name=$SERVICE_TENANT_NAME)
DEMO_TENANT=$(get_id keystone tenant-create --name=demo)

# Users
ADMIN_USER=$(get_id keystone user-create --name=admin --pass="$ADMIN_PASSWORD" --email=admin@foo.kr)
DEMO_USER=$(get_id keystone user-create --name=demo --pass="$ADMIN_PASSWORD" --email=demo@foo.kr)

# Roles
ADMIN_ROLE=$(get_id keystone role-create --name=admin)
#KEYSTONEADMIN_ROLE=$(get_id keystone role-create --name=KeystoneAdmin)
#KEYSTONESERVICE_ROLE=$(get_id keystone role-create --name=KeystoneServiceAdmin)

# Add Roles to Users in Tenants
keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT
keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $DEMO_TENANT
#keystone user-role-add --user $ADMIN_USER --role $KEYSTONEADMIN_ROLE --tenant_id $ADMIN_TENANT
#keystone user-role-add --user $ADMIN_USER --role $KEYSTONESERVICE_ROLE --tenant_id $ADMIN_TENANT

# The Member role is used by Horizon and Swift
MEMBER_ROLE=$(get_id keystone role-create --name=Member)
keystone user-role-add --user $DEMO_USER --role $MEMBER_ROLE --tenant_id $DEMO_TENANT

# Configure service users/roles
NOVA_USER=$(get_id keystone user-create --name=nova --pass="$SERVICE_PASSWORD" --tenant_id $SERVICE_TENANT --email=nova@foo.kr)
keystone user-role-add --tenant_id $SERVICE_TENANT --user $NOVA_USER --role $ADMIN_ROLE

GLANCE_USER=$(get_id keystone user-create --name=glance --pass="$SERVICE_PASSWORD" --tenant_id $SERVICE_TENANT --email=glance@foo.kr)
keystone user-role-add --tenant_id $SERVICE_TENANT --user $GLANCE_USER --role $ADMIN_ROLE

SWIFT_USER=$(get_id keystone user-create --name=swift --pass="$SERVICE_PASSWORD" --tenant_id $SERVICE_TENANT --email=swift@foo.kr)
keystone user-role-add --tenant_id $SERVICE_TENANT --user $SWIFT_USER --role $ADMIN_ROLE

RESELLER_ROLE=$(get_id keystone role-create --name=ResellerAdmin)
keystone user-role-add --tenant_id $SERVICE_TENANT --user $NOVA_USER --role $RESELLER_ROLE

QUANTUM_USER=$(get_id keystone user-create --name=quantum --pass="$SERVICE_PASSWORD" --tenant_id $SERVICE_TENANT --email=quantum@foo.kr)
keystone user-role-add --tenant_id $SERVICE_TENANT --user $QUANTUM_USER --role $ADMIN_ROLE

# Sevices
keystone service-create --name=nova --type=compute --description="OpenStack Compute Service"
keystone service-create --name=volume --type=volume --description="OpenStack Volume Service"
keystone service-create --name=glance --type=image --description="OpenStack Image Service"
keystone service-create --name=swift --type=object-store --description="OpenStack Storage Service"
keystone service-create --name=quantum --type=network --description="OpenStack Network Service"
keystone service-create --name=ec2 --type=ec2 --description="EC2 Service"

# list view
keystone tenant-list
keystone user-list
keystone role-list
keystone service-list
