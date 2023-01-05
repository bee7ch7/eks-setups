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
  source = "../../../../../modules/helm//."
}

dependency "eks" {
  config_path = "../first"
}

dependency "lb_role" {
  config_path = "../iam/lb"
}

inputs = {
  cluster_ca_certificate = base64decode(dependency.eks.outputs.cluster_certificate_authority_data)
  host                   = dependency.eks.outputs.cluster_endpoint
  api_version            = "client.authentication.k8s.io/v1beta1"
  args                   = ["eks", "get-token", "--cluster-name", dependency.eks.outputs.cluster_name]
  command                = "aws"

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart_version    = "1.4.4"
  settings = {
    1 = {
      name  = "replicaCount"
      value = 1
    }

    2 = {
      name  = "clusterName"
      value = dependency.eks.outputs.cluster_name
    }

    3 = {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }

    4 = {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = dependency.lb_role.outputs.iam_role_arn
    }
  }

}