from django.http.response import HttpResponse

from .models import Person

# Create your views here.


def go(request):
    persons = Person.objects.all()
    return HttpResponse(f"go {len(persons)} persons")
