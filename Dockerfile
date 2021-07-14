# syntax = docker/dockerfile:1.2
FROM python:3.9.6-slim-buster
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y procps net-tools iputils-ping curl && \
	apt-get -y upgrade && \
	apt-get install -y --no-install-recommends tini && \ 
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/*
ENV PYTHONUNBUFFERED 1
ENV PYTHONFAULTHANDLER 1

COPY requirements.txt /tmp/
RUN --mount=type=cache,target=/root/.cache pip install -r /tmp/requirements.txt


RUN useradd --create-home appuser 
WORKDIR /home/appuser
USER appuser

COPY --chown=appuser . .

EXPOSE 8000
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["tini", "--", "./entrypoint.sh"]
CMD ["gunicorn", "--workers=2","--threads=4", "--log-file=-", "-b", "0.0.0.0:8000", "django_docker.wsgi"]
