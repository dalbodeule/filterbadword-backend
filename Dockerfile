FROM openjdk:22
RUN microdnf install python311 pip3

WORKDIR /code

COPY requirements.txt /code/requirements.txt
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

COPY . /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--proxy-headers"]
