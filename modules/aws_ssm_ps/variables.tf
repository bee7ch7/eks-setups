variable "environment" {
  description = "Environment"
}

variable "parameters" {
  description = "Map with parameter settings"
  type        = map(any)
}
