#!/bin/sh


# This script:
#   1)  Calls terragrunt apply-all on each module directory
#

# For using LastPass for secrets, make sure to
# 1) Install the LastPass CLI and configure it to the account that has your secrets
# 2) Make sure to export the vriables LASTPASS_USER and LASTPASS_PASSWORD

source ./commons.sh


run_terragrunt_secrets()
{
  run_terragrunt 0_secrets $1
}



main()
{
   run_terragrunt_secrets apply-all
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


