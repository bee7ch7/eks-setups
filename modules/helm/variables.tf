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
    type = list
}
variable "command" {
    type = string
}


variable "name" {
    type = string
}
variable "repository" {
    type = string
}
variable "chart" {
    type = string
}
variable "namespace" {
    type = string
}
variable "chart_version" {
    type = string
}
variable "settings" {
    type = map(any)
}