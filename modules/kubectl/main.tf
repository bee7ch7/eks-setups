# resource "kubectl_manifest" "this" {
#   count     = var.create_kubectl_manifest ? length(var.yaml_body) : 0
#   yaml_body = element(var.yaml_body, count.index)
# }

resource "kubectl_manifest" "this" {
  for_each  = var.yaml_body
  yaml_body = each.value
}
