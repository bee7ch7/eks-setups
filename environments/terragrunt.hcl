locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment        = local.environment_config.locals.environment
  aws_main_account   = get_env("AWS_MAIN_ACCOUNT", "NO_VALUE_SET")
  paths              = split("/", get_path_from_repo_root())
}

remote_state {
  backend = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket  = "${local.environment}-tfstates.tg.com"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

inputs = {
  aws_region  = local.paths[1]
  environment = local.paths[2]
}

generate "myconfig" {
  path      = "_config.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "aws" {
    region = var.aws_region

    default_tags {
        tags = {
            Company    = "meldm"
            Terraform  = "True"
            Created_by = "meldm"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    alias  = "acm"

    default_tags {
        tags = {
            Company    = "meldm"
            Terraform  = "True"
            Created_by = "meldm"
        }
    }
}

variable "aws_region" {}

EOF
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
  }
}
