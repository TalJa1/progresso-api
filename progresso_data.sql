-- Drop tables if they exist (for clean setup)

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
    school TEXT,
    self_description TEXT DEFAULT ""
);

-- Topics (Chuyên đề)
CREATE TABLE IF NOT EXISTS topics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    video_url TEXT,
    short_describe TEXT,
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

-- Quizlet Table (Flashcards for each lesson)
CREATE TABLE IF NOT EXISTS quizlet (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    FOREIGN KEY (lesson_id) REFERENCES lessons (id)
);

-- delete lessons_completed all data
-- DELETE FROM lessons_completed;
-- DELETE FROM quizlet;

INSERT INTO
    quizlet (lesson_id, question, answer)
VALUES (
        1,
        'What is a system of linear equations?',
        'A set of two or more linear equations with the same variables.'
    ),
    (
        1,
        'What is the graphical method for solving systems?',
        'Plot each equation and find the intersection point.'
    ),
    (
        1,
        'What does it mean if two lines are parallel in a system?',
        'There is no solution.'
    ),
    (
        1,
        'What is the elimination method?',
        'Add or subtract equations to eliminate a variable.'
    ),
    (
        1,
        'What is the solution to the system: x + y = 4, x - y = 2?',
        'x = 3, y = 1'
    );

INSERT INTO
    quizlet (lesson_id, question, answer)
VALUES (
        2,
        'What does the Inscribed Angle Theorem state?',
        'An inscribed angle is half the measure of the central angle subtending the same arc.'
    ),
    (
        2,
        'What is the inscribed angle if the central angle is 80°?',
        '40°'
    ),
    (
        2,
        'What is the inscribed angle if it subtends a diameter?',
        '90°'
    ),
    (
        2,
        'Are all inscribed angles subtending the same arc equal?',
        'Yes'
    ),
    (
        2,
        'What is a key application of the inscribed angle theorem?',
        'Proving properties of cyclic quadrilaterals.'
    );

INSERT INTO
    quizlet (lesson_id, question, answer)
VALUES (
        3,
        'What is the general form of a quadratic equation?',
        'ax^2 + bx + c = 0'
    ),
    (
        3,
        'What is the quadratic formula?',
        'x = [-b ± sqrt(b^2 - 4ac)] / (2a)'
    ),
    (
        3,
        'What does the discriminant determine?',
        'The number and type of solutions.'
    ),
    (
        3,
        'What is factoring?',
        'Writing a quadratic as a product of two binomials.'
    ),
    (
        3,
        'What is the solution to x^2 - 4 = 0?',
        'x = 2 or x = -2'
    );

INSERT INTO
    quizlet (lesson_id, question, answer)
VALUES (
        4,
        'What is a polynomial?',
        'An expression of variables and coefficients.'
    ),
    (
        4,
        'What is factoring?',
        'Writing a polynomial as a product of its factors.'
    ),
    (
        4,
        'What is the factored form of x^2 - 5x + 6?',
        '(x - 2)(x - 3)'
    ),
    (
        4,
        'What is the degree of a polynomial?',
        'The highest power of the variable.'
    ),
    (
        4,
        'Why is factoring useful?',
        'It helps solve equations and simplify expressions.'
    );

INSERT INTO
    quizlet (lesson_id, question, answer)
VALUES (
        5,
        'What is the formula for the circumference of a circle?',
        'C = 2πr'
    ),
    (
        5,
        'What is the formula for the area of a circle?',
        'A = πr^2'
    ),
    (
        5,
        'What is a radius?',
        'A line from the center to any point on the circle.'
    ),
    (
        5,
        'What is a diameter?',
        'A line passing through the center, touching two points on the circle.'
    ),
    (
        5,
        'What is a chord?',
        'A line segment joining two points on a circle.'
    );

INSERT INTO
    quizlet (lesson_id, question, answer)
VALUES (
        6,
        'What is a triangle?',
        'A polygon with three sides.'
    ),
    (
        6,
        'What is the sum of the interior angles of a triangle?',
        '180°'
    ),
    (
        6,
        'What is an equilateral triangle?',
        'A triangle with all sides equal.'
    ),
    (
        6,
        'What is a right triangle?',
        'A triangle with one 90° angle.'
    ),
    (
        6,
        'What is a scalene triangle?',
        'A triangle with all sides of different lengths.'
    );

INSERT INTO
    users (
        email,
        full_name,
        avatar_url,
        class,
        school,
        self_description
    )
VALUES (
        'student1@gmail.com',
        'Nguyen Van A',
        'https://avatar.com/a.jpg',
        '10A1',
        'THPT Le Quy Don',
        ''
    ),
    (
        'student2@gmail.com',
        'Tran Thi B',
        'https://avatar.com/b.jpg',
        '11B2',
        'THPT Tran Phu',
        ''
    );

INSERT INTO
    topics (name, description)
VALUES (
        'Algebra',
        'Explore the fundamental concepts of algebra, including equations, inequalities, and systems of equations.'
    ),
    (
        'Geometry',
        'Study the properties and relationships of shapes, angles, and figures, with a focus on circles and polygons.'
    );

INSERT INTO
    lessons (
        topic_id,
        title,
        content,
        video_url,
        short_describe
    )
VALUES (
        1,
        'System of Linear Equations',
        '# System of Linear Equations\n\nA **system of linear equations** consists of two or more linear equations with the same set of variables. The goal is to find values for the variables that satisfy all equations at once.\n\nA linear equation has the form `ax + by + c = 0`, where `a`, `b`, and `c` are constants. For example:\n\n```\n2x + 3y = 6\nx - y = 2\n```\n\n**Methods to solve systems:**\n- **Graphical:** Plot each equation as a line; the intersection point(s) are solutions.\n- **Substitution:** Solve one equation for a variable, substitute into the other.\n- **Elimination:** Add/subtract equations to eliminate a variable.\n- **Matrix:** Use matrices (e.g., Gaussian elimination) for larger systems.\n\n**Types of solutions:**\n- **Unique solution:** Lines intersect at one point.\n- **Infinite solutions:** Lines overlap.\n- **No solution:** Lines are parallel.\n\nSystems of linear equations are used in science, engineering, economics, and more.\n',
        'https://res.cloudinary.com/dyhnzac8w/video/upload/v1754558644/System_Of_Linear_Equations_efgzsw.mp4',
        'Learn how to solve systems of equations and understand their applications.'
    ),
    (
        2,
        'Inscribed Angle Theorem',
        '# Inscribed Angle Theorem\n\nThe **Inscribed Angle Theorem** states that an angle inscribed in a circle is half the measure of the central angle that subtends the same arc.\n\nIf `A`, `B`, and `C` are points on a circle, and angle `ABC` is inscribed, then:\n\n```\nAngle ABC = 1/2 × Central Angle (AOC)\n```\n\n**Key facts:**\n- All inscribed angles subtending the same arc are equal.\n- The measure of an inscribed angle is always half the measure of the corresponding central angle.\n- If the inscribed angle subtends a diameter, it is a right angle (90°).\n\n**Applications:**\n- Proving properties of cyclic quadrilaterals.\n- Solving geometric problems involving circles.\n\nThis theorem is fundamental in circle geometry and is widely used in mathematics competitions and proofs.\n',
        'https://res.cloudinary.com/dyhnzac8w/video/upload/v1754558637/Inscribed_Angle_Theorem_fzpckg.mp4',
        'Discover the relationship between inscribed angles and arcs in a circle.'
    ),
    (
        1,
        'Quadratic Equations',
        '# Quadratic Equations\n\nA quadratic equation is an equation of the form `ax^2 + bx + c = 0`. Solutions can be found using factoring, completing the square, or the quadratic formula.\n\n**Quadratic Formula:**\n\n```\nx = [-b ± sqrt(b^2 - 4ac)] / (2a)\n```\n\nQuadratic equations are fundamental in algebra and appear in many real-world problems.\n',
        '',
        'Understand how to solve quadratic equations and apply the quadratic formula.'
    ),
    (
        1,
        'Polynomials and Factoring',
        '# Polynomials and Factoring\n\nPolynomials are expressions consisting of variables and coefficients. Factoring is the process of writing a polynomial as a product of its factors.\n\n**Example:**\n\n```\nx^2 - 5x + 6 = (x - 2)(x - 3)\n```\n\nFactoring helps solve equations and simplify expressions in algebra.\n',
        '',
        'Learn about polynomials and how to factor them.'
    ),
    (
        2,
        'Properties of Circles',
        '# Properties of Circles\n\nA circle is a set of points equidistant from a center. Key properties include radius, diameter, circumference, and area.\n\n**Formulas:**\n- Circumference: `C = 2πr`\n- Area: `A = πr^2`\n\nUnderstanding these properties is essential for solving geometric problems.\n',
        '',
        'Explore the basic properties and formulas of circles.'
    ),
    (
        2,
        'Triangles and Their Types',
        '# Triangles and Their Types\n\nTriangles are polygons with three sides. Types include equilateral, isosceles, and scalene.\n\n**Key facts:**\n- The sum of interior angles is always 180°.\n- Right triangles have one 90° angle.\n\nTriangles are foundational in geometry and trigonometry.\n',
        '',
        'Learn about different types of triangles and their properties.'
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