CREATE OR REPLACE MATERIALIZED VIEW
    silver.students 
(
    CONSTRAINT valid_email EXPECT (email RLIKE '^[^@]+@[^@]+\.[^@]+')
)
AS 
SELECT
    student_id,
    initcap(first_name) AS first_name,
    initcap(last_name) AS last_name,
    birth_date,
    CAST(program_id AS INT) AS program_id,
    REPLACE(lower(email), ' ', '') AS email,
    enrollment_date,
    CASE
        WHEN status IN ('Active', 'ACTIVE') THEN 'active'
    ELSE status
    END AS
        status
FROM
    bronze.students;

CREATE OR REPLACE MATERIALIZED VIEW 
    silver.enrollments
(
    CONSTRAINT valid_status EXPECT (status IN ('active', 'completed', 'failed', 'dropped'))
)
AS
SELECT
    enrollment_id,
    student_id,
    course_id,
    teacher_id,
    semester_id,
    enrolled_at,
    status
FROM
    bronze.enrollments;

CREATE OR REPLACE MATERIALIZED VIEW 
    silver.grades
(
  CONSTRAINT valid_score EXPECT (score BETWEEN 0 AND 100) ON VIOLATION DROP ROW
)
AS
SELECT 
    grade_id, 
    enrollment_id, 
    grade_type, 
    score, 
    CAST(graded_at AS DATE) AS graded_at,
    'current' AS source
FROM bronze.grades

UNION ALL

SELECT 
    grade_id, 
    enrollment_id, 
    grade_type, 
    score, 
    CAST(graded_at AS DATE) AS graded_at,
    'historical' AS source
FROM bronze.historical_grades;

CREATE OR REPLACE MATERIALIZED VIEW 
    silver.payments
(
 CONSTRAINT valid_amount EXPECT (amount_paid > 0) ON VIOLATION DROP ROW
)
AS 
SELECT
    payment_id,
    invoice_id,
    amount_paid,
    CAST(payment_date AS DATE) AS payment_date,
    payment_method,
    transaction_ref
FROM
    bronze.payments;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.invoices
AS
SELECT
    invoice_id,
    student_id,
    fee_plan_id,
    installment_number,
    amount_due,
    CAST(due_date AS DATE) AS due_date,
    status
FROM
    bronze.invoices;

CREATE OR REPLACE MATERIALIZED VIEW 
    silver.teachers
AS
SELECT
    *
FROM
    bronze.teachers;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.campus_access
AS
SELECT
    *
FROM 
    bronze.campus_access;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.departments
AS SELECT 
    CAST(department_id AS INT) AS department_id,
    dept_name,
    faculty
FROM 
    bronze.departments;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.programs
AS SELECT
    *
FROM
    bronze.programs;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.specialities
AS SELECT
    specialty
FROM
    bronze.specialities;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.courses
AS SELECT
    * 
FROM bronze.courses;

CREATE OR REPLACE MATERIALIZED VIEW 
    silver.fee_plans
AS SELECT
    *
FROM
    bronze.fee_plans;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.semesters
AS SELECT
    semester_id,
    label,
    CAST(start_date AS DATE) AS start_date,
    CAST(end_date AS DATE) AS end_date,
    CAST(is_active AS BOOLEAN) AS is_active
FROM 
    bronze.semesters;

CREATE OR REPLACE MATERIALIZED VIEW
    silver.teacher_certifications
(
    CONSTRAINT not_expired EXPECT (expiry_date >= current_date)
)
AS SELECT
    teacher_email,
    certification_name,
    issuing_organization,
    issue_date,
    expiry_date,
    CASE
        WHEN expiry_date < current_date THEN true
        ELSE false
    END AS is_expired,
    level
FROM
    bronze.teacher_certifications;