from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from database import get_db

router = APIRouter()

from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, Text
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()


class Question(Base):
    __tablename__ = "questions"
    id = Column(Integer, primary_key=True, index=True)
    exam_id = Column(Integer)
    topic_id = Column(Integer)
    content = Column(Text)
    type = Column(String)


class Answer(Base):
    __tablename__ = "answers"
    id = Column(Integer, primary_key=True, index=True)
    question_id = Column(Integer, ForeignKey("questions.id"))
    content = Column(Text)
    is_correct = Column(Boolean)


@router.get("/questions-with-answers", response_model=list[dict])
async def get_questions_with_answers(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question))
    questions = result.scalars().all()
    if not questions:
        return []
    question_ids = [q.id for q in questions]
    result = await db.execute(
        select(Answer).where(Answer.question_id.in_(question_ids))
    )
    answers = result.scalars().all()
    from collections import defaultdict

    answer_map = defaultdict(list)
    for ans in answers:
        answer_map[ans.question_id].append(
            {"id": ans.id, "content": ans.content, "is_correct": ans.is_correct}
        )
    response = []
    for q in questions:
        q_dict = {
            "id": q.id,
            "content": q.content,
            "type": q.type,
            "answers": answer_map.get(q.id, []),
        }
        response.append(q_dict)
    return response


@router.get("/questions-with-answers/exam/{exam_id}", response_model=list[dict])
async def get_questions_with_answers_by_exam_id(
    exam_id: int, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Question).where(Question.exam_id == exam_id))
    questions = result.scalars().all()
    if not questions:
        return []
    question_ids = [q.id for q in questions]
    result = await db.execute(
        select(Answer).where(Answer.question_id.in_(question_ids))
    )
    answers = result.scalars().all()
    from collections import defaultdict

    answer_map = defaultdict(list)
    for ans in answers:
        answer_map[ans.question_id].append(
            {"id": ans.id, "content": ans.content, "is_correct": ans.is_correct}
        )
    response = []
    for q in questions:
        q_dict = {
            "id": q.id,
            "content": q.content,
            "type": q.type,
            "answers": answer_map.get(q.id, []),
        }
        response.append(q_dict)
    return response
