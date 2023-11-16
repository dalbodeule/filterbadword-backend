from fastapi import FastAPI
from route import isBadWord

import uvicorn

app = FastAPI()

app.include_router(isBadWord)

@app.get('/')
async def home():
    return {"msg": "Ok"}

@app.get('/health')
async def health():
    return { "Health": "Ok" }

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=3000)