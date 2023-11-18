FROM python:3.11.6
WORKDIR /code

COPY requirements.txt /code/requirements.txt

RUN apt install openjdk@17 -y && pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--proxy-headers"]
