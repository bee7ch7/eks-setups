variable "zones" {
  type = map(object({
    comment = string
    tags    = map(any)
  }))
}
