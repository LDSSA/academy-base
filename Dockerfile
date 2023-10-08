FROM python:3.10.11-bullseye

WORKDIR /

ENV \
    # Python
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    # Poetry
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_HOME='/usr/local' \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    # Misc
    PATH=/usr/local/bin:$PATH \
    LANG=C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    groupadd -r student; \
    useradd -u 1000 -r -m -d /student -g student -s /bin/false student; \
    # Add required packages
    DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends; \
    apt-get install -y --no-install-recommends locales; \
    locale-gen en_US.UTF-8; \
    apt-get install -y --no-install-recommends software-properties-common; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gfortran \
      g++ \
      git \
      libboost-program-options-dev \
      libpq-dev \
      libtool \
      libxrender1 \
      libgomp1 \
      wget; \
    curl -sSL https://install.python-poetry.org | python3 - ; \
    apt-get purge --auto-remove -y -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*

COPY ./poetry.lock ./pyproject.toml ./

# Install only the package dependencies
RUN poetry install --quiet --no-root --no-directory --no-ansi

# Instruct joblib to use disk for temporary files. Joblib defaults to
# /shm when that directory is present. In the Docker container, /shm is
# present but defaults to 64 MB.
# https://github.com/joblib/joblib/blob/0.11/joblib/parallel.py#L328L342
ENV JOBLIB_TEMP_FOLDER=/tmp

ENV VERSION=3.10.0 \
    VERSION_MAJOR=3 \
    VERSION_MINOR=10 \
    VERSION_MICRO=0
