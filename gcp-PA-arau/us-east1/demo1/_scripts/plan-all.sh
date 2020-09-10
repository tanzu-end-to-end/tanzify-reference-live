#!/bin/sh

#!/bin/sh

# This script:
#   1) Reads terragrunt-modules.list
#   2) Calls terragrunt apply-all on each module directory
#

source ./commons.sh


terragrunt_apply_all

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0


