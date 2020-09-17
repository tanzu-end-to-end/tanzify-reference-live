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




run_terragrunt()
{
  echo_msg "Running terragrunt $2 in directory $1"
  cd $BASE_DIR/$1
  terragrunt $2 --terragrunt-non-interactive
}


echo_msg()
{
  echo ""
  echo "********************* ${1} *****************************"
  echo ""
}

trap 'abort $LINENO' 0
SECONDS=0
SCRIPTNAME=`basename "$0"`
