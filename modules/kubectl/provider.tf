terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kubectl" {
  host                   = var.host                   #data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = var.cluster_ca_certificate #base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  exec {
    api_version = var.api_version #"client.authentication.k8s.io/v1beta1"
    args        = var.args        #["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = var.command     #"aws"
  }
}
