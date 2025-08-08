from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from database import get_db, Base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import Column, Integer, String, Text


class TopicORM(Base):
    __tablename__ = "topics"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text)


router = APIRouter()


class Topic(BaseModel):
    name: str
    description: str | None = None


@router.get("/topics")
async def get_topics(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(TopicORM))
    topics = result.scalars().all()
    return [topic.__dict__ for topic in topics]


@router.get("/topics/{topic_id}")
async def get_topic(topic_id: int, db: AsyncSession = Depends(get_db)):
    topic = await db.get(TopicORM, topic_id)
    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")
    return topic.__dict__


@router.post("/topics", status_code=201)
async def create_topic(topic: Topic, db: AsyncSession = Depends(get_db)):
    topic_obj = TopicORM(**topic.dict())
    db.add(topic_obj)
    try:
        await db.commit()
        await db.refresh(topic_obj)
        return topic_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/topics/{topic_id}")
async def update_topic(topic_id: int, topic: Topic, db: AsyncSession = Depends(get_db)):
    topic_obj = await db.get(TopicORM, topic_id)
    if not topic_obj:
        raise HTTPException(status_code=404, detail="Topic not found")
    for key, value in topic.dict().items():
        setattr(topic_obj, key, value)
    try:
        await db.commit()
        await db.refresh(topic_obj)
        return topic_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/topics/{topic_id}", status_code=204)
async def delete_topic(topic_id: int, db: AsyncSession = Depends(get_db)):
    topic_obj = await db.get(TopicORM, topic_id)
    if not topic_obj:
        raise HTTPException(status_code=404, detail="Topic not found")
    await db.delete(topic_obj)
    await db.commit()
    return
