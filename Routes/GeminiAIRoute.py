import os
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import httpx

from dotenv import load_dotenv

load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent"

router = APIRouter()


class ChatRequest(BaseModel):
    message: str


class ChatResponse(BaseModel):
    reply: str


@router.post("/gemini-chat", response_model=ChatResponse)
async def chat_with_gemini(request: ChatRequest):
    payload = {"contents": [{"parts": [{"text": request.message}]}]}
    params = {"key": GEMINI_API_KEY}
    async with httpx.AsyncClient() as client:
        response = await client.post(GEMINI_API_URL, json=payload, params=params)
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=response.text)
        data = response.json()
        # Extract the reply from Gemini response
        try:
            reply = data["candidates"][0]["content"]["parts"][0]["text"]
        except Exception:
            reply = "Sorry, I couldn't understand the response."
        return ChatResponse(reply=reply)
