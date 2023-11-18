FROM openjdk:17.0.1-jdk-slim


RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y python3-pip && \
    python3 -m pip install wheel

COPY requirements.txt /code/requirements.txt

COPY . /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--proxy-headers"]

# https://stackoverflow.com/a/72021175/11516704
