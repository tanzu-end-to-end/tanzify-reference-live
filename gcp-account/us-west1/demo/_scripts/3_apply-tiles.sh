#!/usr/bin/env bash


# This script:
#   1)  Calls terragrunt run-all apply on each module directory
#

source ./commons.sh



run_terragrunt_tiles()
{
  run_terragrunt_no_parallelism 3_tkgi_and_harbor_tiles "$1"
}
main()
{

   run_terragrunt_tiles "run-all apply"
}



main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


