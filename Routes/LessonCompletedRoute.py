from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from database import get_db, Base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import Column, Integer, DateTime, ForeignKey
import datetime


class LessonCompletedORM(Base):
    __tablename__ = "lessons_completed"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    lesson_id = Column(Integer, ForeignKey("lessons.id"), nullable=False)
    completed_at = Column(DateTime, default=datetime.datetime.utcnow)


router = APIRouter()


class LessonCompleted(BaseModel):
    user_id: int
    lesson_id: int
    completed_at: datetime.datetime | None = None


@router.get("/lessons-completed")
async def get_lessons_completed(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(LessonCompletedORM))
    items = result.scalars().all()
    return [item.__dict__ for item in items]


@router.get("/lessons-completed/{item_id}")
async def get_lesson_completed(item_id: int, db: AsyncSession = Depends(get_db)):
    item = await db.get(LessonCompletedORM, item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Lesson completed record not found")
    return item.__dict__


@router.post("/lessons-completed", status_code=201)
async def create_lesson_completed(
    data: LessonCompleted, db: AsyncSession = Depends(get_db)
):
    item_obj = LessonCompletedORM(**data.dict())
    db.add(item_obj)
    try:
        await db.commit()
        await db.refresh(item_obj)
        return item_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/lessons-completed/{item_id}")
async def update_lesson_completed(
    item_id: int, data: LessonCompleted, db: AsyncSession = Depends(get_db)
):
    item_obj = await db.get(LessonCompletedORM, item_id)
    if not item_obj:
        raise HTTPException(status_code=404, detail="Lesson completed record not found")
    for key, value in data.dict().items():
        setattr(item_obj, key, value)
    try:
        await db.commit()
        await db.refresh(item_obj)
        return item_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/lessons-completed/{item_id}", status_code=204)
async def delete_lesson_completed(item_id: int, db: AsyncSession = Depends(get_db)):
    item_obj = await db.get(LessonCompletedORM, item_id)
    if not item_obj:
        raise HTTPException(status_code=404, detail="Lesson completed record not found")
    await db.delete(item_obj)
    await db.commit()
    return


@router.get("/lessons-completed/by-user/{user_id}")
async def get_lessons_completed_by_user(
    user_id: int, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(LessonCompletedORM).where(LessonCompletedORM.user_id == user_id)
    )
    items = result.scalars().all()
    return [item.__dict__ for item in items]
