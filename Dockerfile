FROM python:3.11.6-slim 
WORKDIR /app

RUN pip install -r requirements.txt
COPY . ./app

CMD ["python3 main.py"]
