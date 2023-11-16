FROM python:3.11.6-slim 
WORKDIR /usr/src/app

COPY . .
RUN pip install -r requirements.txt

CMD ["python3 main.py"]
