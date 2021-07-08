#!/bin/bash
set -euo pipefail
echo "start django server in docker"
python manage.py migrate
exec "$@"
