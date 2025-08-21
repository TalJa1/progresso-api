from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional, List
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete
from sqlalchemy.exc import IntegrityError
from sqlalchemy import Column, Integer, DateTime
from database import get_db, Base
import datetime

router = APIRouter()


class SubmissionRecord(Base):
    __tablename__ = "submission_record"
    id = Column(Integer, primary_key=True, index=True)
    submission_id = Column(Integer, nullable=False)
    user_id = Column(Integer, nullable=False)
    question_id = Column(Integer, nullable=False)
    chosen_answer_id = Column(Integer, nullable=False)


class SubmissionRecordCreate(BaseModel):
    submission_id: int
    user_id: int
    question_id: int
    chosen_answer_id: int


class SubmissionRecordUpdate(BaseModel):
    chosen_answer_id: int


class SubmissionRecordOut(BaseModel):
    id: int
    submission_id: int
    user_id: int
    question_id: int
    chosen_answer_id: int

    class Config:
        orm_mode = True


@router.post(
    "/submission_record",
    response_model=SubmissionRecordOut,
    status_code=status.HTTP_201_CREATED,
)
async def create_submission_record(
    payload: SubmissionRecordCreate, db: AsyncSession = Depends(get_db)
):
    rec = SubmissionRecord(
        submission_id=payload.submission_id,
        user_id=payload.user_id,
        question_id=payload.question_id,
        chosen_answer_id=payload.chosen_answer_id,
    )
    db.add(rec)
    await db.commit()
    await db.refresh(rec)
    return rec


@router.post(
    "/submission_record/batch",
    response_model=List[SubmissionRecordOut],
    status_code=status.HTTP_201_CREATED,
)
async def create_submission_record_batch(
    payload: List[SubmissionRecordCreate], db: AsyncSession = Depends(get_db)
):
    if not payload:
        return []
    created = []
    updated = []

    async with db.begin():
        for item in payload:
            # check if a record for this submission+question already exists
            res = await db.execute(
                select(SubmissionRecord).where(
                    SubmissionRecord.submission_id == item.submission_id,
                    SubmissionRecord.question_id == item.question_id,
                )
            )
            existing = res.scalars().first()
            if existing:
                # ensure the existing row belongs to same user
                if existing.user_id != item.user_id:
                    raise HTTPException(
                        status_code=400,
                        detail=f"user_id mismatch for submission_id={item.submission_id} question_id={item.question_id}",
                    )
                # update chosen answer for existing record
                existing.chosen_answer_id = item.chosen_answer_id
                updated.append(existing)
            else:
                rec = SubmissionRecord(
                    submission_id=item.submission_id,
                    user_id=item.user_id,
                    question_id=item.question_id,
                    chosen_answer_id=item.chosen_answer_id,
                )
                db.add(rec)
                await db.flush()  # ensure rec.id is populated
                created.append(rec)

    # refresh all affected instances and return them
    for r in created + updated:
        await db.refresh(r)

    return created + updated


@router.get("/submission_record", response_model=List[SubmissionRecordOut])
async def list_submission_records(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SubmissionRecord))
    rows = result.scalars().all()
    return rows


@router.get("/submission_record/{rec_id}", response_model=SubmissionRecordOut)
async def get_submission_record(rec_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(SubmissionRecord).where(SubmissionRecord.id == rec_id)
    )
    rec = result.scalars().first()
    if not rec:
        raise HTTPException(status_code=404, detail="SubmissionRecord not found")
    return rec


@router.put("/submission_record/{rec_id}", response_model=SubmissionRecordOut)
async def update_submission_record(
    rec_id: int, payload: SubmissionRecordUpdate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(SubmissionRecord).where(SubmissionRecord.id == rec_id)
    )
    rec = result.scalars().first()
    if not rec:
        raise HTTPException(status_code=404, detail="SubmissionRecord not found")
    rec.chosen_answer_id = payload.chosen_answer_id
    await db.commit()
    await db.refresh(rec)
    return rec


@router.delete("/submission_record/{rec_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_submission_record(rec_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(SubmissionRecord).where(SubmissionRecord.id == rec_id)
    )
    rec = result.scalars().first()
    if not rec:
        raise HTTPException(status_code=404, detail="SubmissionRecord not found")
    await db.delete(rec)
    await db.commit()
    return None
