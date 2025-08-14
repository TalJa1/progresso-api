import os
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import httpx
import logging
from dotenv import load_dotenv

load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent"

router = APIRouter()

logger = logging.getLogger("gemini")


class ChatRequest(BaseModel):
    message: str


class ChatResponse(BaseModel):
    reply: str


@router.post("/gemini-chat", response_model=ChatResponse)
async def chat_with_gemini(request: ChatRequest):
    payload = {"contents": [{"parts": [{"text": request.message}]}]}
    params = {"key": GEMINI_API_KEY}
    async with httpx.AsyncClient(timeout=1000.0) as client:
        response = await client.post(GEMINI_API_URL, json=payload, params=params)
        try:
            data = response.json()
        except Exception as e:
            logger.error(
                f"Failed to parse Gemini API response as JSON: {e}, raw: {response.text}"
            )
            raise HTTPException(
                status_code=500,
                detail={
                    "error": "Failed to parse Gemini API response as JSON.",
                    "raw": response.text,
                },
            )
        logger.info(f"Gemini API response: {data}")
        if response.status_code != 200:
            logger.error(f"Gemini API error: {response.status_code} {data}")
            raise HTTPException(status_code=response.status_code, detail=data)
        try:
            reply = data["candidates"][0]["content"]["parts"][0]["text"]
        except Exception as e:
            logger.error(f"Unexpected Gemini API response structure: {data}")
            raise HTTPException(
                status_code=500,
                detail={
                    "error": "Unexpected Gemini API response structure.",
                    "raw": data,
                },
            )
        return ChatResponse(reply=reply)
