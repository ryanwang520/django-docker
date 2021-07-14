from django.http.response import HttpResponse

from .apps.main.tasks import add


def debug(request):
    # response =  requests.get('https://baidu.com')
    return {"hello": "world"}
    # return JsonResponse({"hello": "world"})


def ping(request):
    return HttpResponse("pong")


# return  HttpResponse(str(response))


def test_add(request):
    result = add.delay(1, 2)
    return HttpResponse(result.get())
