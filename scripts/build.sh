!#/bin/sh 
set -euxo pipefail
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD) 
GIT_COMMIT=$(git rev-parse --short HEAD) 

IMAGE_TAG=$GIT_BRANCH docker-compose build
IMAGE_TAG=$GIT_COMMIT docker-compose build
IMAGE_TAG=$GIT_BRANCH docker-compose push 
IMAGE_TAG=$GIT_COMMIT docker-compose push 
