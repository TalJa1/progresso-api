from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import select, update, delete
from sqlalchemy.exc import IntegrityError
from database import get_db, Base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import Column, Integer, String, Text


class UserORM(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, nullable=False)
    full_name = Column(String)
    avatar_url = Column(String)
    class_ = Column("class", String)
    school = Column(String)


router = APIRouter()


class User(BaseModel):
    email: str
    full_name: str | None = None
    avatar_url: str | None = None
    class_: str | None = None
    school: str | None = None


@router.get("/users")
async def get_users(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(UserORM))
    users = result.scalars().all()
    return [user.__dict__ for user in users]


@router.get("/users/{user_id}")
async def get_user(user_id: int, db: AsyncSession = Depends(get_db)):
    user = await db.get(UserORM, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user.__dict__


@router.post("/users", status_code=201)
async def create_user(user: User, db: AsyncSession = Depends(get_db)):
    user_obj = UserORM(**user.dict())
    db.add(user_obj)
    try:
        await db.commit()
        await db.refresh(user_obj)
        return user_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/users/{user_id}")
async def update_user(user_id: int, user: User, db: AsyncSession = Depends(get_db)):
    user_obj = await db.get(UserORM, user_id)
    if not user_obj:
        raise HTTPException(status_code=404, detail="User not found")
    for key, value in user.dict().items():
        setattr(user_obj, key, value)
    try:
        await db.commit()
        await db.refresh(user_obj)
        return user_obj.__dict__
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/users/{user_id}", status_code=204)
async def delete_user(user_id: int, db: AsyncSession = Depends(get_db)):
    user_obj = await db.get(UserORM, user_id)
    if not user_obj:
        raise HTTPException(status_code=404, detail="User not found")
    await db.delete(user_obj)
    await db.commit()
    return
