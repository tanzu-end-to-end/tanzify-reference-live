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

run_terragrunt_all()
{

  run_terragrunt_infra apply-all
  run_terragrunt_opsman apply-all
  run_terragrunt_tiles apply-all

}

run_terragrunt_opsman()
{
  run_terragrunt 2_opsman $1
}

run_terragrunt_infra()
{
  #Apply 0_secrets first since without that we cannot authenticate to the cloud providers to know what to create.
  run_terragrunt 1_infra/0_secrets apply-all
  run_terragrunt 1_infra $1
}

run_terragrunt_tiles()
{
  run_terragrunt 3_tiles $1
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
