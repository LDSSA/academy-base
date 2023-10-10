FROM python:3.10-slim-bullseye

RUN groupadd -r student && \
    useradd -u 1000 -r -m -d /student -g student -s /bin/false student && \
    # Add required packages
    apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git

RUN pip install -U pip wheel
