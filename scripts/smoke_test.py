import time
from subprocess import check_call
from urllib.request import urlopen
check_call(
    "docker run --rm --name smoke  -p 8000:8000 -d moonshadow/django-docker:0.1".split()
)
# Wait for the server to start. A better implementation would
# poll in a loop:
time.sleep(5)
# Check if the server started (it'll throw an exception if not): 
try:
    urlopen("http://localhost:8000").read() 
finally:
    check_call("docker kill smoke".split())
