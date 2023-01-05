include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment        = local.environment_config.locals.environment
  aws_region         = local.environment_config.locals.aws_region
  paths              = split("/", get_path_from_repo_root())
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-group-with-policies?ref=v5.9.2"
}

dependency "eks_admin_policy_assume" {
  config_path = "../eks_admin_policy_assume"
}

inputs = {
  name                              = "eks-admin"
  attach_iam_self_management_policy = false
  create_group                      = true
  group_users                       = ["devops-user", "user1"]
  custom_group_policy_arns          = [dependency.eks_admin_policy_assume.outputs.arn]
}