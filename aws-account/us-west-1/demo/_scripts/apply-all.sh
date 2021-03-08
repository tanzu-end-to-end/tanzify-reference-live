#!/usr/bin/env bash


# This script:
#   Calls terragrunt run-all apply on each module directory
#

source ./commons.sh

run_terragrunt_all()
{
  run_terragrunt 0_secrets "run-all apply"
  run_terragrunt 1_infra "run-all apply"
  run_terragrunt 2_opsman "run-all apply"
  run_terragrunt_no_parallelism 3_tiles "run-all apply"

}


main()
{

   run_terragrunt_all
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


