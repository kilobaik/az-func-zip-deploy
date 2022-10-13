locals {
  module_name    = "function_app"
  module_version = file("${path.module}/RELEASE")

  common_tags = {
    creator             = "terraform"
    module_name         = local.module_name
    module_version      = local.module_version
    terraform_workspace = terraform.workspace
  }
}