#!/usr/bin/env bash

# This script tries for ${max_attempts} times maximum to deploy/publish the function codes to the azure function app.

max_attempts=5
deployment_result=1
until [[ "$deployment_result" -eq 0 ]] || [[ "$max_attempts" -eq 0 ]]; do
  az functionapp deployment source config-zip -g "$1" -n "$2" --src "$3"
  deployment_result=$?
  max_attempts=$((max_attempts - 1))
done

exit $deployment_result
