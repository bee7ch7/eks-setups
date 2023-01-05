output "acm_prime_arn" {
  value = module.acm.acm_certificate_arn
}

output "acm_prime_domain_names" {
  value = module.acm.distinct_domain_names
}
