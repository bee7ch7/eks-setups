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
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-assumable-role?ref=v5.9.2"
}

dependency "eks_admin_policy" {
    config_path = "../eks_admin_policy"

}

inputs = {
  role_name         = "eks-admin"
  create_role       = true
  role_requires_mfa = false

  custom_role_policy_arns = [dependency.eks_admin_policy.outputs.arn]

  trusted_role_arns = [
    "arn:aws:iam::${get_aws_account_id()}:root"
  ]
}