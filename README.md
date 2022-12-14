# Azure Function | Zip-Deployment regardless of OS type

## Introduction

In this repository, I will show how to deploy an Azure Function App and publish the code functions using Zip-Deploy
approach regardless of the development machine OS.

As an example, I will deploy an Azure function App with HTTP trigger and an Azure Storage Account.
The HTTP trigger expects a request parameter `blob_name` and returns the content of the corresponding blob if it does
exist in the `default` container in the Azure Storage Account, otherwise it returns 404 not found.

![](./docs/az-func-zip-deploy-overview.png "Example system")

## Problem

After the a (apparently) successful deployment, it was expected to read the content of a blob in `default` container in
the
storage account by calling `https://az-func-app-http.azurewebsites.net/api/HttpTrigger1?code=**&blob_name=test.txt` for
example. However, surprisingly, I got `500 INTERNAL_SERVER_ERROR` response.

Thanks to Azure Application Insights, I could find the root
cause of that internal server error response.
The problem starts from my Macbook development machine, on which the dependencies are collected.

During deployment process, one of the base dependency of `azure.storage.blob` module
is [cryptography](https://cryptography.io/en/latest/installation/#supported-platforms)
library, which has native code and is built differently depending on the OS.
Since, I do have a `macOS Monterery`, the runtime environment is incompatible with any other OS (such as my Azure Function App OS).

My Azure Function App uses `linux/amd64` OS, which will not work definitely with the dependencies built on
`macOS Monterery` and will raise an `ImportError`.

> ```python
> Result: Failure Exception: ImportError:
>     /home/site/wwwroot/.python_packages/lib/site-packages/cryptography/hazmat/bindings/_rust.abi3.so: invalid ELF header.
>     Please check the requirements.txt file for the missing module.
>     For more info, please refer the troubleshooting guide: https://aka.ms/functions-modulenotfound Stack:
>     ... 
>     in _call_with_frames_removed File "/home/site/wwwroot/HttpTrigger1/__init__.py",  line 3,
>     in <module> from azure.storage.blob import BlobServiceClient, ContainerClient File "/home/site/wwwroot/.python_packages/lib/site-packages/azure/storage/blob/__init__.py", line 10,
>     in <module> from ._blob_client import BlobClient File "/home/site/wwwroot/.python_packages/lib/site-packages/azure/storage/blob/_blob_client.py", line 55, 
>     ...
>     in <module> from cryptography.x509 import certificate_transparency File "/home/site/wwwroot/.python_packages/lib/site-packages/cryptography/x509/certificate_transparency.py", line 10,
>     in <module> from cryptography.hazmat.bindings._rust import x509 as rust_x509
> ```

## Solution

> _**Hint:** Docker must be installed and running on the development machine first._

To solve the issue, we need to build the dependencies on the OS used by our Azure Function App.
This could be done of course using [Docker](https://docs.docker.com) relying on
the `mcr.microsoft.com/azure-functions/python` image
_(all supported azure function images could be found [here](https://hub.docker.com/_/microsoft-azure-functions))_.

So, step-by-step solution is as following:

1. Deploy the essential infrastructures (App Service plan, Function App and Storage Account).
2. Build a Docker container and install the dependencies inside it.
3. Copy the dependencies from the docker container to `.python_packages` in the source code folder (of the functions).
4. Compress the source code folder of the functions in a ZIP file.
5. Publish the code using `az functionapp deployment source config-zip`


![](./docs/az-func-zip-deploy.png "Zip-Deployment")


## Test

> **Prerequisite**:
> You need to install the following tools:
>   1. Azure CLI
>   2. Docker
>   3. Terraform

In the `./test` directory, there is a sample code you can rely one to test

```
./test
    - /functions - contains Http trigger implemented in python with the requirements.
    - /main - contains terraform code.
```

1. Login to your azure subscription using Azure CLI `az login`
2. Set your subscription as a default one `az account set -s ${SUBSCRIPTION_ID}`
3. Create a resource group to play with `az group create -l ${LOCATION} -n ${RESOURCE_GROUP_NAME}`
4. Modify `main/main.tf` local variables `local.resource_group_name` and `local.location` to match the name and the location of your resource group.
5. Go to `test/main` folder and run `terraform init`
6. Apply the changes `terraform apply --auto-approve`
7. Upload some file to the `default` container to test


![](./docs/blob-not-found-example.png "Blob not found example")
![](./docs/blob-found-example.png "Blob found example")


## Conclusion

There is always another way to do any task in my opinion, and you should be always able to decide which approach you want
to follow, come up with your own solution and shape in the way you want.
However, such decision is not easy to take if you're not aware bout the available approaches and your system  requirements.

For example, deploying Azure Function App code could be done using [Zip Deploy](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#zip-deploy), [Web Deploy](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#web-deploy-msdeploy), [Source control](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#source-control) or even [Local Git](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#local-git).
It's not restricted by [Zip Deploy](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#zip-deploy), but that was my favourite solution to accelerate the development cycle.
Furthermore, it is the recommended deployment technology for Azure Functions according to [Azure documentation](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies)
