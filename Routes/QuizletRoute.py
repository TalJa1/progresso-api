from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from database import get_db, Base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import Column, Integer, String, Text, ForeignKey


class QuizletORM(Base):
    __tablename__ = "quizlet"
    id = Column(Integer, primary_key=True, index=True)
    lesson_id = Column(Integer, ForeignKey("lessons.id"), nullable=False)
    question = Column(Text, nullable=False)
    answer = Column(Text, nullable=False)


router = APIRouter()


class Quizlet(BaseModel):
    lesson_id: int
    question: str
    answer: str


@router.get("/quizlet")
async def get_quizlets(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(QuizletORM))
    items = result.scalars().all()
    return [item.__dict__ for item in items]


@router.get("/quizlet/{quizlet_id}")
async def get_quizlet(quizlet_id: int, db: AsyncSession = Depends(get_db)):
    item = await db.get(QuizletORM, quizlet_id)
    if not item:
        raise HTTPException(status_code=404, detail="Quizlet not found")
    return item.__dict__


@router.get("/quizlet/by-lesson/{lesson_id}")
async def get_quizlets_by_lesson(lesson_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(QuizletORM).where(QuizletORM.lesson_id == lesson_id)
    )
    items = result.scalars().all()
    return [item.__dict__ for item in items]


@router.post("/quizlet", status_code=201)
async def create_quizlet(data: Quizlet, db: AsyncSession = Depends(get_db)):
    item_obj = QuizletORM(**data.dict())
    db.add(item_obj)
    try:
        await db.commit()
        await db.refresh(item_obj)
        return item_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/quizlet/{quizlet_id}")
async def update_quizlet(
    quizlet_id: int, data: Quizlet, db: AsyncSession = Depends(get_db)
):
    item_obj = await db.get(QuizletORM, quizlet_id)
    if not item_obj:
        raise HTTPException(status_code=404, detail="Quizlet not found")
    for key, value in data.dict().items():
        setattr(item_obj, key, value)
    try:
        await db.commit()
        await db.refresh(item_obj)
        return item_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/quizlet/{quizlet_id}", status_code=204)
async def delete_quizlet(quizlet_id: int, db: AsyncSession = Depends(get_db)):
    item_obj = await db.get(QuizletORM, quizlet_id)
    if not item_obj:
        raise HTTPException(status_code=404, detail="Quizlet not found")
    await db.delete(item_obj)
    await db.commit()
    return
