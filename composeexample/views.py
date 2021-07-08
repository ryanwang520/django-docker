from django.http.response import HttpResponse
import requests


def debug(request):
	response =  requests.get('https://baidu.com')
	return  HttpResponse(str(response))
