#!/bin/bash
# edit : Gedit
# eBuntu.

# Server IP
MASTER="10.0.2.15"

# Keystone definition
KEYSTONE_REGION=myRegion

# Sevices
keystone service-create --name nova --type compute --description "OpenStack Compute Service"
keystone service-create --name volume --type volume --description "OpenStack Volume Service"
keystone service-create --name glance --type image --description "OpenStack Image Service"
keystone service-create --name swift --type object-store --description "OpenStack Storage Service"
keystone service-create --name keystone --type identity --description="OpenStack Identity Service"
keystone service-create --name=quantum --type=network --description="OpenStack Network Service"
keystone service-create --name=ec2 --type=ec2 --description="EC2 Service"

# Service nova endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service 094f301ce64c4214b2ae02e90ed20340 \
--publicurl 'http://'"$MASTER"':8774/v2/$(tenant_id)s' \
--adminurl 'http://'"$MASTER"':8774/v2/$(tenant_id)s' \
--internalurl 'http://'"$MASTER"':8774/v2/$(tenant_id)s'

# Service volume endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service b7f9a6a838b940c18f0b54555f7af4a5 \
--publicurl 'http://'"$MASTER"':8776/v1/$(tenant_id)s' \
--adminurl 'http://'"$MASTER"':8776/v1/$(tenant_id)s' \
--internalurl 'http://'"$MASTER"':8776/v1/$(tenant_id)s'

# Service glance endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service 24531925893844369ed9a1007230c915 \
--publicurl 'http://'"$MASTER"':9292/v1' \
--adminurl 'http://'"$MASTER"':9292/v1' \
--internalurl 'http://'"$MASTER"':9292/v1'

# Service swift endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service 5bfb030d0f004981a348f1c795f031c8 \
--publicurl 'http://'"$MASTER"':8080/v1/AUTH_$(tenant_id)s' \
--adminurl 'http://'"$MASTER"':8080/v1' \
--internalurl 'http://'"$MASTER"':8080/v1/AUTH_$(tenant_id)s'

# Service keystone endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service ce1084af74244e77ba1d34f816f1b02d \
--publicurl 'http://'"$MASTER"':5000/v1' \
--adminurl 'http://'"$MASTER"':35357/v2.0' \
--internalurl 'http://'"$MASTER"':5000/2.0'

# Service quantum endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service 3b70a9457e034a6b870b6d57b7b257e4 \
--publicurl 'http://'"$MASTER"':9696/' \
--adminurl 'http://'"$MASTER"':9696/' \
--internalurl 'http://'"$MASTER"':9696/'

# Service ec2 endpoint
keystone endpoint-create --region $KEYSTONE_REGION --service fd0c00b1024f49e786323c174b013b4e \
--publicurl 'http://'"$MASTER"':8773/services/Cloud' \
--adminurl 'http://'"$MASTER"':8773/services/Admin' \
--internalurl 'http://'"$MASTER"':8773/services/Cloud'

# List view
keystone endpoint-list