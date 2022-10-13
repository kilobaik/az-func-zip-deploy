# Azure Function Zip-Deployment

## Introduction

In this repository, I will show how to deploy an Azure Function App and publish the code functions using Zip-Deploy
approach regardless of the development machine OS.

As an example, I will deploy an **Azure function App** with **HTTP trigger** and an **Azure Storage Account**.
The **HTTP trigger**, expect a request parameter `blob_name` and return the content of the corresponding blob if it does
exist in the `default` container ing the **Azure Storage Account**, otherwise it returns 404 not found.

![](./docs/az-func-zip-deploy-overview.png "Example system")

## Problem

After the (apparently) successful deployment, it's expected to read the content fo a blob in `default` container in the
storage account by calling `https://az-func-app-http.azurewebsites.net/api/HttpTrigger1?code=**&blob_name=test.txt` for
example.
Surprisingly, I got `500 INTERNAL_SERVER_ERROR` response. Thanks to **Azure Application Insights**, I can find the root
cause of that internal server error response.

The problem starts from my Mac-OS development machine, on which the dependencies are collected.
During deployment process,

One of the base dependency of `azure.storage.blob` module
is [cryptography](https://cryptography.io/en/latest/installation/#supported-platforms)
library, which has native code and is built differently depending on the OS.
However, my Azure Function App is `linux/amd64` which make it incompatible and therefore it lead to `ImportError`.

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
