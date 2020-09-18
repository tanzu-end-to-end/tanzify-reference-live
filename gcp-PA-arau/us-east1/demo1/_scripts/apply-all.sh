#!/bin/sh


# This script:
#   Calls terragrunt apply-all on each module directory
#

source ./commons.sh

run_terragrunt_all()
{
  run_terragrunt 0_secrets apply-all
  run_terragrunt 1_infra apply-all
  run_terragrunt 2_opsman apply-all
  run_terragrunt_no_parallelism 3_tiles apply-all

}


main()
{

   run_terragrunt_all
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


