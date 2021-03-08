#!/usr/bin/env bash


# This script:
#   1)  Calls terragrunt run-all apply on each module directory
#

source ./commons.sh


run_terragrunt_infra()
{
  run_terragrunt 1_infra "$1"
}
main()
{
   run_terragrunt_infra "run-all apply"
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


