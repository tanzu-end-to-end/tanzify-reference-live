#!/usr/bin/env bash


# This script:
#   1)  Calls terragrunt run-all apply on each module directory
#

source ./commons.sh

run_terragrunt_opsman()
{
  run_terragrunt 2_opsman "$1"
}

main()
{

   run_terragrunt_opsman "run-all apply"
}



main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


