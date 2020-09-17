#!/bin/sh


# This script:
#   1)  Calls terragrunt apply-all on each module directory
#

source ./commons.sh


run_terragrunt_infra()
{
  run_terragrunt 1_infra $1
}
main()
{
   run_terragrunt_infra apply-all
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


