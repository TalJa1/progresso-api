from fastapi import APIRouter, HTTPException, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete
from pydantic import BaseModel
from typing import List, Optional
from database import Base, get_db
from sqlalchemy import Column, Integer, String, ForeignKey


# SQLAlchemy model for Exam
class Exam(Base):
    __tablename__ = "exams"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    year = Column(Integer)
    province = Column(String)
    topic_id = Column(Integer, ForeignKey("topics.id"))
    rating = Column(Integer)
    student_attempt = Column(Integer, default=0)
    correct_attempt = Column(Integer, default=0)
    added_on = Column(String)  # Store as string (DATE) for SQLite compatibility


# Pydantic schemas


class ExamBase(BaseModel):
    name: str
    year: Optional[int] = None
    province: Optional[str] = None
    topic_id: Optional[int] = None
    rating: Optional[int] = None
    student_attempt: Optional[int] = 0
    correct_attempt: Optional[int] = 0
    added_on: Optional[str] = None


class ExamCreate(ExamBase):
    pass


class ExamUpdate(ExamBase):
    pass


class ExamOut(ExamBase):
    id: int

    class Config:
        orm_mode = True


router = APIRouter(prefix="/exams", tags=["Exams"])


# Create Exam
@router.post("/", response_model=ExamOut, status_code=status.HTTP_201_CREATED)
async def create_exam(exam: ExamCreate, db: AsyncSession = Depends(get_db)):
    db_exam = Exam(**exam.dict())
    db.add(db_exam)
    await db.commit()
    await db.refresh(db_exam)
    return db_exam


# Read all Exams
@router.get("/", response_model=List[ExamOut])
async def read_exams(
    skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Exam).offset(skip).limit(limit))
    return result.scalars().all()


# Read Exam by ID
@router.get("/{exam_id}", response_model=ExamOut)
async def read_exam(exam_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Exam).where(Exam.id == exam_id))
    exam = result.scalar_one_or_none()
    if not exam:
        raise HTTPException(status_code=404, detail="Exam not found")
    return exam


# Update Exam
@router.put("/{exam_id}", response_model=ExamOut)
async def update_exam(
    exam_id: int, exam: ExamUpdate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Exam).where(Exam.id == exam_id))
    db_exam = result.scalar_one_or_none()
    if not db_exam:
        raise HTTPException(status_code=404, detail="Exam not found")
    for key, value in exam.dict(exclude_unset=True).items():
        setattr(db_exam, key, value)
    db.add(db_exam)
    await db.commit()
    await db.refresh(db_exam)
    return db_exam


# Delete Exam
@router.delete("/{exam_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_exam(exam_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Exam).where(Exam.id == exam_id))
    db_exam = result.scalar_one_or_none()
    if not db_exam:
        raise HTTPException(status_code=404, detail="Exam not found")
    await db.delete(db_exam)
    await db.commit()
    return None
