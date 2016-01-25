#!/bin/bash
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
openrc_location="openrc.sh" # Change this to the location of your downloaded OpenStack rc file
function login {
    echo "Enter user you would like to login as:"
    read user
    ssh $user@$(nova show $(nova list | grep -i $1 | awk '{ print $2 }') | grep network | awk '{ print $6 }')
}
function login_msg {
    echo -e "Logging in to ${GREEN}$1${NC}..."
}
if [ -z "$OS_USERNAME" ];
    then source $openrc_location; 
fi
echo "Enter OpenStack server name to search for:"
read server_name
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
    then login_msg $server_name
    login $server_name
else
    echo -e "${RED}No matching servers were found.${NC}"
fi
