module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.1.0"

  # providers = {
  #   aws = aws
  # }

  domain_name = var.domain_name
  zone_id     = var.zone_id

  subject_alternative_names = var.subject_alternative_names

}
