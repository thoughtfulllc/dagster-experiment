FROM python:3.8

RUN apt-get update && apt-get install -yqq cron

# Install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

ENV DAGSTER_HOME=/opt/dagster/app/

RUN mkdir -p /opt/dagster/dagster_home /opt/dagster/app

COPY dagster.yaml /opt/dagster/dagster_home/

WORKDIR /opt/dagster/app/

COPY pyproject.toml poetry.lock* ./
RUN poetry install --no-root --no-dev

COPY . .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/opt/dagster/app/entrypoint.sh"]

EXPOSE 3000:3000