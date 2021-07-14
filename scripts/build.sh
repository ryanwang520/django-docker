#!/bin/bash
set -euxo pipefail

pip-compile

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE_NAME="moonshadow/django-docker"
docker build -t "$IMAGE_NAME:$GIT_BRANCH" \
             -t "$IMAGE_NAME:$GIT_COMMIT" .
docker push "$IMAGE_NAME:$GIT_BRANCH"
docker push "$IMAGE_NAME:$GIT_COMMIT"


python scripts/smoke_test.py
