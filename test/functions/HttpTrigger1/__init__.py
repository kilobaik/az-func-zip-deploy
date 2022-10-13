import os
import azure.functions as func
from azure.storage.blob import BlobServiceClient, ContainerClient


def main(req: func.HttpRequest) -> func.HttpResponse:
    blob_name = req.params.get('blob_name')

    conn_string = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
    container_name = 'default'

    blob_service_client: BlobServiceClient = BlobServiceClient.from_connection_string(conn_string)
    container_client: ContainerClient = blob_service_client.get_container_client(container_name)

    try:
        blob = next(filter(lambda _blob: _blob.name == blob_name, container_client.list_blobs()))
        blob_client = container_client.get_blob_client(blob.name)
        return func.HttpResponse(body=blob_client.download_blob().readall(), status_code=200)
    except StopIteration:
        return func.HttpResponse(body=f'Blob {blob_name} not found!', status_code=404)
