# syntax = docker/dockerfile:1.2

FROM python:3.9.6-slim-buster AS compile-image

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt /tmp/
RUN --mount=type=cache,target=/root/.cache pip install -r /tmp/requirements.txt

FROM compile-image as compile-image-test
COPY dev-requirements.txt /tmp/dev-requirements.txt
RUN --mount=type=cache,target=/root/.cache pip install -r /tmp/dev-requirements.txt

FROM python:3.9.6-slim-buster as base
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y procps net-tools iputils-ping curl && \
	apt-get -y upgrade && \
	apt-get install -y --no-install-recommends tini && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/*
ENV PYTHONUNBUFFERED 1
ENV PYTHONFAULTHANDLER 1
ENV PATH="/opt/venv/bin:$PATH"
RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser



FROM base as test
COPY --from=compile-image-test /opt/venv /opt/venv
COPY --chown=appuser . .
CMD ["pytest", "tests"]

FROM base
COPY --from=compile-image /opt/venv /opt/venv
COPY --chown=appuser . .
RUN chmod +x ./entrypoint.sh
EXPOSE 8000
ENTRYPOINT ["tini", "--", "./entrypoint.sh"]
CMD ["gunicorn", "--workers=2","--threads=4", "--log-file=-", "-b", "0.0.0.0:8000", "django_docker.wsgi"]
