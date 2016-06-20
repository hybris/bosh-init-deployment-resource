#!/bin/bash

set -e

TARGET=${TARGET:-"sap"}
PIPELINE_NAME=${PIPELINE_NAME:-"bosh-init-deployment-resource-boshrelease"}

if ! [ -x "$(command -v spruce)" ]; then
  echo 'spruce is not installed. Please download at https://github.com/geofffranks/spruce/releases' >&2
fi

if ! [ -x "$(command -v fly)" ]; then
  echo 'fly is not installed.' >&2
fi

CREDENTIALS=$(mktemp /tmp/pipeline.XXXXX)

pull_credentials bosh-init-deployment-resource concourse credentials.yml.erb ${CREDENTIALS}

fly -t ${TARGET} set-pipeline -c pipeline.yml --load-vars-from=${CREDENTIALS} --pipeline=${PIPELINE_NAME}
if [ $? -ne 0 ]; then
  echo "Please login first: fly -t ${TARGET} login -k"
fi
