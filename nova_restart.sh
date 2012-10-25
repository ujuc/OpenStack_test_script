#!/bin/bash

sudo stop libvirt-bin; sudo start libvirt-bin;

cd /etc/init.d/; for i in $( ls nova-* ); do sudo service $i restart; done; cd ~/;