FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    flex \
    bison \
    gcc \
    make \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

CMD ["bash"]

