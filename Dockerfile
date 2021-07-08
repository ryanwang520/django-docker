# syntax = docker/dockerfile:1.2
FROM python:3.9-slim-buster
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y --no-install-recommends tini && \ 
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/*
ENV PYTHONUNBUFFERED 1
ENV PYTHONFAULTHANDLER 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN --mount=type=cache,target=/root/.cache pip install -r requirements.txt


RUN useradd --create-home appuser 
USER appuser

ADD . /code/

EXPOSE 8000
ENTRYPOINT ["tini", "--", "./entrypoint.sh"]
# CMD ["python", "manage.py", "runserver"]
CMD ["gunicorn", "--workers=2","--threads=4", "--log-file=-", "-b", "0.0.0.0:8000", "composeexample.wsgi"]
