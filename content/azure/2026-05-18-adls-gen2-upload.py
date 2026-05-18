"""Upload a local file to ADLS Gen2."""
from azure.storage.filedatalake import DataLakeServiceClient
import os

client = DataLakeServiceClient.from_connection_string(os.environ['ADLS_CONN'])
fs = client.get_file_system_client('raw')
file_client = fs.get_file_client('data/upload.parquet')
with open('local.parquet','rb') as f:
    file_client.upload_data(f.read(), overwrite=True)
print('Upload complete')
