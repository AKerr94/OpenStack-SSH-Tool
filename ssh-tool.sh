#!/bin/bash
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

openrc_location="openrc.sh" # Change this to the location of your downloaded OpenStack rc file

function login {
    # Attempt automatic login by querying for the OS (e.g. centos or ubuntu), else ask user for login user
    server_n=$1
    server_id=$(nova list | grep -i $server_n | awk '{ print $2 }')
    echo "server_id = $server_id"
    server_ip=$(nova show $server_id | grep network | awk '{ print $6 }')
    echo "server_ip = $server_ip"
    nova show $server_id | grep image | grep -i 'centos'
    if [ $? -eq 0 ];
        then ssh centos@$server_ip
    else
        nova show $server_id | grep image | grep -i 'ubuntu'
        if [ $? -eq 0 ];
            then ssh ubuntu@$server_ip
        else
            echo "Enter user you would like to login as:"
            read user
            ssh $user@$server_ip
        fi
    fi
}
function login_msg {
    echo -e "Logging in to ${GREEN}$1${NC}..."
}

if [ -z "$OS_USERNAME" ];
    then source $openrc_location;
fi
echo "Enter OpenStack server name to search for:"
read server_name
if [ -z $server_name ];
    then echo -e "${RED}Error: no server name specified${NC}"
    exit 1
fi
server_list=($(nova list | grep -i $server_name | awk '{ print $4 }'))
server_count=${#server_list[@]}
if [ "$server_count" -gt 1 ];
    then echo -e "Found ${YELLOW}$server_count${NC} matching servers..."
    count=1
    for server in ${server_list[@]};
        do echo -e "[${YELLOW}$count${NC}] $server"
        ((count++))
    done;
    echo "Which server would you like to login to? Enter number:"
    read server_number
    chosen_server=${server_list[$(($server_number -1))]}
    login_msg $chosen_server
    login $chosen_server
elif [ "$server_count" -eq 1 ];
    then login_msg ${server_list[0]}
    login ${server_list[0]}
else
    echo -e "${RED}No matching servers were found.${NC}"
fi
