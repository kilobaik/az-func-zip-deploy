locals {
  zip_deployment_file = "./functions.zip"
}

resource "null_resource" "dependencies_setup_python" {
  provisioner "local-exec" {
    working_dir = "${path.module}/dependencies_builder"
    command     = "source ./dependencies_collector.sh ${var.function_code_dir}"
  }
  triggers = {
    always_run = timestamp()
  }
}

data "archive_file" "functions_code_compression" {
  type        = "zip"
  source_dir  = var.function_code_dir
  output_path = local.zip_deployment_file

  depends_on = [null_resource.dependencies_setup_python]
}

resource "null_resource" "function_app_publisher" {
  provisioner "local-exec" {
    command = "source ${path.module}/publisher.sh ${var.resource_group_name} ${azurerm_linux_function_app.function_app.name} ${local.zip_deployment_file}"
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [data.archive_file.functions_code_compression]
}

resource "null_resource" "function_app_cleaner" {
  provisioner "local-exec" {
    command = "rm -rf ${local.zip_deployment_file} ${var.function_code_dir}/.python_packages"
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [null_resource.function_app_publisher]
}