locals {
  environment      = "${basename(get_terragrunt_dir())}"
  aws_region       = "eu-central-1"
  aws_main_account = get_env("AWS_MAIN_ACCOUNT", "NO_VALUE_SET")
}
