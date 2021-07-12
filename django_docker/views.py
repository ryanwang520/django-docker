from django.http.response import HttpResponse, JsonResponse
import requests
from .apps.main.tasks import add


def debug(request):
	# response =  requests.get('https://baidu.com')
    return {"hello": "world"}
    # return JsonResponse({"hello": "world"})


# return  HttpResponse(str(response))

def test_add(request):
	result = add.delay(1, 2)
	return HttpResponse(result.get())
