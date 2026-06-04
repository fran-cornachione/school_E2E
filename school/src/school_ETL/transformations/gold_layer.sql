CREATE OR REFRESH MATERIALIZED VIEW 
  school.gold.fact_student_performance
AS SELECT
  g.grade_id,
  e.student_id,
  e.course_id,
  c.course_name,
  e.teacher_id,
  e.semester_id,
  s.program_id,
  g.grade_type,
  g.score,
  g.graded_at,
  CASE WHEN
    g.score >= 60 THEN true ELSE false END AS passed
FROM
  school.silver.grades g
JOIN
  school.silver.enrollments e ON g.enrollment_id = e.enrollment_id
JOIN
  school.silver.students s ON e.student_id = s.student_id
JOIN
  school.silver.courses c ON e.course_id = c.course_id;


CREATE OR REFRESH MATERIALIZED VIEW
  school.gold.fact_payments
AS SELECT
  p.payment_id,
  p.invoice_id,
  i.student_id,
  s.program_id,
  i.fee_plan_id,
  f.academic_year,
  i.installment_number,
  i.amount_due,
  p.amount_paid,
  p.payment_date,
  i.due_date,
  datediff(p.payment_date, i.due_date) AS days_late,
  CASE WHEN 
    datediff(p.payment_date, i.due_date) > 0 THEN true ELSE false END AS is_late,
  p.payment_method,
  i.status AS invoice_status,
  p.transaction_ref
FROM
  school.silver.payments p
JOIN 
  school.silver.invoices i ON p.invoice_id = i.invoice_id
JOIN
  school.silver.students s ON i.student_id = s.student_id
JOIN
  school.silver.fee_plans f ON i.fee_plan_id = f.fee_plan_id;