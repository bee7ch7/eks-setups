module "route53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.9.0"
  zones   = var.zones
}
