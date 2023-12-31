FROM ubuntu:23.04

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Update Ubuntu
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apt-utils

# Install python
RUN apt-get update --fix-missing && apt-get upgrade -y && \
    apt-get install -y sudo dialog git openssh-server wget \
    curl cmake nano python3 python3-pip python3-setuptools python3-venv \
    build-essential libpq-dev gdal-bin libgdal-dev

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    openjdk-17-jre-headless \
    ca-certificates-java && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
  
RUN apt-get autoclean && apt-get autoremove && \
    apt-get update --fix-missing && apt-get upgrade -y && \
    dpkg --configure -a && apt-get install -f

RUN pip3 install \
    wheel fastapi uvicorn\
    --break-system-packages

WORKDIR /code
COPY . /code

RUN python3 -m venv . && \
    /bin/bash -c "source /code/bin/activate && pip install -r /code/requirements.txt --no-cache-dir --break-system-packages"

VOLUME /code/model

ENTRYPOINT ["/bin/bash", "-c", "source /code/bin/activate && uvicorn main:app --host 0.0.0.0 --port 3000 --proxy-headers"]

# https://stackoverflow.com/a/72021175/11516704
