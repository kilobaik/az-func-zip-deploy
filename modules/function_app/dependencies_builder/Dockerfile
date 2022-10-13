FROM mcr.microsoft.com/azure-functions/python:4-python3.9

WORKDIR app

ARG REQ_FILE
ADD "$REQ_FILE" .
RUN mkdir -p ./.python_packages/lib/site-packages
RUN python3 -m pip install --target ./.python_packages/lib/site-packages -r ./requirements.txt

RUN chmod -R 755 .python_packages/lib/site-packages

CMD ["/bin/bash"]
