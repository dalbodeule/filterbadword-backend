FROM roseline124/konlpy-fastapi

COPY . /

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--proxy-headers"]
