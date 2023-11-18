FROM ubuntu:latest
LABEL maintainer="dalbodeule <jioo0224@naver.com>"

ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata g++ curl openjdk-17-jdk \
    python3.11 python3-pip libpython3.11-dev && python3 -m pip install --upgrade pip wheel
COPY . .

RUN pip install --no-cache-dir --upgrade -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--proxy-headers"]
