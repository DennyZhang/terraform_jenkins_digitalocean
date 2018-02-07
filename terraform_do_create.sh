#!/usr/bin/env bash
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: terraform_do_create.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-02-07>
## Updated: Time-stamp: <2018-02-07 17:49:04>
##-------------------------------------------------------------------
set -e

function valid_parameters() {
    # TODO
    # vm_hostname
    # machine_flavor
    # region
    # ssh_keys
    # do_token
}

################################################################################
valid_parameters

terraform_task_id=${1?}
terraform_tf_file=${2?}
export vm_image="ubuntu-14-04-x64"
export working_dir="."

mkdir -p "$working_dir/$terraform_task_id"
cd "$working_dir/$terraform_task_id"

terraform init
terraform apply --var="do_token=$do_token"
terraform show
## File: terraform_do_create.sh ends
