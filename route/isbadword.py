from fastapi import HTTPException, Security, APIRouter
import tensorflow as tf
import fasttext
from auth import get_api_key

from os import path
import os

TFModel = tf.keras.models.load_model(path.join(os.getcwd(), 'saved_model.h5'))
fastTextModel = fasttext.load_model(path.join(os.getcwd(), 'fasttext.bin'))

ncf = APIRouter(prefix='/api')

@ncf.post('/')
async def predict(text: str, api_key: str = Security(get_api_key)):
    try:
        data = str(text).strip().split()
        if len(data) == 0:
            return { "predition": 0.0 }

        data = [fastTextModel[i] for i in data]

        data = tf.ragged.constant([data])

        predict = TFModel.predict(data, verbose=0)

        return { "predition": float(predict[0]) }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@ncf.get('/')
async def default():
    raise HTTPException(status_code=404)