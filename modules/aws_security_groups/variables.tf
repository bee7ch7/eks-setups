variable "create" {
  type    = bool
  default = true
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

# variable "groups" {
#   type = map(any)
# }

variable "environment" {
  description = "Environment"
}

variable "name" {
  type = string
}

variable "ports_in" {
  type = list(any)
}

variable "ports_out" {
  type = map(any)
}
