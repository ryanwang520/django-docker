

from django.http.response import HttpResponse


def debug(request):
	return HttpResponse("hello ")
