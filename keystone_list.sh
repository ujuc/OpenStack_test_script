#!/bin/bash
# eBuntu test script
# Copyright 2012 eBuntu
# Editer : ujuc

echo "tenant list"
keystone tenant-list
echo "user list"
keystone user-list
echo "role list"
keystone role-list
echo "service list"
keystone service-list
echo "endpoint list"
keystone endpoint-list