#!/bin/sh


# This script:
#   1) Reads terragrunt-modules.list
#   2) Calls terragrunt plan-all on each module directory
#

source ./commons.sh


main()
{
   run_terragrunt_secrets apply-all
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


