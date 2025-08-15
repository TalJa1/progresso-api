from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from typing import Optional, List
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete
from sqlalchemy import Column, Integer, ForeignKey, DateTime, Float, Text
from database import get_db, Base
import datetime

router = APIRouter()


class Submission(Base):
    __tablename__ = "submissions"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    exam_id = Column(Integer, ForeignKey("exams.id"), nullable=False)
    upload_time = Column(DateTime, default=datetime.datetime.utcnow)
    grade = Column(Float, nullable=True)
    feedback = Column(Text, nullable=True)


class SubmissionCreate(BaseModel):
    user_id: int
    exam_id: int
    grade: Optional[float] = None
    feedback: Optional[str] = ""


class SubmissionUpdate(BaseModel):
    grade: Optional[float] = None
    feedback: Optional[str] = None


class SubmissionOut(BaseModel):
    id: int
    user_id: int
    exam_id: int
    upload_time: Optional[datetime.datetime]
    grade: Optional[float]
    feedback: Optional[str]

    class Config:
        orm_mode = True


@router.post(
    "/submissions", response_model=SubmissionOut, status_code=status.HTTP_201_CREATED
)
async def create_submission(
    payload: SubmissionCreate, db: AsyncSession = Depends(get_db)
):
    submission = Submission(
        user_id=payload.user_id,
        exam_id=payload.exam_id,
        grade=payload.grade,
        feedback=payload.feedback,
        upload_time=datetime.datetime.utcnow(),
    )
    db.add(submission)
    await db.commit()
    await db.refresh(submission)
    return submission


@router.get("/submissions", response_model=List[SubmissionOut])
async def list_submissions(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Submission))
    subs = result.scalars().all()
    return subs


@router.get("/submissions/{submission_id}", response_model=SubmissionOut)
async def get_submission(submission_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Submission).where(Submission.id == submission_id))
    sub = result.scalars().first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")
    return sub


@router.put("/submissions/{submission_id}", response_model=SubmissionOut)
async def update_submission(
    submission_id: int, payload: SubmissionUpdate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Submission).where(Submission.id == submission_id))
    sub = result.scalars().first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")
    if payload.grade is not None:
        sub.grade = payload.grade
    if payload.feedback is not None:
        sub.feedback = payload.feedback
    await db.commit()
    await db.refresh(sub)
    return sub


@router.delete("/submissions/{submission_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_submission(submission_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Submission).where(Submission.id == submission_id))
    sub = result.scalars().first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")
    await db.delete(sub)
    await db.commit()
    return None


@router.get("/submissions/user/{user_id}", response_model=List[SubmissionOut])
async def list_submissions_by_user(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Submission).where(Submission.user_id == user_id))
    subs = result.scalars().all()
    return subs
