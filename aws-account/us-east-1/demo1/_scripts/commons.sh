#!/usr/bin/env bash

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

run_terragrunt_no_parallelism()
{
  echo_msg "Running terragrunt $2 in directory $1 with parallelism set to 1"
  cd $BASE_DIR/$1
  terragrunt $2 --terragrunt-non-interactive --terragrunt-parallelism 1
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
