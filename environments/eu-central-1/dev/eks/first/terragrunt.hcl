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
  source = "github.com/bee7ch7/terraform-aws-eks//."
}

dependency "vpc" {
  config_path                             = "../../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    vpc_id = "vpc_id"
  }
}

dependency "security_groups" {
  config_path                             = "../../security_groups/eks-remote-access"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    security_group_id = "mock_sg"
  }
}

dependency "eks_admins_iam_role" {
  config_path                             = "../iam/eks_admin_role"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::012345678912:role/xxx"
    iam_role_name = "mock_name"
  }
}

inputs = {
  cluster_name    = "${basename(get_terragrunt_dir())}-my-cluster"
  cluster_version = "1.24"
  create_kms_key  = false
  cluster_encryption_config = []

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnet_ids
  control_plane_subnet_ids = dependency.vpc.outputs.private_subnet_ids

 enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

    eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 3

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    tests = {
      desired_size = 1
      min_size     = 1
      max_size     = 3

      labels = {
        role = "tests"
      }

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }
  }
  // create_aws_auth_configmap = true
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = dependency.eks_admins_iam_role.outputs.iam_role_arn
      username = dependency.eks_admins_iam_role.outputs.iam_role_name
      groups   = ["system:masters"]
    }
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}