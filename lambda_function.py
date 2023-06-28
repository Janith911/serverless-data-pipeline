import csv
import boto3
import os


dynamodb_client = boto3.client('dynamodb',region_name=os.environ["REGION"])
dynamodb = boto3.resource('dynamodb',region_name=os.environ["REGION"])
table = dynamodb.Table(os.environ["TABLE"])

array_of_dict = [{}]

def OpenCSVFile(csvContent):
    try:
        csvreader = csv.DictReader(csvContent)
        return csvreader
    except:
        print("An ERROR Occured")

def GeneratePayload(csvreader):
    for row in csvreader:
        row["ID"] = int(row["ID"])
        array_of_dict.append(row)

def WriteBatch(array_of_dict):
    array_of_dict.pop(0)
    with table.batch_writer() as batch:
        for row in array_of_dict:
            response = batch.put_item(Item=row)


def lambda_handler(event, context):
    s3 = boto3.client("s3")
    if event:
        fileName=event["Records"][0]["s3"]["object"]["key"]
        csvFile = s3.get_object(Bucket=os.environ["BUCKET_NAME"], Key=fileName)
        csvFileContent = csvFile["Body"].read().decode("utf-8").split('\n')
        print("Payload Generation Started")
        GeneratePayload(OpenCSVFile(csvFileContent))
        print("Payload Generation Successful")
        print("DynamoDB batch write Started")
        WriteBatch(array_of_dict=array_of_dict)
        print("DynamoDB batch write Successful")