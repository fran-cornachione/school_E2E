from pyspark import pipelines as dp

S3_PATH = "s3://school-s3-databricks/csv/"

def ingest_cloud_csv(folder_name):
    "Main function to load files as Delta tables from S3"
    return (
        spark.read
            .format("csv")
            .option("inferColumnTypes", "true")
            .option("header", "true")
            .load(f"{S3_PATH}{folder_name}")
    )

@dp.table
def historical_grades():
    return (
        spark.readStream
            .format("cloudFiles")
            .option("mode", "append")
            .option("cloudFiles.format", "csv")
            .option("cloudFiles.inferColumnTypes", "true")
            .option("header", "true")
            .load(f"{S3_PATH}/historical_grades") # Folder, not file
    )

@dp.table
def teacher_certifications():
    return ingest_cloud_csv("teacher_certifications")