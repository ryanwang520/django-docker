from django.http import JsonResponse


def json_response_middleware(get_response):
    def middleware(request):
        response = get_response(request)
        if isinstance(response, dict):
            return JsonResponse(response)

        return response

    return middleware
