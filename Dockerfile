FROM python:3.9-slim-buster
RUN apt-get update && apt-get install -y tini
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/

EXPOSE 8000
ENTRYPOINT ["tini", "--", "./entrypoint.sh"]
# CMD ["python", "manage.py", "runserver"]
CMD ["gunicorn", "-b", "0.0.0.0:8000", "composeexample.wsgi"]
