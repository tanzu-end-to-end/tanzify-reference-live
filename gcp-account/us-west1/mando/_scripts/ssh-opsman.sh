#!/usr/bin/env bash

# Script to SSH into Opsman VM. Requires that 2_opsman/1_opsman-compute has been run successfully to creat the opsman vm

cd ../1_infra/2_paving
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

tmp_ssh_file="$(mktemp)"

terragrunt output ops_manager_ssh_private_key > $tmp_ssh_file

chmod 400 $tmp_ssh_file

ssh -i $tmp_ssh_file ubuntu@$(terragrunt output ops_manager_dns)