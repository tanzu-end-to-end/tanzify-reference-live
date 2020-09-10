#!/bin/sh

set -e

# set some variables
. ./setVars.sh

abort()
{
    if [ "$?" = "0" ]
    then
        return
    else
      echo >&2 '
      ***************
      *** STOPPING ***
      ***************
      '
      echo "An error occurred on line $1. Exiting..." >&2
      exit 1
    fi
}

terragrunt_apply_all()
{
  cd $SCRIPT_DIR
  file="terragrunt-modules.list"
  while IFS= read -r app
  do
    if [ ! "${app:0:1}" == "#" ]
    then
      terragrunt apply-all --terragrunt-non-interactive
    fi
  done < "$file"
  wait

}

terragrunt_plan_all()
{
  cd $SCRIPT_DIR
  file="terragrunt-modules.list"
  while IFS= read -r app
  do
    if [ ! "${app:0:1}" == "#" ]
    then
      terragrunt plan-all --terragrunt-non-interactive
    fi
  done < "$file"
  wait

}

terragrunt_validate_all()
{
  cd $SCRIPT_DIR
  file="terragrunt-modules.list"
  while IFS= read -r app
  do
    if [ ! "${app:0:1}" == "#" ]
    then
      terragrunt validate-all --terragrunt-non-interactive
    fi
  done < "$file"
  wait

}

echo_msg()
{
  echo ""
  echo "************** ${1} **************"
}

trap 'abort $LINENO' 0
SECONDS=0
SCRIPTNAME=`basename "$0"`
