from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from database import get_db, Base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import Column, Integer, String, Text, ForeignKey


class LessonORM(Base):
    __tablename__ = "lessons"
    id = Column(Integer, primary_key=True, index=True)
    topic_id = Column(Integer, ForeignKey("topics.id"), nullable=False)
    title = Column(String, nullable=False)
    content = Column(Text)
    video_url = Column(String)
    short_describe = Column(String)


router = APIRouter()


class Lesson(BaseModel):
    topic_id: int
    title: str
    content: str | None = None
    video_url: str | None = None
    short_describe: str | None = None


@router.get("/lessons")
async def get_lessons(db: AsyncSession = Depends(get_db)):
    stmt = select(LessonORM).order_by(LessonORM.topic_id)
    result = await db.execute(stmt)
    lessons = result.scalars().all()
    return [lesson.__dict__ for lesson in lessons]


@router.get("/lessons/{lesson_id}")
async def get_lesson(lesson_id: int, db: AsyncSession = Depends(get_db)):
    lesson = await db.get(LessonORM, lesson_id)
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    return lesson.__dict__


@router.post("/lessons", status_code=201)
async def create_lesson(lesson: Lesson, db: AsyncSession = Depends(get_db)):
    lesson_obj = LessonORM(**lesson.dict())
    db.add(lesson_obj)
    try:
        await db.commit()
        await db.refresh(lesson_obj)
        return lesson_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/lessons/{lesson_id}")
async def update_lesson(
    lesson_id: int, lesson: Lesson, db: AsyncSession = Depends(get_db)
):
    lesson_obj = await db.get(LessonORM, lesson_id)
    if not lesson_obj:
        raise HTTPException(status_code=404, detail="Lesson not found")
    for key, value in lesson.dict().items():
        setattr(lesson_obj, key, value)
    try:
        await db.commit()
        await db.refresh(lesson_obj)
        return lesson_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/lessons/{lesson_id}", status_code=204)
async def delete_lesson(lesson_id: int, db: AsyncSession = Depends(get_db)):
    lesson_obj = await db.get(LessonORM, lesson_id)
    if not lesson_obj:
        raise HTTPException(status_code=404, detail="Lesson not found")
    await db.delete(lesson_obj)
    await db.commit()
    return
