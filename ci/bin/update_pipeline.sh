#!/bin/bash

set -e

TARGET=${TARGET:-"hybris"}
PIPELINE_NAME=${PIPELINE_NAME:-"bosh-init-deployment-resource"}

if ! [ -x "$(command -v spruce)" ]; then
  echo 'spruce is not installed. Please download at https://github.com/geofffranks/spruce/releases' >&2
fi

if ! [ -x "$(command -v fly)" ]; then
  echo 'fly is not installed.' >&2
fi

CREDENTIALS=$(mktemp /tmp/credentials.XXXXX)

vault read -field=value -tls-skip-verify secret/concourse/bosh-init-deployment-resource > ${CREDENTIALS}

fly -t ${TARGET} set-pipeline -c pipeline.yml --load-vars-from=${CREDENTIALS} --pipeline=${PIPELINE_NAME}
if [ $? -ne 0 ]; then
  echo "Please login first: fly -t ${TARGET} login -k"
fi

rm -f ${CREDENTIALS}
