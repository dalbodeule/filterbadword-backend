from fastapi import Request, APIRouter, HTTPException, Security
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List
import numpy as np
import tensorflow as tf
import keras
import fasttext
import re
import hgtk

from auth import get_api_key

from os import path
import os

TFModel: keras.Model = keras.models.load_model(path.join(os.getcwd(), 'model', 'model.h5'))
fastTextModel = fasttext.load_model(path.join(os.getcwd(), 'model', 'fasttext.bin'))

def is_float(element: any) -> bool:
    #If you expect None to be passed:
    if element is None:
        return False
    try:
        float(element)
        return True
    except ValueError:
        return False

ncf = APIRouter(prefix='/api')

def get_vector(data: List[str]):
    words = []

    for word in data:
        words.append(hgtk.text.decompose(word, compose_code=''))

    data = np.array([fastTextModel[word] for word in words], dtype=np.float64)
    np.nan_to_num(data)

    return data

class ResponseBadword(BaseModel):
   prediction: float
   type: int

@ncf.post('/', response_model= List[ResponseBadword])
async def predict(request: List[str], api_key: str = Security(get_api_key)):
    try:
        if len(request) == 0 or request[0] == '':
            return [ResponseBadword(predition =  0, type = 0)]
        
        requests = []

        for text in request:
            data = str(text).strip().split()
            data = get_vector(data)
            requests.append(data)

        
        data = tf.ragged.constant(requests)
        predict = TFModel.predict(data, verbose=0)

        responses = []
        
        for i in predict:
            responses.append(ResponseBadword(prediction= float(np.max(i)), type= np.argmax(i).item()))
        return responses
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail="contact the administrator.")

@ncf.get('/')
async def default():
    raise HTTPException(status_code=404)