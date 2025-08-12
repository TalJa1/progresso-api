from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from database import get_db, Base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import Column, Integer, String, Text, Date, Time, ForeignKey


class ScheduleORM(Base):
    __tablename__ = "schedule"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(Text)
    type = Column(String)
    event_date = Column(Date, nullable=False)
    start_time = Column(Time)


router = APIRouter()


class Schedule(BaseModel):
    user_id: int
    title: str
    description: str | None = None
    type: str | None = None
    event_date: str  # ISO date string
    start_time: str | None = None  # ISO time string


@router.get("/schedule")
async def get_schedules(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(ScheduleORM))
    items = result.scalars().all()
    return [item.__dict__ for item in items]


@router.get("/schedule/by-user/{user_id}")
async def get_schedules_by_user(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(ScheduleORM).where(ScheduleORM.user_id == user_id))
    items = result.scalars().all()
    return [item.__dict__ for item in items]


@router.get("/schedule/{schedule_id}")
async def get_schedule(schedule_id: int, db: AsyncSession = Depends(get_db)):
    item = await db.get(ScheduleORM, schedule_id)
    if not item:
        raise HTTPException(status_code=404, detail="Schedule not found")
    return item.__dict__


@router.post("/schedule", status_code=201)
async def create_schedule(data: Schedule, db: AsyncSession = Depends(get_db)):
    item_obj = ScheduleORM(**data.dict())
    db.add(item_obj)
    try:
        await db.commit()
        await db.refresh(item_obj)
        return item_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/schedule/{schedule_id}")
async def update_schedule(
    schedule_id: int, data: Schedule, db: AsyncSession = Depends(get_db)
):
    item_obj = await db.get(ScheduleORM, schedule_id)
    if not item_obj:
        raise HTTPException(status_code=404, detail="Schedule not found")
    for key, value in data.dict().items():
        setattr(item_obj, key, value)
    try:
        await db.commit()
        await db.refresh(item_obj)
        return item_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/schedule/{schedule_id}", status_code=204)
async def delete_schedule(schedule_id: int, db: AsyncSession = Depends(get_db)):
    item_obj = await db.get(ScheduleORM, schedule_id)
    if not item_obj:
        raise HTTPException(status_code=404, detail="Schedule not found")
    await db.delete(item_obj)
    await db.commit()
    return
