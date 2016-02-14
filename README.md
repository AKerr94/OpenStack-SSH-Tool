# OpenStack-SSH-Tool
Simple script to search an OpenStack tenancy and SSH into a specified machine 

# Usage

You will need to download the openrc file for your tenancy from openstack and source it, or save it in the same directory as this folder with the name openrc.sh.

./ssh-tool.sh
This will run the script, which will prompt you for input for region and server name to search for. Alternatively, these can be supplied as command line arguments with the following flags.

-r [region]

-s [server name]
