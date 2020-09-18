#!/bin/sh


# This script:
#   1)  Calls terragrunt apply-all on each module directory
#

source ./commons.sh



run_terragrunt_tiles()
{
  run_terragrunt_no_parallelism 3_tiles $1
}
main()
{

   run_terragrunt_tiles apply-all
}



main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


