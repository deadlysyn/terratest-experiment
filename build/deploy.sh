#!/usr/bin/env bash

set -eu -o pipefail

set -x

ENV="${1}"
APP_NAME="terratest-experiment"
IMAGE="${APP_NAME}-${ENV}"
AWS_PROFILE="personal"
AWS_REGION="us-east-2"

DIRNAME=$(dirname "$0")
REPO=$(terraform output -state="${DIRNAME}/../environments/${ENV}/terraform.tfstate" ecr_repository_url)
HOST=$(echo "${REPO}" | cut -d/ -f1)

aws-vault exec "${AWS_PROFILE}" -- aws ecr get-login-password --region "${AWS_REGION}" | \
  docker login --username AWS --password-stdin "${HOST}"

docker build -t "${IMAGE}" .

docker tag "${IMAGE}:latest" "${REPO}:latest"

docker push "${REPO}:latest"

aws-vault exec "${AWS_PROFILE}" -- aws ecs update-service \
  --cluster "${APP_NAME}-${ENV}" \
  --service "${APP_NAME}-${ENV}" \
  --force-new-deployment

