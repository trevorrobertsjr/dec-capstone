FROM public.ecr.aws/docker/library/python:3.9.18-slim-bullseye

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY dbt/ .

WORKDIR dbt_webclicks

CMD ["dbt","build"]