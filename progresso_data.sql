-- Drop tables if they exist (for clean setup)

DROP TABLE IF EXISTS submissions;

DROP TABLE IF EXISTS answers;

DROP TABLE IF EXISTS questions;

DROP TABLE IF EXISTS exams;

DROP TABLE IF EXISTS lessons;

DROP TABLE IF EXISTS topics;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS schedule;

DROP TABLE IF EXISTS quizlet;

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
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    student_attempt INTEGER DEFAULT 0,
    correct_attempt INTEGER DEFAULT 0,
    added_on DATE DEFAULT(DATE('now')),
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

-- delete all data from ...
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
        topic_id,
        rating,
        student_attempt,
        correct_attempt,
        added_on
    )
VALUES (
        'Math graduation exam 2024',
        2024,
        'Ha Noi',
        1,
        5,
        120,
        90,
        '2025-08-01'
    ),
    (
        'Geometry graduation exam 2024',
        2024,
        'Ho Chi Minh',
        2,
        4,
        100,
        70,
        '2025-08-02'
    ),
    (
        'Mock test from grade 9 to 10 (Math) 2025',
        2025,
        'Da Nang',
        1,
        3,
        80,
        50,
        '2025-08-03'
    ),
    (
        'Geometry Final 2025',
        2025,
        'Can Tho',
        2,
        5,
        60,
        55,
        '2025-08-04'
    ),
    (
        'Algebra Entrance Exam',
        2025,
        'Hai Phong',
        1,
        4,
        40,
        70,
        '2025-08-05'
    ),
    (
        'Geometry Practice Test',
        2025,
        'Hue',
        2,
        4,
        20,
        70,
        '2025-08-06'
    ),
    (
        'Algebra Mock Exam',
        2025,
        'Quang Ninh',
        1,
        3,
        25,
        55,
        '2025-08-07'
    ),
    (
        'Geometry Olympiad',
        2025,
        'Vinh',
        2,
        5,
        70,
        65,
        '2025-08-08'
    ),
    (
        'Algebra National Exam',
        2025,
        'Nam Dinh',
        1,
        5,
        200,
        100,
        '2025-08-09'
    ),
    (
        'Geometry National Exam',
        2025,
        'Bac Ninh',
        2,
        4,
        150,
        80,
        '2025-08-10'
    ),
    (
        'Algebra Semester 1',
        2025,
        'Thanh Hoa',
        1,
        3,
        60,
        68,
        '2025-08-11'
    ),
    (
        'Geometry Semester 2',
        2025,
        'Nha Trang',
        2,
        4,
        30,
        62,
        '2025-08-12'
    );

-- 10 questions for topic 1 (Toán Đại Số)

-- 10 harder, all-correct questions for exam_id 1 (Math graduation exam 2024)
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
        'Solve for x: 2x^2 - 8x + 6 = 0',
        'single'
    ),
    (
        1,
        1,
        'Which of the following are roots of the equation x^3 - 6x^2 + 11x - 6 = 0?',
        'multiple'
    ),
    (
        1,
        1,
        'If f(x) = x^2 - 4x + 7, what is the minimum value of f(x)?',
        'single'
    ),
    (
        1,
        1,
        'Which of the following matrices are invertible?',
        'multiple'
    ),
    (
        1,
        1,
        'Let A = [[1,2],[3,4]]. What is det(A)?',
        'single'
    ),
    (
        1,
        1,
        'Which of the following are solutions to the system: x + y = 5, x - y = 1?',
        'multiple'
    ),
    (
        1,
        1,
        'What is the sum of the infinite geometric series with first term 3 and ratio 1/2?',
        'single'
    ),
    (
        1,
        1,
        'Which of the following are eigenvalues of the matrix [[2,0],[0,3]]?',
        'multiple'
    ),
    (
        1,
        1,
        'If log_a(64) = 3, what is a?',
        'single'
    ),
    (
        1,
        1,
        'Which of the following are prime numbers greater than 10 and less than 20?',
        'multiple'
    );

-- 10 harder, all-correct questions for exam_id 2 (Geometry graduation exam 2024)
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
        'What is the area of a triangle with sides 13, 14, and 15?',
        'single'
    ),
    (
        2,
        2,
        'Which of the following quadrilaterals always have perpendicular diagonals?',
        'multiple'
    ),
    (
        2,
        2,
        'What is the volume of a sphere with radius 3?',
        'single'
    ),
    (
        2,
        2,
        'Which of the following are properties of a regular hexagon?',
        'multiple'
    ),
    (
        2,
        2,
        'What is the length of the diagonal of a square with side 10?',
        'single'
    ),
    (
        2,
        2,
        'Which of the following triangles are always similar?',
        'multiple'
    ),
    (
        2,
        2,
        'What is the sum of the interior angles of a decagon?',
        'single'
    ),
    (
        2,
        2,
        'Which of the following are true for all parallelograms?',
        'multiple'
    ),
    (
        2,
        2,
        'What is the radius of a circle with area 100π?',
        'single'
    ),
    (
        2,
        2,
        'Which of the following are types of conic sections?',
        'multiple'
    );

-- 10 hard questions for exam_id 3 (Mock test from grade 9 to 10 (Math) 2025)
INSERT INTO
    questions (
        exam_id,
        topic_id,
        content,
        type
    )
VALUES (
        3,
        1,
        'Solve for x: 3x^2 - 7x + 2 = 0',
        'single'
    ),
    (
        3,
        1,
        'Which of the following are solutions to the equation x^4 - 5x^2 + 4 = 0?',
        'multiple'
    ),
    (
        3,
        1,
        'If a triangle has sides 7, 8, and 9, what is its area?',
        'single'
    ),
    (
        3,
        1,
        'Which of the following numbers are irrational?',
        'multiple'
    ),
    (
        3,
        1,
        'What is the value of the expression: (2^3 * 3^2) / (6^2)?',
        'single'
    ),
    (
        3,
        1,
        'Which of the following are prime numbers less than 30?',
        'multiple'
    ),
    (
        3,
        1,
        'Find the sum of the roots of the equation x^2 - 6x + 5 = 0.',
        'single'
    ),
    (
        3,
        1,
        'Which of the following are properties of parallelograms?',
        'multiple'
    ),
    (
        3,
        1,
        'What is the smallest positive integer n such that 2^n > 1000?',
        'single'
    ),
    (
        3,
        1,
        'Which of the following are factors of x^2 - 9x + 20?',
        'multiple'
    );

-- Answers for exam_id 3 (question_id 21-30)
INSERT INTO
    answers (
        question_id,
        content,
        is_correct
    )
VALUES (21, 'x = 2/3', 1),
    (21, 'x = 1', 1),
    (21, 'x = 3', 0),
    (21, 'x = -2', 0),
    (22, 'x = 1', 1),
    (22, 'x = -1', 1),
    (22, 'x = 2', 1),
    (22, 'x = -2', 1),
    (23, 'Area ≈ 26.83', 1),
    (23, 'Area ≈ 27', 0),
    (23, 'Area ≈ 28', 0),
    (23, 'Area ≈ 25', 0),
    (24, '√2', 1),
    (24, 'π', 1),
    (24, '1/3', 0),
    (24, '0.25', 0),
    (25, '2/3', 1),
    (25, '1', 0),
    (25, '3', 0),
    (25, '4', 0),
    (26, '2', 1),
    (26, '3', 1),
    (26, '5', 1),
    (26, '7', 1),
    (27, '6', 1),
    (27, '5', 0),
    (27, '1', 0),
    (27, '11', 0),
    (
        28,
        'Opposite sides are equal',
        1
    ),
    (
        28,
        'Opposite angles are equal',
        1
    ),
    (
        28,
        'Diagonals bisect each other',
        1
    ),
    (
        28,
        'All angles are right angles',
        0
    ),
    (29, 'n = 10', 1),
    (29, 'n = 9', 0),
    (29, 'n = 8', 0),
    (29, 'n = 11', 0),
    (30, 'x - 4', 1),
    (30, 'x - 5', 1),
    (30, 'x + 4', 0),
    (30, 'x + 5', 0);

INSERT INTO
    answers (
        question_id,
        content,
        is_correct
    )
VALUES
    -- Q1: single, only one correct, others incorrect
    (1, 'x = 1 or x = 3', 1),
    (1, 'x = 1 + sqrt(2)', 0),
    (1, 'x = 2 ± sqrt(1)', 0),
    (
        1,
        'x = (4 ± sqrt(4 - 2)) / 2',
        0
    ),
    -- Q2: multiple, two correct, two incorrect
    (2, 'x = 1', 1),
    (2, 'x = 2', 1),
    (2, 'x = 3', 0),
    (2, 'All roots above', 0),
    -- Q3: single, only one correct
    (3, 'Minimum is 3 at x = 2', 1),
    (3, 'f(2) = 3', 0),
    (
        3,
        'The vertex is at (2,3)',
        0
    ),
    (3, 'Minimum value is f(2)', 0),
    -- Q4: multiple, two correct, two incorrect
    (4, '[[1,0],[0,1]]', 1),
    (4, '[[2,3],[1,4]]', 1),
    (4, '[[5,7],[2,9]]', 0),
    (
        4,
        'Any matrix with nonzero determinant',
        0
    ),
    -- Q5: single, only one correct
    (5, 'det(A) = -2', 1),
    (
        5,
        'The determinant is negative',
        0
    ),
    (5, 'A is invertible', 0),
    (
        5,
        'det([[1,2],[3,4]]) = -2',
        0
    ),
    -- Q6: multiple, two correct, two incorrect
    (6, '(3,2)', 1),
    (6, '(2,3)', 1),
    (6, '(x=3, y=2)', 0),
    (6, '(x=2, y=3)', 0),
    -- Q7: single, only one correct
    (7, 'Sum = 6', 1),
    (7, 'The series converges', 0),
    (7, 'Infinite sum is 6', 0),
    (7, 'S = 3/(1-1/2) = 6', 0),
    -- Q8: multiple, two correct, two incorrect
    (8, '2', 1),
    (8, '3', 1),
    (8, 'Both 2 and 3', 0),
    (
        8,
        'Eigenvalues are 2 and 3',
        0
    ),
    -- Q9: single, only one correct
    (9, 'a = 4', 1),
    (9, 'a^3 = 64', 0),
    (9, 'log_4(64) = 3', 0),
    (9, 'a = 64^(1/3)', 0),
    -- Q10: multiple, two correct, two incorrect
    (10, '11', 1),
    (10, '13', 1),
    (10, '17', 0),
    (10, '19', 0);

INSERT INTO
    answers (
        question_id,
        content,
        is_correct
    )
VALUES
    -- Q11: single, only one correct, others incorrect
    (11, '84', 1),
    (11, 'Area = 84', 0),
    (
        11,
        "Heron's formula gives 84",
        0
    ),
    (11, 'Triangle area is 84', 0),
    -- Q12: multiple, two correct, two incorrect
    (12, 'Rhombus', 1),
    (12, 'Square', 1),
    (12, 'Kite', 0),
    (12, 'All above', 0),
    -- Q13: single, only one correct
    (13, '36π', 1),
    (13, 'Volume = 36π', 0),
    (13, 'V = 4/3πr^3 = 36π', 0),
    (
        13,
        'Sphere with r=3 has volume 36π',
        0
    ),
    -- Q14: multiple, two correct, two incorrect
    (14, 'All sides equal', 1),
    (14, 'Interior angles 120°', 1),
    (14, '6 axes of symmetry', 0),
    (
        14,
        'Can be divided into 6 equilateral triangles',
        0
    ),
    -- Q15: single, only one correct
    (15, '10√2', 1),
    (15, 'Diagonal = 10√2', 0),
    (15, 'd = s√2 = 10√2', 0),
    (
        15,
        'Square diagonal is 10√2',
        0
    ),
    -- Q16: multiple, two correct, two incorrect
    (
        16,
        'All equilateral triangles',
        1
    ),
    (
        16,
        'All right triangles with equal angles',
        1
    ),
    (
        16,
        'All isosceles right triangles',
        0
    ),
    (
        16,
        'All similar triangles',
        0
    ),
    -- Q17: single, only one correct
    (17, '1440°', 1),
    (17, 'Sum = 1440°', 0),
    (
        17,
        'Interior angles add to 1440°',
        0
    ),
    (17, 'Decagon sum is 1440°', 0),
    -- Q18: multiple, two correct, two incorrect
    (18, 'Opposite sides equal', 1),
    (
        18,
        'Opposite angles equal',
        1
    ),
    (
        18,
        'Diagonals bisect each other',
        0
    ),
    (
        18,
        'Sum of angles is 360°',
        0
    ),
    -- Q19: single, only one correct
    (19, '10', 1),
    (19, 'Radius = 10', 0),
    (19, 'Area = πr^2, r = 10', 0),
    (
        19,
        'Circle with area 100π has r = 10',
        0
    ),
    -- Q20: multiple, two correct, two incorrect
    (20, 'Circle', 1),
    (20, 'Ellipse', 1),
    (20, 'Parabola', 0),
    (20, 'Hyperbola', 0);

INSERT INTO
    submissions (
        user_id,
        exam_id,
        grade,
        feedback
    )
VALUES (1, 1, 9.0, 'Làm tốt!'),
    (
        2,
        2,
        8.5,
        'Cần chú ý trình bày.'
    );