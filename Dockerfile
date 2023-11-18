FROM python:3.11.6
WORKDIR /code

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jre && \
    pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY requirements.txt /code/requirements.txt

COPY . /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--proxy-headers"]
