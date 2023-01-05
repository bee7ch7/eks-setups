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
  source = "../../../../../modules/kubectl//."
}

dependency "eks" {
  config_path = "../first"
}

dependency "external-dns-role" {
  config_path = "../iam/external-dns"
}

inputs = {
  cluster_ca_certificate = base64decode(dependency.eks.outputs.cluster_certificate_authority_data)
  host                   = dependency.eks.outputs.cluster_endpoint
  api_version            = "client.authentication.k8s.io/v1beta1"
  args                   = ["eks", "get-token", "--cluster-name", dependency.eks.outputs.cluster_name]
  command                = "aws"

  yaml_body = {

    sa = <<-EOT
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${dependency.external-dns-role.outputs.iam_role_arn}
EOT

    rbac_cluster_role = <<-EOT
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "watch", "list"]
  - apiGroups: ["extensions", "networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get", "watch", "list"]
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["list", "watch"]
EOT

    rbac_cluster_role_bind = <<-EOT
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
  - kind: ServiceAccount
    name: external-dns
    namespace: kube-system
EOT

    deployment = <<-EOT
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: kube-system
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
        - name: external-dns
          image: k8s.gcr.io/external-dns/external-dns:v0.12.0
          args:
            - --source=service
            - --source=ingress
            - --provider=aws
            - --policy=upsert-only
            - --aws-zone-type=public
            - --registry=txt
            - --txt-owner-id=eks-identifier
      securityContext:
        fsGroup: 65534
    EOT
  }

}