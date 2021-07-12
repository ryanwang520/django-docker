#!/bin/bash
set -euo pipefail
echo "start django server in docker"
if [ -v DEV_MODE ]; then
	python manage.py migrate
fi
exec "$@"
