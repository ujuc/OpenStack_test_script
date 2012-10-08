#!/bin/bash

sudo stop libvirt-bin; sudo stop nova-network; sudo stop nova-compute; sudo stop nova-api; sudo stop nova-objectstore; sudo stop nova-scheduler; sudo stop nova-volume; sudo stop nova-consoleauth; sudo stop nova-cert;

sudo start libvirt-bin; sudo start nova-network; sudo start nova-compute; sudo start nova-api; sudo start nova-objectstore; sudo start nova-scheduler; sudo start nova-volume; sudo start nova-consoleauth; sudo start nova-cert;

