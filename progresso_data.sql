-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS progress;

DROP TABLE IF EXISTS submissions;

DROP TABLE IF EXISTS answers;

DROP TABLE IF EXISTS questions;

DROP TABLE IF EXISTS exams;

DROP TABLE IF EXISTS lessons;

DROP TABLE IF EXISTS topics;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS schedule;

DROP TABLE IF EXISTS lessons_completed;
-- User Management
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    class TEXT,
    school TEXT
);

-- Topics (Chuyên đề)
CREATE TABLE IF NOT EXISTS topics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Lessons (Bài học theo chuyên đề)
CREATE TABLE IF NOT EXISTS lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    video_url TEXT,
    FOREIGN KEY (topic_id) REFERENCES topics (id)
);

-- Exams (Đề thi)
CREATE TABLE IF NOT EXISTS exams (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    year INTEGER,
    province TEXT,
    topic_id INTEGER,
    FOREIGN KEY (topic_id) REFERENCES topics (id)
);

-- Questions (Câu hỏi)
CREATE TABLE IF NOT EXISTS questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    exam_id INTEGER NOT NULL,
    topic_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    type TEXT NOT NULL CHECK (
        type IN ('single', 'multiple')
    ),
    FOREIGN KEY (exam_id) REFERENCES exams (id),
    FOREIGN KEY (topic_id) REFERENCES topics (id)
);

-- Answers (Đáp án)
CREATE TABLE IF NOT EXISTS answers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    question_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions (id)
);

-- Submissions (Nộp bài viết tay, chấm bài tự động)
CREATE TABLE IF NOT EXISTS submissions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    exam_id INTEGER NOT NULL,
    image_url TEXT,
    upload_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    grade REAL,
    feedback TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (exam_id) REFERENCES exams (id)
);

-- Progress Tracking (Tiến độ & Báo cáo học tập)
CREATE TABLE IF NOT EXISTS progress (
    user_id INTEGER NOT NULL,
    lesson_id INTEGER,
    exam_id INTEGER,
    completed BOOLEAN NOT NULL DEFAULT 0,
    score REAL,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (lesson_id) REFERENCES lessons (id),
    FOREIGN KEY (exam_id) REFERENCES exams (id)
);

-- Schedule (Lịch trình cá nhân)
CREATE TABLE IF NOT EXISTS schedule (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    type TEXT,
    event_date DATE NOT NULL,
    start_time TIME,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Lessons Completed (Bài học đã hoàn thành)
CREATE TABLE IF NOT EXISTS lessons_completed (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    lesson_id INTEGER NOT NULL,
    completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (lesson_id) REFERENCES lessons (id)
);

-- Sample Data
INSERT INTO
    users (
        email,
        full_name,
        avatar_url,
        class,
        school
    )
VALUES (
        'student1@gmail.com',
        'Nguyen Van A',
        'https://avatar.com/a.jpg',
        '10A1',
        'THPT Le Quy Don'
    ),
    (
        'student2@gmail.com',
        'Tran Thi B',
        'https://avatar.com/b.jpg',
        '11B2',
        'THPT Tran Phu'
    );

INSERT INTO
    topics (name, description)
VALUES (
        'Toán Đại Số',
        'Chuyên đề về đại số'
    ),
    (
        'Toán Hình Học',
        'Chuyên đề về hình học'
    );

INSERT INTO
    lessons (
        topic_id,
        title,
        content,
        video_url
    )
VALUES (
        1,
        'Phương trình bậc nhất',
        'Nội dung về phương trình bậc nhất',
        'https://video1.com'
    ),
    (
        2,
        'Hình tam giác',
        'Nội dung về hình tam giác',
        'https://video2.com'
    );

INSERT INTO
    exams (
        name,
        year,
        province,
        topic_id
    )
VALUES (
        'Đề thi Toán 2024',
        2024,
        'Hà Nội',
        1
    ),
    (
        'Đề thi Hình học 2024',
        2024,
        'Hồ Chí Minh',
        2
    );

-- 10 questions for topic 1 (Toán Đại Số)
INSERT INTO
    questions (
        exam_id,
        topic_id,
        content,
        type
    )
VALUES (
        1,
        1,
        'Giá trị của x trong phương trình x + 2 = 5 là?',
        'single'
    ),
    (
        1,
        1,
        'Chọn các số là nghiệm của phương trình x^2 - 4 = 0',
        'multiple'
    ),
    (
        1,
        1,
        'Kết quả của 2 + 2 là?',
        'single'
    ),
    (
        1,
        1,
        'Nghiệm của phương trình x^2 = 9 là?',
        'multiple'
    ),
    (
        1,
        1,
        'Tổng của 5 và 7 là?',
        'single'
    ),
    (
        1,
        1,
        'Chọn các số chia hết cho 3: 3, 4, 6, 7',
        'multiple'
    ),
    (
        1,
        1,
        'Kết quả của 10 - 4 là?',
        'single'
    ),
    (
        1,
        1,
        'Chọn các số nguyên tố: 2, 3, 4, 5',
        'multiple'
    ),
    (
        1,
        1,
        'Tích của 3 và 5 là?',
        'single'
    ),
    (
        1,
        1,
        'Chọn các số là bội của 2: 2, 3, 4, 5',
        'multiple'
    );

-- 10 questions for topic 2 (Toán Hình Học)
INSERT INTO
    questions (
        exam_id,
        topic_id,
        content,
        type
    )
VALUES (
        2,
        2,
        'Tổng các góc trong một tam giác là bao nhiêu độ?',
        'single'
    ),
    (
        2,
        2,
        'Chọn các hình có ba cạnh: tam giác, tứ giác, ngũ giác, lục giác',
        'multiple'
    ),
    (
        2,
        2,
        'Số cạnh của hình vuông là?',
        'single'
    ),
    (
        2,
        2,
        'Chọn các hình có bốn cạnh: hình vuông, hình chữ nhật, tam giác, ngũ giác',
        'multiple'
    ),
    (
        2,
        2,
        'Số góc vuông trong hình chữ nhật là?',
        'single'
    ),
    (
        2,
        2,
        'Chọn các hình có tất cả các cạnh bằng nhau: hình vuông, hình chữ nhật, tam giác đều, hình thoi',
        'multiple'
    ),
    (
        2,
        2,
        'Số cạnh của hình lục giác là?',
        'single'
    ),
    (
        2,
        2,
        'Chọn các hình có góc nhọn: tam giác, hình vuông, hình chữ nhật, ngũ giác',
        'multiple'
    ),
    (
        2,
        2,
        'Số cạnh của hình ngũ giác là?',
        'single'
    ),
    (
        2,
        2,
        'Chọn các hình có ít nhất một góc vuông: hình vuông, tam giác vuông, hình tròn, hình thoi',
        'multiple'
    );

-- Answers for topic 1 questions (IDs 1-10)
INSERT INTO
    answers (
        question_id,
        content,
        is_correct
    )
VALUES (1, '3', 1),
    (1, '2', 0),
    (1, '5', 0),
    (1, '0', 0),
    (2, '-2', 1),
    (2, '2', 1),
    (2, '0', 0),
    (2, '3', 0),
    (3, '4', 1),
    (3, '2', 0),
    (3, '3', 0),
    (3, '5', 0),
    (4, '3', 1),
    (4, '-3', 1),
    (4, '0', 0),
    (4, '6', 0),
    (5, '12', 1),
    (5, '10', 0),
    (5, '7', 0),
    (5, '5', 0),
    (6, '3', 1),
    (6, '6', 1),
    (6, '4', 0),
    (6, '7', 0),
    (7, '6', 1),
    (7, '4', 0),
    (7, '10', 0),
    (7, '5', 0),
    (8, '2', 1),
    (8, '3', 1),
    (8, '4', 0),
    (8, '5', 0),
    (9, '15', 1),
    (9, '8', 0),
    (9, '10', 0),
    (9, '5', 0),
    (10, '2', 1),
    (10, '4', 1),
    (10, '3', 0),
    (10, '5', 0);

-- Answers for topic 2 questions (IDs 11-20)
INSERT INTO
    answers (
        question_id,
        content,
        is_correct
    )
VALUES (11, '180', 1),
    (11, '90', 0),
    (11, '360', 0),
    (11, '120', 0),
    (12, 'tam giác', 1),
    (12, 'tứ giác', 0),
    (12, 'ngũ giác', 0),
    (12, 'lục giác', 0),
    (13, '4', 1),
    (13, '3', 0),
    (13, '5', 0),
    (13, '6', 0),
    (14, 'hình vuông', 1),
    (14, 'hình chữ nhật', 1),
    (14, 'tam giác', 0),
    (14, 'ngũ giác', 0),
    (15, '4', 1),
    (15, '2', 0),
    (15, '3', 0),
    (15, '1', 0),
    (16, 'hình vuông', 1),
    (16, 'tam giác đều', 1),
    (16, 'hình chữ nhật', 0),
    (16, 'hình thoi', 0),
    (17, '6', 1),
    (17, '5', 0),
    (17, '4', 0),
    (17, '3', 0),
    (18, 'tam giác', 1),
    (18, 'ngũ giác', 1),
    (18, 'hình vuông', 0),
    (18, 'hình chữ nhật', 0),
    (19, '5', 1),
    (19, '4', 0),
    (19, '3', 0),
    (19, '6', 0),
    (20, 'hình vuông', 1),
    (20, 'tam giác vuông', 1),
    (20, 'hình tròn', 0),
    (20, 'hình thoi', 0);

INSERT INTO
    submissions (
        user_id,
        exam_id,
        image_url,
        grade,
        feedback
    )
VALUES (
        1,
        1,
        'https://img.com/bailam1.jpg',
        9.0,
        'Làm tốt!'
    ),
    (
        2,
        2,
        'https://img.com/bailam2.jpg',
        8.5,
        'Cần chú ý trình bày.'
    );

INSERT INTO
    progress (
        user_id,
        lesson_id,
        exam_id,
        completed,
        score,
        completed_at
    )
VALUES (
        1,
        1,
        NULL,
        1,
        NULL,
        '2025-08-01 10:00:00'
    ),
    (
        1,
        NULL,
        1,
        1,
        9.0,
        '2025-08-02 15:00:00'
    ),
    (
        2,
        2,
        NULL,
        1,
        NULL,
        '2025-08-01 11:00:00'
    ),
    (
        2,
        NULL,
        2,
        1,
        8.5,
        '2025-08-03 16:00:00'
    );