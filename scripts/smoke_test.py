#!/usr/bin/env python
import time
from subprocess import check_call
from urllib.request import urlopen
check_call(
    "docker run --rm --name smoke  -p 8000:8000 -d moonshadow/django-docker:master".split()
)
# Wait for the server to start. A better implementation would
# poll in a loop:
def check():
    count = 0
    while True:
        time.sleep(0.5)
        # Check if the server started (it'll throw an exception if not): 
        try:
            urlopen("http://localhost:8000/debug").read() 
        except Exception:
            if count < 5:
                count +=1 
                continue
            else:
                raise
        else:
            break
try:
    check()
finally:
    check_call("docker kill smoke".split())
