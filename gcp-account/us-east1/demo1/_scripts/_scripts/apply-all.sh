#!/bin/sh


# This script:
#   1) Reads terragrunt-modules.list
#   2) Calls terragrunt plan-all on each module directory
#

source ./commons.sh

run_terragrunt_all()
{
  run_terragrunt_secrets apply-all
  run_terragrunt_infra apply-all
  run_terragrunt_opsman apply-all
  run_terragrunt_tiles apply-all

}


main()
{

   run_terragrunt_all
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


