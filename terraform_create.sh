#!/usr/bin/env bash
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT
## https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: terraform_create.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-02-07>
## Updated: Time-stamp: <2018-02-09 15:58:56>
##-------------------------------------------------------------------
set -e

################################################################################
function prepare_terraform_without_volume() {
    cat > example.tf <<EOF
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
 token = "\${var.do_token}"
}

resource "digitalocean_droplet" "$vm_hostname" {
 image = "$vm_image"
 name = "$vm_hostname"
 region = "$region"
 size = "$machine_flavor"
 $user_data
 ssh_keys = [$ssh_keys]
}
EOF
}

function prepare_terraform_with_volume() {
    cat > example.tf <<EOF
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
 token = "\${var.do_token}"
}

resource "digitalocean_droplet" "$vm_hostname" {
 image = "$vm_image"
 name = "$vm_hostname"
 region = "$region"
 size = "$machine_flavor"
 $user_data
 ssh_keys = [$ssh_keys]
}
EOF
}

################################################################################
function valid_parameters() {
    # TODO: reduce the code duplication
    if [ -z "$vm_hostname" ]; then
        echo -e "Error: vm_hostname parameter should be given."
        exit 1
    fi
    if [ -z "$machine_flavor" ]; then
        echo -e "Error: machine_flavor parameter should be given."
        exit 1
    fi
    if [ -z "$region" ]; then
        echo -e "Error: region parameter should be given."
        exit 1
    fi
    if [ -z "$ssh_keys" ]; then
        echo -e "Error: ssh_keys parameter should be given."
        exit 1
    fi
    if [ -z "$do_token" ]; then
        echo -e "Error: do_token parameter should be given."
        exit 1
    fi

    if [ -n "$provision_folder" ]; then
        if [ ! -d "$provision_folder" ]; then
            echo -e "Error: provision_folder is given as $provision_folder. But the folder is not found"
            exit 1
        fi
        if [ -z "$ssh_key_file" ] || [ ! -f "$ssh_key_file" ]; then
            echo -e "ERROR: when provision_folder is given, we need to specify a valid ssh private key file"
            exit 1
        fi
    fi
}

function terraform_create_vm() {
    local volume_list=${1:-""}
    terraform init
    if [ -z "$provision_sh" ]; then
        user_data=""
    else
        user_data="user_data = \"#cloud-config\nruncmd:\n - wget -O /root/userdata.sh $provision_sh \n - bash /root/userdata.sh\""
    fi

    # TODO: customize volume creation
    if [ -n "$volume_list" ]; then
       prepare_terraform_without_volume
    else
       prepare_terraform_with_volume
    fi

    terraform apply -auto-approve --var="do_token=$do_token"
    terraform show
}

function get_vm_ip() {
    # TODO: add error handling
    terraform show | grep ipv4_address | awk -F'= ' '{print $2}'
}

function run_provision_folder() {
    # scp provision folder to root
    # Then run all bash script
    local provision_folder=${1?}
    local vm_ip=${2?}

    local ssh_username="root"
    local ssh_folder="/root"
    local ssh_port="22"
    echo "scp $provision_folder folder to /root of VM(vm_ip)"
    scp -P "$ssh_port" -i "$ssh_key_file" -r $provision_folder/* "$ssh_username@$vm_ip:$ssh_folder/"

    for script in $(ls -1 $provision_folder/main_*.sh); do
        script=$(basename "$script")
        echo "ssh -i $ssh_key_file -p $ssh_port $ssh_username$vm_ip \"bash -ex /root/$script\""
        ssh -i "$ssh_key_file" -p "$ssh_port" "$ssh_username@$vm_ip" bash -ex "/root/$script"
    done
}
################################################################################
valid_parameters

terraform_task_id=${1?}
volume_list=${2:-""}
# TODO: support more cloud vendors via plugin system
cloud_driver=${3:-"digitalocean"}
export vm_image="ubuntu-14-04-x64"
export working_dir="."

mkdir -p "$working_dir/$terraform_task_id"
# cp "$terraform_tf_file" "$working_dir/$terraform_task_id/"
cd "$working_dir/$terraform_task_id"

terraform_create_vm "$volume_list"

vm_ip=$(get_vm_ip)
# TODO: Better way to wait for VM slow start, like examining the availability of sshd port(22)
sleep 15

if [ -n "$provision_folder" ]; then
    cd ..
    run_provision_folder "$provision_folder" "$vm_ip"
fi
## File: terraform_create.sh ends
