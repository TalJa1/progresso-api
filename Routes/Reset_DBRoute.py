from fastapi import APIRouter, HTTPException
import sqlite3
import os

router = APIRouter()

SQL_PATH = os.path.join(
    os.path.dirname(os.path.dirname(__file__)), "progresso_data.sql"
)
DB_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), "storage.db")


@router.post("/reset-db")
def reset_db():
    try:
        with open(SQL_PATH, "r", encoding="utf-8") as f:
            sql_script = f.read()
        conn = sqlite3.connect(DB_PATH)
        try:
            conn.executescript(sql_script)
            conn.commit()
        finally:
            conn.close()
        return {"message": "Database reset successfully."}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database reset failed: {e}")
