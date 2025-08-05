-- enable foreign keys
PRAGMA foreign_keys = ON;

-- USERS
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    google_id TEXT UNIQUE,
    email TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    class TEXT,
    school TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TOPICS (chuyên đề)
CREATE TABLE topics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- LESSONS (bài học theo chuyên đề)
CREATE TABLE lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    video_url TEXT,
    lesson_order INTEGER,
    FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
);

-- EXAM PAPERS (đề thi)
CREATE TABLE exam_papers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    year INTEGER,
    province TEXT,
    topic_id INTEGER,
    pdf_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (topic_id) REFERENCES topics (id)
);

-- QUESTIONS (câu hỏi trong đề)
CREATE TABLE questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    exam_paper_id INTEGER NOT NULL,
    question_number INTEGER NOT NULL,
    text TEXT,
    max_score REAL,
    model_answer TEXT,
    FOREIGN KEY (exam_paper_id) REFERENCES exam_papers (id) ON DELETE CASCADE
);

-- SUBMISSIONS (bài làm của học sinh)
CREATE TABLE submissions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    exam_paper_id INTEGER NOT NULL,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK (
        status IN ('pending', 'graded', 'error')
    ) DEFAULT 'pending',
    total_score REAL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (exam_paper_id) REFERENCES exam_papers (id)
);

-- UPLOADED IMAGES for each submission
CREATE TABLE submission_images (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    submission_id INTEGER NOT NULL,
    image_path TEXT NOT NULL,
    FOREIGN KEY (submission_id) REFERENCES submissions (id) ON DELETE CASCADE
);

-- PER-QUESTION DETAILS of a submission
CREATE TABLE submission_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    submission_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    student_answer TEXT,
    feedback TEXT,
    score REAL,
    FOREIGN KEY (submission_id) REFERENCES submissions (id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions (id)
);

-- USER-TOPIC PROGRESS (thống kê theo chuyên đề)
CREATE TABLE user_topic_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    topic_id INTEGER NOT NULL,
    total_exams INTEGER DEFAULT 0,
    average_score REAL,
    proficiency_level TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (topic_id) REFERENCES topics (id)
);

-- NOTIFICATIONS (nhắc khi lâu không luyện)
CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    type TEXT,
    content TEXT,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- AI CHAT SESSIONS & MESSAGES
CREATE TABLE chat_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE chat_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    is_user INTEGER NOT NULL CHECK (is_user IN (0, 1)),
    message TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES chat_sessions (id) ON DELETE CASCADE
);

-- SUGGESTIONS (gợi ý ôn tập hoặc bài tiếp theo)
CREATE TABLE suggestions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    suggestion_type TEXT,
    topic_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (topic_id) REFERENCES topics (id)
);

-- ───────────────────────────────────────────────────────────────────────────
-- Sample data
-- ───────────────────────────────────────────────────────────────────────────

INSERT INTO
    users (
        google_id,
        email,
        full_name,
        avatar_url,
        class,
        school
    )
VALUES (
        'google-uid-123',
        'student1@gmail.com',
        'Nguyễn Văn A',
        'https://lh3.googleusercontent.com/a/default-avatar',
        '12A1',
        'THPT Chuyên Khoa'
    );

-- 2 topics
INSERT INTO
    topics (name, description)
VALUES (
        'Đại số',
        'Phương trình, bất phương trình, logarit…'
    ),
    (
        'Hình học',
        'Tứ giác, tam giác, đường thẳng, đường tròn…'
    );

-- 3 lessons
INSERT INTO
    lessons (
        topic_id,
        title,
        content,
        video_url,
        lesson_order
    )
VALUES (
        1,
        'Phương trình bậc hai',
        'Giới thiệu phương trình bậc hai…',
        'https://youtu.be/abc123',
        1
    ),
    (
        1,
        'Bất phương trình',
        'Phương pháp giải bất phương trình…',
        'https://youtu.be/def456',
        2
    ),
    (
        2,
        'Đường thẳng trong mặt phẳng',
        'Định nghĩa, hệ số góc…',
        'https://youtu.be/ghi789',
        1
    );

-- 2 exam papers
INSERT INTO
    exam_papers (
        title,
        year,
        province,
        topic_id,
        pdf_url
    )
VALUES (
        'Đề thi thử 2024',
        '2024',
        'Hà Nội',
        1,
        'http://example.com/de1.pdf'
    ),
    (
        'Đề thi thử 2023',
        '2023',
        'Hồ Chí Minh',
        2,
        'http://example.com/de2.pdf'
    );

-- questions for paper #1
INSERT INTO
    questions (
        exam_paper_id,
        question_number,
        text,
        max_score,
        model_answer
    )
VALUES (
        1,
        1,
        'Giải phương trình x^2 - 5x + 6 = 0',
        2.0,
        'x=2 hoặc x=3'
    ),
    (
        1,
        2,
        'Rút gọn biểu thức A = (x^2-1)/(x-1)',
        1.0,
        'A = x+1'
    );

-- one graded submission
INSERT INTO
    submissions (
        user_id,
        exam_paper_id,
        status,
        total_score
    )
VALUES (1, 1, 'graded', 1.5);

-- link an image
INSERT INTO
    submission_images (submission_id, image_path)
VALUES (
        1,
        '/uploads/student1/sub1_q1.jpg'
    );

-- details per question
INSERT INTO
    submission_details (
        submission_id,
        question_id,
        student_answer,
        feedback,
        score
    )
VALUES (
        1,
        1,
        'x=2 và x=4',
        'Sai ở nghiệm x=4, đúng là x=3',
        1.0
    ),
    (1, 2, 'x+1', 'Đúng', '0.5');

-- update progress for topic 1
INSERT INTO
    user_topic_progress (
        user_id,
        topic_id,
        total_exams,
        average_score,
        proficiency_level
    )
VALUES (1, 1, 1, 1.5, 'Khá');

-- a notification reminder
INSERT INTO
    notifications (user_id, type, content)
VALUES (
        1,
        'reminder',
        'Bạn lâu không luyện đề, hãy tiếp tục ôn tập!'
    );

-- start an AI chat session
INSERT INTO chat_sessions (user_id) VALUES (1);

-- two chat messages
INSERT INTO
    chat_messages (session_id, is_user, message)
VALUES (
        1,
        1,
        'Giải thích bước 1 câu 1'
    ),
    (
        1,
        0,
        'Bước 1: Áp dụng công thức nghiệm của phương trình bậc hai…'
    );

-- a review suggestion
INSERT INTO
    suggestions (
        user_id,
        suggestion_type,
        topic_id
    )
VALUES (1, 'review_topic', 1);