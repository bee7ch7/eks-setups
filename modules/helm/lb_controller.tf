resource "helm_release" "aws_load_balancer_controller" {
  name = var.name #"aws-load-balancer-controller"

  repository = var.repository    #"https://aws.github.io/eks-charts"
  chart      = var.chart         #"aws-load-balancer-controller"
  namespace  = var.namespace     #"kube-system"
  version    = var.chart_version #"1.4.4"

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
