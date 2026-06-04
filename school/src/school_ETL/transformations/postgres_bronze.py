from pyspark import pipelines as dp

@dp.materialized_view()
def students():
    return spark.read.table("postgres_school.public.students")

@dp.materialized_view()
def courses():
    return spark.read.table("postgres_school.public.courses")

@dp.materialized_view()
def teachers():
    return spark.read.table("postgres_school.public.teachers")

@dp.materialized_view()
def campus_access():
    return spark.read.table("postgres_school.public.campus_access")

@dp.materialized_view()
def departments():
    return spark.read.table("postgres_school.public.departments")

@dp.materialized_view()
def enrollments():
    return spark.read.table("postgres_school.public.enrollments")

@dp.materialized_view()
def fee_plans():
    return spark.read.table("postgres_school.public.fee_plans")

@dp.materialized_view()
def grades():
    return spark.read.table("postgres_school.public.grades")

@dp.materialized_view()
def invoices():
    return spark.read.table("postgres_school.public.invoices")

@dp.materialized_view()
def payments():
    return spark.read.table("postgres_school.public.payments")

@dp.materialized_view()
def programs():
    return spark.read.table("postgres_school.public.programs")

@dp.materialized_view()
def semesters():
    return spark.read.table("postgres_school.public.semesters")

@dp.materialized_view()
def specialities():
    return spark.read.table("postgres_school.public.specialities")