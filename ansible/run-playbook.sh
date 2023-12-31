#!/bin/bash

# Check if the user has provided an argument
if [ $# -eq 0 ]
  then
    echo "No palbook supplied"
    exit 1
fi

# Assign the first argument to a variable
playbook=$1

# Execute the command with the argument
echo "Executing playbook: $1"
ansible-playbook -i inventory.yml $1 --private-key ~/.ssh/ansible -u ansible --become-password-file .become 