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
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-policy?ref=v5.9.2"
}

dependency "eks_admins_iam_role" {
  config_path = "../eks_admin_role"
}

inputs = {
  name          = "allow-assume-eks-admin-iam-role"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = dependency.eks_admins_iam_role.outputs.iam_role_arn
      },
    ]
  })
}