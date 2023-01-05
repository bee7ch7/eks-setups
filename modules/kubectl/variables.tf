variable "cluster_ca_certificate" {
  type = string
}
variable "host" {
  type = string
}
variable "api_version" {
  type = string
}
variable "args" {
  type = list(any)
}
variable "command" {
  type = string
}
variable "tags" {
  type    = map(any)
  default = {}
}
variable "create_kubectl_manifest" {
  type = bool
  default = true
}

# variable "yaml_body" {
#     type = list(any) 
#     default = []
# }
variable "yaml_body" {
    type = map(any) 
    default = {}
}
